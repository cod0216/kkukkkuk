package com.be.KKUKKKUK.domain.doctor.controller;

import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorUpdateRequest;
import com.be.KKUKKKUK.domain.doctor.service.DoctorService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
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
 * 25.03.22          haelim           swagger 추가 <br>
 */

@Tag(name = "수의사 관리 API", description = "병원에서 수의사 정보를 조회, 수정, 삭제할 수 있는 API입니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/doctors")
public class DoctorController {
    private final DoctorService doctorService;

    /**
     * 특정 수의사의 정보를 조회합니다.
     * @param doctorId 조회할 수의사 id
     * @return 조회된 수의사 정보
     */
    @Operation(summary = "수의사 정보 조회", description = "특정 수의사의 정보를 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수의사 정보 조회 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "403", description = "접근 권한 없음")
    })
    @GetMapping("/{doctorId}")
    public ResponseEntity<?> getDoctorById(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                           @PathVariable @Min(1) Integer doctorId
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("수의사 정보가 성공적으로 조회되었습니다.", doctorService.getDoctorInfoById(hospitalId, doctorId));
    }

    /**
     * 특정 수의사의 정보를 수정합니다.
     * @param hospitalDetails 인증된 병원 계정 정보
     * @param doctorId 수정할 수의사 id
     * @return 수정된 수의사 정보
     */
    @Operation(summary = "수의사 정보 수정", description = "특정 수의사의 정보를 수정합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수의사 정보 수정 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "403", description = "접근 권한 없음")
    })
    @PutMapping("/{doctorId}")
    public ResponseEntity<?> updateDoctor(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                          @PathVariable @Min(1) Integer doctorId,
                                          @RequestBody @Valid DoctorUpdateRequest request
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
    @Operation(summary = "수의사 삭제", description = "특정 수의사를 동물 병원에서 삭제합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수의사 삭제 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "403", description = "접근 권한 없음")
    })
    @DeleteMapping("/{doctorId}")
    public ResponseEntity<?> deleteDoctorOnHospital(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                                    @PathVariable @Min(1) Integer doctorId
    ) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        doctorService.deleteDoctorOnHospital(hospitalId, doctorId);
        return ResponseUtility.emptyResponse("수의사가 정상적으로 삭제되었습니다.");
    }
}
