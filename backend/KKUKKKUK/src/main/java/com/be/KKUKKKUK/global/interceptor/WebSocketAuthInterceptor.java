package com.be.KKUKKKUK.global.interceptor;

import com.be.KKUKKKUK.domain.hospital.service.HospitalDetailService;
import com.be.KKUKKKUK.domain.owner.service.OwnerDetailService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.util.JwtUtility;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.global.config<br>
 * fileName       : WebSocketConfig.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : stomp 웹소켓 통신을 위한 intercepter 클래스입니다. <br>
 *                  사용자 요청 header 에서 jwt 토큰을 검증합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketAuthInterceptor implements ChannelInterceptor {
    private final JwtUtility jwtUtility;
    private final OwnerDetailService ownerDetailService;
    private final HospitalDetailService hospitalDetailService;

    private static final String HEADER_BEARER = "Bearer ";
    private static final String HEADER_AUTHORIZATION = "Authorization";
    private static final int HEADER_BEARER_LENGTH = HEADER_BEARER.length();

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);

        if (StompCommand.CONNECT.equals(accessor.getCommand())) {
            String token = extractToken(accessor);
            if (Objects.isNull(token) || jwtUtility.validateToken(token)) {
                throw new ApiException(ErrorCode.INVALID_TOKEN);
            }
            Authentication authentication = getAuthentication(token);
            accessor.setUser(authentication);
        }
        return message;
    }

    private String extractToken(StompHeaderAccessor accessor) {
        List<String> authorizationHeaders = accessor.getNativeHeader(HEADER_AUTHORIZATION);
        log.debug("Authorization header: {}", authorizationHeaders);

        if (Objects.nonNull(authorizationHeaders) && !authorizationHeaders.isEmpty()) {
            String authHeader = authorizationHeaders.get(0);
            log.debug("authHeader : {}", authHeader);
            if (authHeader.startsWith(HEADER_BEARER)) {
                return authHeader.substring(HEADER_BEARER_LENGTH);
            }
        }
        log.debug("Authorization header is empty");
        return null;
    }

    private Authentication getAuthentication(String token) {
        RelatedType userType = jwtUtility.getUserType(token);
        Integer userId = jwtUtility.getUserId(token);

        UserDetails userDetails;
        if (userType == RelatedType.OWNER) {
            userDetails = ownerDetailService.loadUserByUsername(userId.toString());
        } else if (userType == RelatedType.HOSPITAL) {
            userDetails = hospitalDetailService.loadUserByUsername(userId.toString());
        } else {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        return new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
    }
}
