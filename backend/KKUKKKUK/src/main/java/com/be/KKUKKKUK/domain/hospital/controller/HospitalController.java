package com.be.KKUKKKUK.domain.hospital.controller;

import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorRegisterRequest;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.service.HospitalComplexService;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
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
 */
@RestController
@RequestMapping("/api/hospitals")
@RequiredArgsConstructor
public class HospitalController {
    private final HospitalComplexService hospitalComplexService;
    private final HospitalService hospitalService;


    /**
     * 인허가 번호로 동물병원을 조회합니다.
     * @param authorizationNumber 조회할 인허가 번호
     * @return 조회된 병원 정보
     */
    @GetMapping("/authorization-number/{authorizationNumber}")
    public ResponseEntity<?> getHospitalByAuthorizationNumber(
            @PathVariable String authorizationNumber) {
        return ResponseUtility.success("인허가번호로 조회한 동물병원 정보입니다.", hospitalService.getHospitalByAuthorizationNumber(authorizationNumber));
    }

    /**
     * 병원 이름으로 동물병원을 조회합니다.
     * @param name 조회할 동물병원 이름
     * @return 조회된 병원 정보
     */
    @GetMapping("/name/{name}")
    public ResponseEntity<?> getHospitalsByName(
            @PathVariable String name) {
        return ResponseUtility.success("이름으로 조회한 동물병원 정보입니다.", hospitalService.getHospitalListByName(name));
    }

    /**
     * 동물병원 계정 사용 가능 여부를 조회합니다.
     * @param account 조회할 계정
     * @return 사용 가능 여부 true / false
     */
    @GetMapping("/account/{account}")
    public ResponseEntity<?> checkAccountAvailable(@PathVariable String account) {
        Boolean flagAvailable = hospitalService.checkAccountAvailable(account);
        return ResponseUtility.success( flagAvailable ? "사용 가능한 계정입니다." : "사용할 수 없는 계정입니다.", flagAvailable);
    }

    /**
     * 현재 로그인한 동물병원 계정의 상세 정보를 조회합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @return 병원의 상세 정보
     */
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
    @PatchMapping("/me")
    public ResponseEntity<?> updateHospitalInfoMine(
            @AuthenticationPrincipal HospitalDetails hospitalDetails,
            @Validated @RequestBody HospitalUpdateRequest request) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success( "동물병원 정보가 성공적으로 수정되었습니다.", hospitalService.updateHospital(hospitalId, request));
    }

    /**
     * 새로운 수의사를 동물 병원에 등록합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
-     * @return 성공 여부
     */
    @PostMapping("/me/doctors")
    public ResponseEntity<?> registerDoctorOnHospital(
            @AuthenticationPrincipal HospitalDetails hospitalDetails,
            @RequestBody DoctorRegisterRequest request
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("수의사 등록이 정상적으로 완료되었습니다.", hospitalComplexService.registerDoctor(hospitalId, request));
    }


    /**
     * 현재 로그인한 동물병원의 계정의 의사 목록을 조회합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @return 의사 목록
     */
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
