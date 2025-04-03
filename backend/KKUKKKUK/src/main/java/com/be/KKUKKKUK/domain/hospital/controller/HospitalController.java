package com.be.KKUKKKUK.domain.hospital.controller;

import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorRegisterRequest;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUnsubscribeRequest;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.service.HospitalComplexService;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
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
 * 25.03.20          haelim           진료 기록 관련 api 추가 <br>
 * 25.03.22          haelim           swagger 작성 <br>
 * 25.03.28          haelim           treatment 관련 api 삭제 <br>
 */
@Tag(name = "병원 API", description = "병원 정보 관리, 병원 소속 수의사, 병원의 진료 기록 등을 관리하는 API입니다.")
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/hospitals")
public class HospitalController {
    private final HospitalComplexService hospitalComplexService;
    private final HospitalService hospitalService;

    /**
     * 인허가 번호로 동물병원을 조회합니다.
     * 인허가 번호는 18자리 숫자로 이루어져 있습니다. ( ^[0-9]{18}$ )
     * @param authorizationNumber 조회할 인허가 번호
     * @return 조회된 병원 정보
     */
    @Operation(summary = "인허가 번호로 병원 조회", description = "인허가 번호를 통해 병원 정보를 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    @GetMapping("/authorization-number/{authorizationNumber}")
    public ResponseEntity<?> getHospitalByAuthorizationNumber(@PathVariable @Pattern(regexp = "^[0-9]{18}$") String authorizationNumber) {
        return ResponseUtility.success("인허가번호로 조회한 동물병원 정보입니다.", hospitalService.getHospitalByAuthorizationNumber(authorizationNumber));
    }

    /**
     * 병원 이름으로 동물병원을 조회합니다.
     * @param name 조회할 동물병원 이름
     * @return 조회된 병원 정보
     */
    @Operation(summary = "병원 이름으로 조회", description = "이름을 통해 병원 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    @GetMapping("/name/{name}")
    public ResponseEntity<?> getHospitalsByName(@PathVariable @Size(min = 1, max = 30) String name) {
        return ResponseUtility.success("이름으로 조회한 동물병원 정보입니다.", hospitalService.getHospitalListByName(name));
    }

    /**
     * 동물병원 계정 사용 가능 여부를 조회합니다.
     * 계정은 5~10자의 영문 소문자, 숫자, 밑줄(_)만 허용됩니다. ( ^[a-z0-9_]{5,10} )
     * @param account 조회할 계정
     * @return 사용 가능 여부 true / false
     */
    @Operation(summary = "계정 사용 가능 여부 확인", description = "해당 계정이 사용 가능한지 확인합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    @GetMapping("/account/{account}")
    public ResponseEntity<?> checkAccountAvailable(@PathVariable @NotBlank @Pattern(regexp = "^[a-z0-9_]{5,10}$") String account) {
        Boolean flagAvailable = hospitalService.checkAccountAvailable(account);
        return ResponseUtility.success( flagAvailable ? "사용 가능한 계정입니다." : "사용할 수 없는 계정입니다.", flagAvailable);
    }

    /**
     * 현재 로그인한 동물병원 계정의 상세 정보를 조회합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @return 병원의 상세 정보
     */
    @Operation(summary = "내 병원 정보 조회", description = "현재 로그인한 병원의 정보를 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    @GetMapping("/me")
    public ResponseEntity<?> getHospitalInfoMine(@AuthenticationPrincipal HospitalDetails hospitalDetails) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success( "동물병원 정보 조회에 성공했습니다.", hospitalService.getHospitalDetailInfoById(hospitalId));
    }

    /**
     * 현재 로그인한 동물병원 계정의 정보를 수정합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @param request 수정할 동물병원의 정보 요정
     * @return 수정된 동물병원의 정보 결과
     */
    @Operation(summary = "내 병원 정보 수정", description = "현재 로그인한 병원의 정보를 수정합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청")
    })
    @PatchMapping("/me")
    public ResponseEntity<?> updateHospitalInfoMine(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                                    @RequestBody @Valid HospitalUpdateRequest request
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success( "동물병원 정보가 성공적으로 수정되었습니다.", hospitalService.updateHospital(hospitalId, request));
    }

    @Operation(summary = "동물병원 회원 탈퇴", description = "동물 병원 회원이 서비스에서 탈퇴합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "탈퇴 성공")
    })
    @DeleteMapping("/me")
    public ResponseEntity<?> unsubscribeHospital(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                                    @RequestBody @Valid HospitalUnsubscribeRequest request
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        hospitalComplexService.unSubscribeHospital(hospitalId, request);
        return ResponseUtility.emptyResponse( "동물병원 계정이 정상적으로 탈퇴되었습니다.");
    }


    /**
     * 새로운 수의사를 동물 병원에 등록합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
-     * @return 성공 여부
     */
    @Operation(summary = "병원에 수의사 등록", description = "현재 로그인한 병원에 새로운 수의사를 등록합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "등록 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청")
    })
    @PostMapping("/me/doctors")
    public ResponseEntity<?> registerDoctorOnHospital(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                                      @RequestBody @Valid DoctorRegisterRequest request
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("수의사 등록이 정상적으로 완료되었습니다.", hospitalComplexService.registerDoctor(hospitalId, request));
    }


    /**
     * 현재 로그인한 동물병원의 계정의 의사 목록을 조회합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @return 의사 목록
     */
    @Operation(summary = "병원의 모든 수의사 조회", description = "현재 로그인한 병원에 등록된 수의사 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공")
    })
    @GetMapping("/me/doctors")
    public ResponseEntity<?> getAllDoctorsOnHospital(@AuthenticationPrincipal HospitalDetails hospitalDetails) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success( "동물 병원의 수의사 목록입니다.", hospitalComplexService.getAllDoctorsOnHospital(hospitalId));
    }

    /**
     * TODO : service 구현 끝내기
     * 요청된 위치 좌표(xAxis, yAxis) 주변의 동물병원 목록을 조회합니다.
     * @param xAxis 기준 x좌표
     * @param yAxis 기준 y좌표
     * @param radius 조회 반경
     * @return 주변 동물 병원 목록
     */
    //@GetMapping("/")
    public ResponseEntity<?> getAllHospitalsByAxis(
            @RequestParam @NotNull(message = "xAxis 값은 필수입니다.")
            @Min(value = -180, message = "xAxis(경도)는 -180 이상이어야 합니다.")
            @Max(value = 180, message = "xAxis(경도)는 180 이하여야 합니다.")
            Double xAxis,

            @RequestParam @NotNull(message = "yAxis 값은 필수입니다.")
            @Min(value = -90, message = "yAxis(위도)는 -90 이상이어야 합니다.")
            @Max(value = 90, message = "yAxis(위도)는 90 이하여야 합니다.")
            Double yAxis,

            @RequestParam @NotNull(message = "radius 값은 필수입니다.")
            @Min(value = 1, message = "반경(radius)은 1 이상이어야 합니다.")
            Integer radius
    )
    {
        return ResponseUtility.success( "조회된 동물병원 목록입니다.", hospitalService.getAllHospital(xAxis, yAxis, radius));
    }
}
