package com.be.KKUKKKUK.domain.hospital.controller;

import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
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
@RequestMapping("/api/hospitals")
@Slf4j //TODO 필요할까요??
@RequiredArgsConstructor
@Controller
public class HospitalController {
    private final HospitalService hospitalService;

    @GetMapping("/authorization-number/{authorizationNumber}")
    public ResponseEntity<?> getHospitalByAuthorizationNumber(
            @PathVariable String authorizationNumber) {
        return ResponseUtility.success("인허가번호로 조회한 동물병원 정보입니다.", hospitalService.getHospitalByAuthorizationNumber(authorizationNumber));
    }

    @GetMapping("/account/{account}")
    public ResponseEntity<?> checkAccountAvailable(@PathVariable String account) {
        Boolean flagAvailable = hospitalService.checkAccountAvailable(account);
        return ResponseUtility.success( flagAvailable ? "사용 가능한 계정입니다." : "사용할 수 없는 계정입니다.", flagAvailable);
    }

    @GetMapping("/license/{licenseNumber}")
    public ResponseEntity<?> checkLicenseAvailable(@PathVariable String licenseNumber) {
        Boolean flagAvailable = hospitalService.checkLicenseAvailable(licenseNumber);
        return ResponseUtility.success( flagAvailable ? "사용 가능한 라이센스입니다." : "사용할 수 없는 라이센스입니다.", flagAvailable);
    }

    @GetMapping("/me")
    public ResponseEntity<?> getHospitalInfoMine(
            @AuthenticationPrincipal HospitalDetails hospitalDetails
    ) {
        Integer id = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success( "동물병원 정보 조회에 성공했습니다.", hospitalService.getHospitalById(id));
    }

    @PutMapping("/me")
    public ResponseEntity<?> updateHospitalInfoMine(
            @AuthenticationPrincipal HospitalDetails hospitalDetails,
            @Validated @RequestBody HospitalUpdateRequest request) {
        Integer id = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success( "동물병원 정보가 성공적으로 수정되었습니다.", hospitalService.updateHospital(id, request));
    }

}
