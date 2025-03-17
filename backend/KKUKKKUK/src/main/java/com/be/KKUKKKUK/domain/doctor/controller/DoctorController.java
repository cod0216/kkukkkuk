package com.be.KKUKKKUK.domain.doctor.controller;

import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorUpdateRequest;
import com.be.KKUKKKUK.domain.doctor.service.DoctorService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.controller<br>
 * fileName       : DoctorController.java<br>
 * author         : haelim<br>
 * date           : 2025-03-16<br>
 * description    : hospital entity 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.16          haelim           최초 생성<br>
 */

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/doctors")
public class DoctorController {
    private final DoctorService doctorService;

    /**
     * 특정 수의사의 정보를 조회합니다.
     * @param doctorId 수정할 수의사 id
     * @return 조회된 수의사 정보
     */
    @GetMapping("/{doctorId}")
    public ResponseEntity<?> getDoctorById(@AuthenticationPrincipal HospitalDetails hospitalDetails, @PathVariable Integer doctorId) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("수의사 정보가 성공적으로 업데이트되었습니다.", doctorService.getDoctorInfoById(hospitalId, doctorId));
    }

    /**
     * 특정 수의사의 정보를 수정합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @param doctorId 수정할 수의사 id
     * @return 수정된 수의사 정보
     */
    @PutMapping("/{doctorId}")
    public ResponseEntity<?> updateDoctor(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                          @PathVariable Integer doctorId,
                                          @RequestBody DoctorUpdateRequest request
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("수의사 정보가 성공적으로 업데이트되었습니다.", doctorService.updateDoctorOnHospital(hospitalId, doctorId, request));
    }

    /**
     * 특정 수의사를 동물 병원에서 삭제합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @param doctorId 삭제할 수의사 id
     * @return 성공 여부
     */
    @DeleteMapping("/{doctorId}")
    public ResponseEntity<?> deleteDoctorOnHospital(@AuthenticationPrincipal HospitalDetails hospitalDetails, @PathVariable Integer doctorId) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        doctorService.deleteDoctorOnHospital(hospitalId, doctorId);
        return ResponseUtility.success("수의사가 정상적으로 삭제되었습니다.", null);
    }

}
