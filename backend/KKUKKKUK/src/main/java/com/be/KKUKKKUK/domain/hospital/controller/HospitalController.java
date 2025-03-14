package com.be.KKUKKKUK.domain.hospital.controller;

import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalAuthorizationResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalUpdateResponse;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.api.ApiResponseWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.controller<br>
 * fileName       : HospitalController.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : hospital entity 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@RequestMapping("/api/hospitals")
@Slf4j
@RequiredArgsConstructor
@Controller
public class HospitalController {
    private final HospitalService hospitalService;

    @ApiResponseWrapper(message = "인허가번호로 조회한 동물병원 정보입니다.")
    @GetMapping("/authorization-number/{authorizationNumber}")
    public ResponseEntity<HospitalAuthorizationResponse> getHospitalByAuthorizationNumber(
            @PathVariable String authorizationNumber) {
        return ResponseEntity.ok(hospitalService.getHospitalByAuthorizationNumber(authorizationNumber));
    }

    @ApiResponseWrapper
//    @ApiResponseWrapper(message = "사용 가능한 계정입니다.")
    @GetMapping("/account/{account}")
    public ResponseEntity<Boolean> checkAccountAvailable(
            @PathVariable String account) {
        return ResponseEntity.ok(hospitalService.checkAccountAvailable(account));
    }

    @ApiResponseWrapper
//    @ApiResponseWrapper(message = "사용 가능한 라이센스입니다.")
    @GetMapping("/license/{licenseNumber}")
    public ResponseEntity<Boolean> checkLicenseAvailable(
            @PathVariable String licenseNumber) {
        return ResponseEntity.ok(hospitalService.checkLicenseAvailable(licenseNumber));
    }

    @ApiResponseWrapper(message = "동물병원 정보가 성공적으로 수정되었습니다.")
    @PutMapping("/me")
    public ResponseEntity<HospitalUpdateResponse> updateHospital(
            @AuthenticationPrincipal HospitalDetails hospitalDetails,
            @RequestBody HospitalUpdateRequest request) {
        log.info("updateHospital request: {}", request);
        Integer id = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseEntity.ok(hospitalService.updateHospital(id, request));
    }
}
