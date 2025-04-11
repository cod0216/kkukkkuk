import { BlockChainRecord } from '@/interfaces/blockChain';
import { sanitizeObject, safeJsonParse } from '@/utils/jsonParser';


/**
 * 특정 진료 기록의 이전 수정 이력을 가져오는 함수
 * @param currentRecord 현재 진료 기록 (최신 수정본 또는 원본)
 * @param petDID 반려동물 DID 주소
 * @returns 현재 기록을 제외한 모든 관련 기록 배열 (최신순으로 정렬, 원본이 마지막에 위치)
 */
export const getRecordChanges = async (
    currentRecord: BlockChainRecord,
  petDID: string
): Promise<BlockChainRecord[]> => {
  // 결과를 저장할 배열
    const historyChain: BlockChainRecord[] = [];
    
  try {
    console.log('getRecordChanges 호출:', { 
      recordId: currentRecord.id, 
      isOriginal: currentRecord.id?.startsWith('medical_record_'),
      previousRecord: currentRecord.previousRecord,
      petDID
    });
    
    // 현재 기록이 원본인지 확인
    const isOriginal = currentRecord.id?.startsWith('medical_record_');
    
    // 원본 기록 ID 확인
    let originalRecordId: string;
    
    if (isOriginal) {
      // 현재 기록이 원본인 경우, 현재 기록 ID를 원본 ID로 사용
      originalRecordId = currentRecord.id || '';
      
      // 원본 기록에 대한 수정본들이 있을 수 있으므로, 병원이 접근 가능한 모든 기록을 검색하는 것이 필요함
      // 하지만 현재는 수정본의 previousRecord 를 따라가는 방식으로 이력을 조회하고 있어 원본에서는 수정본을 찾을 수 없음
      // 이 부분은 향후 개선 필요 (현재는 원본인 경우 빈 배열 반환)
      console.log('원본 기록에 대한 수정본 조회는 현재 지원되지 않습니다.');
      return [];
    } else {
      // 현재 기록이 수정본인 경우, previousRecord 필드에서 원본 ID 확인
      originalRecordId = currentRecord.previousRecord || '';
      
      if (!originalRecordId) {
        console.warn('원본 기록 ID를 찾을 수 없습니다.');
        return [];
      }
    }
    
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      console.error('MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.');
      return [];
    }
    
    console.log(`병원 계정이 ${petDID} 반려동물에 대한 원본 기록 ${originalRecordId}와 관련된 모든 수정 기록을 조회합니다.`);
    
    // 원본 기록과 모든 수정 기록 가져오기
    const [originalRecord, updateRecords] = await contract.getMedicalRecordWithUpdates(petDID, originalRecordId);
    
    console.log(`원본 기록 및 수정 기록 조회 완료: 원본 1개, 수정본 ${updateRecords.length}개`);
    
    // 원본 기록 파싱
    const originalData = safeJsonParse(originalRecord, {});
    if (!originalData || originalData.isDeleted) {
      console.warn('원본 기록이 삭제되었거나 유효하지 않습니다.');
      return [];
    }
    
    // 원본 기록의 타임스탬프 추출
    let originalTimestamp = 0;
    if (originalData.createdAt) {
      originalTimestamp = Number(originalData.createdAt);
    } else if (originalData.timestamp) {
      originalTimestamp = Number(originalData.timestamp);
    } else if (originalRecordId.startsWith('medical_record_')) {
      const parts = originalRecordId.split('_');
      if (parts.length >= 3) {
        try {
          originalTimestamp = Number(parts[2]);
        } catch (e) {
          originalTimestamp = 0;
        }
      }
    }
    
    // 원본 기록 객체 생성
    const originalBlockchainRecord: BlockChainRecord = {
      id: originalRecordId,
      diagnosis: originalData.diagnosis || '정보 없음',
      hospitalName: originalData.hospitalName || '병원 정보 없음',
      doctorName: originalData.doctorName || '',
      notes: originalData.notes || '',
      createdAt: String(originalTimestamp),
      timestamp: originalTimestamp,
      isDeleted: false,
      hospitalAddress: originalData.hospitalAddress || '',
      pictures: originalData.pictures || [],
      previousRecord: '',
      status: originalData.status || 'IN_PROGRESS',
      treatments: originalData.treatments || {
        examinations: [],
        medications: [],
        vaccinations: []
      },
      flagCertificated: originalData.flagCertificated,
      hospitalAccountId: originalData.hospitalAccountId || '',
    };
    
    // 모든 수정 기록을 처리하여 현재 기록을 제외한 이전 수정 기록만 추가
    const validUpdateRecords: BlockChainRecord[] = [];
    
    for (let i = 0; i < updateRecords.length; i++) {
      try {
        const parsedUpdate = safeJsonParse(updateRecords[i], {});
        if (!parsedUpdate || parsedUpdate.isDeleted) {
          continue; // 삭제된 기록은 건너뜀
        }
        
        // 현재 기록과 같은 ID인지 확인하여 제외
        if (parsedUpdate.id === currentRecord.id) {
          console.log('현재 기록과 동일한 ID를 가진 수정본은 이력에서 제외합니다:', parsedUpdate.id);
          continue; // 현재 기록(최신 수정본)은 제외
        }
        
        // 이미지 URL 디버깅
        console.log('수정 기록 pictures 필드:', {
          recordId: parsedUpdate.id || 'ID 없음',
          hasPictures: !!parsedUpdate.pictures,
          picturesType: parsedUpdate.pictures ? typeof parsedUpdate.pictures : 'undefined',
          isArray: parsedUpdate.pictures ? Array.isArray(parsedUpdate.pictures) : false,
          picturesLength: parsedUpdate.pictures && Array.isArray(parsedUpdate.pictures) ? parsedUpdate.pictures.length : 0,
          picturesContent: parsedUpdate.pictures
        });
        
        // 수정 기록 타임스탬프 추출
        let updateTimestamp = 0;
        if (parsedUpdate.createdAt) {
          updateTimestamp = Number(parsedUpdate.createdAt);
        } else if (parsedUpdate.timestamp) {
          updateTimestamp = Number(parsedUpdate.timestamp);
        }
        
        // ID로부터 타임스탬프 추출 시도
        if (updateTimestamp === 0 && parsedUpdate.id && parsedUpdate.id.includes('_')) {
          const parts = parsedUpdate.id.split('_');
          if (parts.length >= 3) {
            try {
              const idTimestamp = Number(parts[2]);
              if (!isNaN(idTimestamp) && idTimestamp > 0) {
                updateTimestamp = idTimestamp;
              }
            } catch (e) {
              console.warn('ID에서 타임스탬프 추출 실패:', e);
            }
          }
        }
        
        // 타임스탬프가 여전히 0이면 현재 시간 사용
        if (updateTimestamp === 0) {
          updateTimestamp = Math.floor(Date.now() / 1000);
        }
        
        // 이전 기록과 타임스탬프가 동일한 경우 1초씩 차이 추가
        if (validUpdateRecords.length > 0) {
          const lastRecord = validUpdateRecords[validUpdateRecords.length - 1];
          if (lastRecord.timestamp === updateTimestamp) {
            updateTimestamp = updateTimestamp + 1;
            console.log('동일한 타임스탬프 발견, 1초 차이 추가:', updateTimestamp);
          }
        }
        
        // ID가 없는 경우 생성
        let recordId = parsedUpdate.id;
        if (!recordId || recordId === '') {
          // medical_update_timestamp_address 형식으로 ID 생성
          const addressPart = parsedUpdate.hospitalAddress || '';
          const timestampPart = updateTimestamp || Math.floor(Date.now() / 1000);
          recordId = `medical_update_${timestampPart}_${addressPart}`;
          console.log('수정본에 ID가 없어 생성함:', recordId);
        }
        
        // 수정 기록 객체 생성
        const updateBlockchainRecord: BlockChainRecord = {
          id: recordId,  // 생성된 ID 사용
          diagnosis: parsedUpdate.diagnosis || '정보 없음',
          hospitalName: parsedUpdate.hospitalName || '병원 정보 없음',
          doctorName: parsedUpdate.doctorName || '',
          notes: parsedUpdate.notes || '',
          createdAt: String(updateTimestamp),
          timestamp: updateTimestamp,
          isDeleted: false,
          hospitalAddress: parsedUpdate.hospitalAddress || '',
          pictures: parsedUpdate.pictures || [],
          previousRecord: parsedUpdate.previousRecord || originalRecordId,
          status: parsedUpdate.status || 'IN_PROGRESS',
          treatments: parsedUpdate.treatments || {
            examinations: [],
            medications: [],
            vaccinations: []
          },
          flagCertificated: parsedUpdate.flagCertificated,
          hospitalAccountId: parsedUpdate.hospitalAccountId || '',
        };
        
        validUpdateRecords.push(updateBlockchainRecord);
    } catch (error) {
        console.error('수정 기록 파싱 오류:', error);
      }
    }
    
    // 수정 기록들을 타임스탬프 기준 내림차순 정렬 (최신순)
    validUpdateRecords.sort((a, b) => {
      const timeA = typeof a.timestamp === 'number' ? a.timestamp : parseInt(a.createdAt || '0');
      const timeB = typeof b.timestamp === 'number' ? b.timestamp : parseInt(b.createdAt || '0');
      return timeB - timeA;
    });
    
    console.log(`유효한 수정 기록 ${validUpdateRecords.length}개를 찾았습니다.`);
    
    // 정렬된 수정 기록들 먼저 추가
    historyChain.push(...validUpdateRecords);
    
    // 마지막에 원본 기록 추가
    historyChain.push(originalBlockchainRecord);
    
    console.log(`총 ${historyChain.length}개의 기록 이력을 반환합니다.`);
    
    return historyChain;
  } catch (error) {
    console.error('진료 기록 이력 조회 중 오류:', error);
    return [];
  }
  };
  
  /**
   * 블록체인에 저장된 진료 기록을 수정하는 함수
   * @param petDID 반려동물 DID 주소
   * @param updatedRecord 수정된 진료 기록
   * @returns 성공 여부와 오류 메시지, 성공 시 새 기록 ID
   */
  export const updateBlockchainTreatment = async (
    petDID: string,
    updatedRecord: BlockChainRecord,
  ): Promise<{ success: boolean; error?: string; newRecordId?: string }> => {
    try {
      // 트랜잭션 시작 시간 기록
      const startTime = performance.now();
      console.log(`[트랜잭션 시작] 진료 기록 수정 - ${new Date().toISOString()}`);
      
      // pictures 필드 디버깅
      console.log('updateBlockchainTreatment에 전달된 pictures 데이터:', {
        raw: updatedRecord.pictures,
        hasPictures: !!updatedRecord.pictures,
        isArray: Array.isArray(updatedRecord.pictures),
        length: updatedRecord.pictures ? updatedRecord.pictures.length : 0
      });
      
      // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
      const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
      const contract = await getRegistryContract();
      const signer = await getSigner();
      
      if (!contract || !signer) {
        return { 
          success: false, 
          error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.'
        };
      }
      
      // 반려동물 존재 여부 확인
      const exists = await contract.petExists(petDID);
      if (!exists) {
        return { 
          success: false, 
          error: '등록되지 않은 반려동물입니다.'
        };
      }
      
      // 접근 권한 확인
      const currentUserAddress = await signer.getAddress();
      const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
      
      if (!accessGranted) {
        return { 
          success: false, 
          error: '이 반려동물 정보에 접근할 권한이 없습니다.'
        };
      }
      
      // 원본 기록 ID 확인
      // Hub-Spoke 구조에서는 항상 원본 기록(의료 기록의 Hub)을 참조해야 함
      let originalRecordKey = '';
      
      // 현재 기록 ID가 있는지 확인
      if (!updatedRecord.id) {
        return {
          success: false,
          error: '기록 ID가 없습니다.'
        };
      }
      
      // 현재 기록이 원본인지 수정본인지 확인
      // 원본 기록은 'medical_record_'로 시작, 수정 기록은 'medical_update_'로 시작
      if (updatedRecord.id.startsWith('medical_record_')) {
        // 현재 기록이 원본인 경우 그대로 사용
        originalRecordKey = updatedRecord.id;
      } else if (updatedRecord.previousRecord) {
        // 현재 기록이 수정본이고 previousRecord 필드가 있는 경우 해당 값 사용
        originalRecordKey = updatedRecord.previousRecord;
      } else {
        // 기록이 원본이 아니고 previousRecord도 없는 경우 오류
        return {
          success: false,
          error: '원본 기록을 찾을 수 없습니다. 원본 기록이 필요합니다.'
        };
      }
      
      // 원본 ID가 'medical_record_'로 시작하는지 확인
      if (!originalRecordKey.startsWith('medical_record_')) {
        return {
          success: false,
          error: '원본 기록 ID가 올바른 형식이 아닙니다. medical_record_로 시작해야 합니다.'
        };
      }
      
      console.log('원본 기록 ID 확인:', originalRecordKey);
      
      // 정제된 노트 내용 사용 (더 이상 수정 내역을 추가하지 않음)
      const sanitizedNotes = sanitizeObject(updatedRecord.notes || '');
      
      // JSON 형식으로 변환할 배열 생성 (약물, 검사, 접종)
      const sanitizedTreatments = sanitizeObject(updatedRecord.treatments || { examinations: [], medications: [], vaccinations: [] });
      const sanitizedPictures = sanitizeObject(updatedRecord.pictures || []);

      // 이미지 URL 디버깅
      console.log('업데이트할 pictures 데이터:', {
        rawPictures: updatedRecord.pictures,
        sanitizedPictures,
        hasRawPictures: !!updatedRecord.pictures && Array.isArray(updatedRecord.pictures) && updatedRecord.pictures.length > 0,
        hasSanitizedPictures: !!sanitizedPictures && Array.isArray(sanitizedPictures) && sanitizedPictures.length > 0
      });
      
      // 각 항목의 기본값 설정 및 엄격한 검증
      const examinationsJson = JSON.stringify(sanitizedTreatments.examinations || []);
      const medicationsJson = JSON.stringify(sanitizedTreatments.medications || []);
      const vaccinationsJson = JSON.stringify(sanitizedTreatments.vaccinations || []);
      const picturesJson = JSON.stringify(sanitizedPictures || []);
      
      // 상태 값 설정 (status 필드 추가)
      let status = updatedRecord.status || 'IN_PROGRESS';
      
      // flagCertificated 값 설정
      const flagCertificated = updatedRecord.flagCertificated !== undefined 
        ? updatedRecord.flagCertificated 
        : true;
      
      // treatmentDate 설정 - 기존 타임스탬프 사용 (실제 진료 시간), 없으면 0
      const treatmentDate = updatedRecord.timestamp || 0;
      
      console.log('진료 기록 수정 준비:', {
        petDID,
        originalRecordKey, // 변경: previousRecordKey에서 originalRecordKey로 변경
        diagnosis: sanitizeObject(updatedRecord.diagnosis || ''),
        hospitalName: sanitizeObject(updatedRecord.hospitalName || ''),
        doctorName: sanitizeObject(updatedRecord.doctorName || ''),
        notesLength: sanitizedNotes ? sanitizedNotes.length : 0,
        examinationsLength: examinationsJson.length,
        medicationsLength: medicationsJson.length,
        vaccinationsLength: vaccinationsJson.length,
        picturesLength: picturesJson.length,
        pictures: picturesJson,
        status,
        flagCertificated,
        treatmentDate
      });
      
      try {
        // 원본 기록 조회하여 상태 확인
        if (!updatedRecord.status && originalRecordKey) {
          try {
            const [originalRecordData, _] = await contract.getMedicalRecordWithUpdates(petDID, originalRecordKey);
            const parsedOriginal = safeJsonParse(originalRecordData, {});
            if (parsedOriginal && parsedOriginal.status) {
              // 원본 상태 유지 (isFinalTreatment 참조 제거)
              status = parsedOriginal.status;
            }
          } catch (error) {
            console.warn('원본 기록에서 상태 정보를 가져오는 데 실패했습니다:', error);
            // 실패 시 기본값 사용
            status = updatedRecord.status || 'IN_PROGRESS';
          }
        } else {
          // 이미 status가 설정되어 있으면 그대로 사용
          status = updatedRecord.status || 'IN_PROGRESS';
        }
        
        // 트랜잭션 실행 시작 시간 기록
        const txStartTime = performance.now();
        console.log(`[트랜잭션 실행] 진료 기록 수정 요청 - ${new Date().toISOString()}`);
        
        // appendMedicalRecord 함수 호출하여 이전 기록을 참조하는 새 기록 생성
        const tx = await contract.appendMedicalRecord(
          petDID,
          originalRecordKey, // 변경: previousRecordKey에서 originalRecordKey로 변경
          sanitizeObject(updatedRecord.diagnosis || ''),
          sanitizeObject(updatedRecord.hospitalName || ''),
          sanitizeObject(updatedRecord.doctorName || ''),
          sanitizedNotes || '',
          examinationsJson || '[]',
          medicationsJson || '[]',
          vaccinationsJson || '[]',
          picturesJson || '[]',
          status,                // 진료 상태 추가
          flagCertificated,      // 병원 인증 여부 추가
          treatmentDate,         // 변경: 실제 진료 일시 전달
          updatedRecord.hospitalAccountId || '', // 병원 계정 ID 추가
          { gasLimit: 300000000 }  // 가스 한도 증가
        );
        
        console.log(`[트랜잭션 전송] TX Hash: ${tx.hash} - ${new Date().toISOString()}`);
        console.log(`트랜잭션 요청 시간: ${((performance.now() - txStartTime) / 1000).toFixed(2)}초`);
        
        // 트랜잭션 완료 대기 시작 시간
        const waitStartTime = performance.now();
        console.log(`[트랜잭션 대기] 블록 생성 대기 중... - ${new Date().toISOString()}`);
        
        // 트랜잭션 완료 대기
        const receipt = await tx.wait();
        
        // 트랜잭션 완료 시간 측정
        const waitEndTime = performance.now();
        const waitTime = (waitEndTime - waitStartTime) / 1000;
        console.log(`[트랜잭션 완료] 블록 확인 완료 - ${new Date().toISOString()}`);
        console.log(`트랜잭션 대기 시간: ${waitTime.toFixed(2)}초`);
        console.log(`블록 번호: ${receipt.blockNumber}, 가스 사용량: ${receipt.gasUsed.toString()}`);
        
        // 트랜잭션 상태 확인
        if (receipt.status === 0) {
          console.error('트랜잭션이 실패했습니다:', receipt);
          return {
            success: false,
            error: '블록체인 트랜잭션이 실패했습니다. 가스 한도나 네트워크 상태를 확인해주세요.'
          };
        }
        
        // 이벤트 로그에서 새 레코드 ID 찾기
        let actualRecordId = '';
        try {
          // MedicalRecordAdded 이벤트 찾기
          const medicalRecordAddedEvent = receipt.events?.find(
            (event: any) => event.event === 'MedicalRecordAdded'
          );
          
          if (medicalRecordAddedEvent && medicalRecordAddedEvent.args) {
            // 이벤트의 두 번째 인자가 새 레코드 ID (recordKey)
            actualRecordId = medicalRecordAddedEvent.args[1];
            console.log('이벤트에서 찾은 레코드 ID:', actualRecordId);
          }
        } catch (error) {
          console.warn('새 레코드 ID를 이벤트에서 찾지 못했습니다:', error);
          
          // 이벤트에서 찾지 못한 경우 예상 ID 생성
          // 예상 ID: "medical_update_timestamp_address" 형식
          const timestamp = Math.floor(Date.now() / 1000);
          const address = await signer.getAddress();
          actualRecordId = `medical_update_${timestamp}_${address}`;
          console.log('예상 레코드 ID 생성:', actualRecordId);
        }
        
        // 총 소요 시간 측정
        const endTime = performance.now();
        const totalTime = (endTime - startTime) / 1000;
        console.log(`[트랜잭션 완료] 총 소요 시간: ${totalTime.toFixed(2)}초 - ${new Date().toISOString()}`);
        
        return {
          success: true,
          newRecordId: actualRecordId
        };
      } catch (error: any) {
        // 트랜잭션 오류 시간 기록
        const errorTime = performance.now();
        const totalTime = (errorTime - startTime) / 1000;
        console.error(`[트랜잭션 오류] 진료 기록 수정 중 오류 (${totalTime.toFixed(2)}초 소요):`, error);
        
        // 오류 메시지 개선
        let errorMessage = error.message || '진료 기록 수정 중 오류가 발생했습니다.';
        
        // 허브-스포크 구조 관련 오류 메시지 추가
        if (errorMessage.includes('Referenced record must be an original record')) {
          errorMessage = '원본 기록만 수정할 수 있습니다. 수정 기록을 다시 수정할 수 없습니다.';
        }
        // 가스 부족 오류
        else if (errorMessage.includes('out of gas')) {
          errorMessage = '트랜잭션 가스가 부족합니다. 데이터가 너무 큽니다.';
        }
        // 트랜잭션 거부 오류
        else if (errorMessage.includes('reverted')) {
          errorMessage = '트랜잭션이 블록체인에서 거부되었습니다.';
        }
        
        return {
          success: false,
          error: errorMessage
        };
      }
    } catch (error: any) {
      console.error('진료 기록 수정 준비 중 오류:', error);
      return {
        success: false,
        error: error.message || '진료 기록 수정 준비 중 오류가 발생했습니다.'
      };
    }
  };
  


/**
 * 병원이 접근 가능한 반려동물 목록과 각 반려동물의 의료기록을 함께 조회하는 함수
 * 원본 의료기록과 수정기록을 함께 반환합니다.
 * @returns 병원이 접근 가능한 반려동물 목록과 의료기록
 */
export const getHospitalPetsWithRecords = async (): Promise<any[]> => {
    try {
      // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
      const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
      const contract = await getRegistryContract();
      const signer = await getSigner();
      
      if (!contract || !signer) {
        console.error('MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.');
        return [];
      }
      
      // 현재 병원 계정 주소 가져오기
      const hospitalAddress = await signer.getAddress();
      
      // 병원이 접근 가능한 반려동물 목록 가져오기
      const petAddresses = await contract.getHospitalPets(hospitalAddress);
      console.log(`병원(${hospitalAddress})이 접근 가능한 반려동물 수: ${petAddresses.length}개`);
      
      // 각 반려동물의 정보와 의료기록을 가져오기
      const petsWithRecords = await Promise.all(
        petAddresses.map(async (petDID: string) => {
          try {
            // 반려동물 기본 정보 가져오기
            const [names, values] = await contract.getAllAttributes(petDID);
            
            // 기본 속성 추출 (이름, 성별, 품종 등)
            const petInfo: any = {
              name: '이름 없음',
              gender: '',
              birth: '',
              breedName: '',
              speciesName: '',
              flagNeutering: false,
              profileUrl: ''
            };
            
            // 기본 속성 설정
            for (let i = 0; i < names.length; i++) {
              const name = names[i];
              const value = values[i];
              
              if (name === 'name') petInfo.name = value;
              else if (name === 'gender') petInfo.gender = value;
              else if (name === 'birth') petInfo.birth = value;
              else if (name === 'breedName') petInfo.breedName = value;
              else if (name === 'speciesName') petInfo.speciesName = value;
              else if (name === 'flagNeutering') petInfo.flagNeutering = value === 'true';
              else if (name === 'profileUrl') petInfo.profileUrl = value;
            }
            
            // 반려동물의 원본 의료기록 키 목록 가져오기
            const originalRecordKeys = await contract.getPetOriginalRecords(petDID);
            console.log(`반려동물(${petDID})의 원본 의료기록 수: ${originalRecordKeys.length}개`);
            
            // 모든 원본 의료기록과 수정기록을 가져와서 처리
            const recordsWithUpdates = await Promise.all(
              originalRecordKeys.map(async (originalKey: string) => {
                try {
                  // 원본 의료기록과 수정기록 가져오기
                  const [originalRecord, updateRecords] = await contract.getMedicalRecordWithUpdates(petDID, originalKey);
                  
                  // 원본 기록 파싱
                  const parsedOriginal = safeJsonParse(originalRecord, {});
                  if (!parsedOriginal || parsedOriginal.isDeleted) {
                    return null; // 삭제된 기록은 건너뜀
                  }
                  
                  // 원본 타임스탬프 추출
                  let originalTimestamp = 0;
                  if (parsedOriginal.createdAt) {
                    originalTimestamp = Number(parsedOriginal.createdAt);
                  } else if (parsedOriginal.timestamp) {
                    originalTimestamp = Number(parsedOriginal.timestamp);
                  } else if (originalKey.startsWith('medical_record_')) {
                    const parts = originalKey.split('_');
                    if (parts.length >= 3) {
                      try {
                        originalTimestamp = Number(parts[2]);
                      } catch (e) {
                        originalTimestamp = 0;
                      }
                    }
                  }
                  
                  // 원본 의료기록 처리
                  const originalBlockchainRecord: BlockChainRecord = {
                    id: originalKey,
                    diagnosis: parsedOriginal.diagnosis || '정보 없음',
                    hospitalName: parsedOriginal.hospitalName || '병원 정보 없음',
                    doctorName: parsedOriginal.doctorName || '',
                    notes: parsedOriginal.notes || '',
                    createdAt: String(originalTimestamp),
                    timestamp: originalTimestamp,
                    isDeleted: false,
                    hospitalAddress: parsedOriginal.hospitalAddress || '',
                    pictures: parsedOriginal.pictures || [],
                    previousRecord: '',
                    status: parsedOriginal.status || 'IN_PROGRESS',
                    treatments: parsedOriginal.treatments || {
                      examinations: [],
                      medications: [],
                      vaccinations: []
                    },
                    flagCertificated: parsedOriginal.flagCertificated,
                    hospitalAccountId: parsedOriginal.hospitalAccountId || '',
                  };
                  
                  // 수정 기록 파싱 및 처리
                  const updateBlockchainRecords: BlockChainRecord[] = updateRecords
                    .map((updateRecord: string) => {
                      try {
                        const parsedUpdate = safeJsonParse(updateRecord, {});
                        if (!parsedUpdate || parsedUpdate.isDeleted) {
                          return null; // 삭제된 수정기록은 건너뜀
                        }
                        
                        // 이미지 URL 디버깅
                        console.log('수정 기록 pictures 필드:', {
                          recordId: parsedUpdate.id || 'ID 없음',
                          hasPictures: !!parsedUpdate.pictures,
                          picturesType: parsedUpdate.pictures ? typeof parsedUpdate.pictures : 'undefined',
                          isArray: parsedUpdate.pictures ? Array.isArray(parsedUpdate.pictures) : false,
                          picturesLength: parsedUpdate.pictures && Array.isArray(parsedUpdate.pictures) ? parsedUpdate.pictures.length : 0,
                          picturesContent: parsedUpdate.pictures
                        });
                        
                        // 수정 기록 타임스탬프 추출
                        let updateTimestamp = 0;
                        if (parsedUpdate.createdAt) {
                          updateTimestamp = Number(parsedUpdate.createdAt);
                        } else if (parsedUpdate.timestamp) {
                          updateTimestamp = Number(parsedUpdate.timestamp);
                        }
                        
                        // ID로부터 타임스탬프 추출 시도
                        if (updateTimestamp === 0 && parsedUpdate.id && parsedUpdate.id.includes('_')) {
                          const parts = parsedUpdate.id.split('_');
                          if (parts.length >= 3) {
                            try {
                              const idTimestamp = Number(parts[2]);
                              if (!isNaN(idTimestamp) && idTimestamp > 0) {
                                updateTimestamp = idTimestamp;
                              }
                            } catch (e) {
                              console.warn('ID에서 타임스탬프 추출 실패:', e);
                            }
                          }
                        }
                        
                        // 타임스탬프가 여전히 0이면 현재 시간 사용
                        if (updateTimestamp === 0) {
                          updateTimestamp = Math.floor(Date.now() / 1000);
                        }
                        
                        // 이전 기록과 타임스탬프가 동일한 경우 1초씩 차이 추가
                        if (updateRecords.length > 0) {
                          const lastRecord = updateRecords[updateRecords.length - 1];
                          if (lastRecord.timestamp === updateTimestamp) {
                            updateTimestamp = updateTimestamp + 1;
                            console.log('동일한 타임스탬프 발견, 1초 차이 추가:', updateTimestamp);
                          }
                        }
                        
                        // ID가 없는 경우 생성
                        let recordId = parsedUpdate.id;
                        if (!recordId || recordId === '') {
                          // medical_update_timestamp_address 형식으로 ID 생성
                          const addressPart = parsedUpdate.hospitalAddress || hospitalAddress;
                          const timestampPart = updateTimestamp || Math.floor(Date.now() / 1000);
                          recordId = `medical_update_${timestampPart}_${addressPart}`;
                          console.log('수정본에 ID가 없어 생성함:', recordId);
                        }
                        
                        // 수정 기록 객체 생성
                        return {
                          id: recordId,  // 빈 문자열 대신 생성된 ID 사용
                          diagnosis: parsedUpdate.diagnosis || '정보 없음',
                          hospitalName: parsedUpdate.hospitalName || '병원 정보 없음',
                          doctorName: parsedUpdate.doctorName || '',
                          notes: parsedUpdate.notes || '',
                          createdAt: String(updateTimestamp),
                          timestamp: updateTimestamp,
                          isDeleted: false,
                          hospitalAddress: parsedUpdate.hospitalAddress || '',
                          pictures: parsedUpdate.pictures || [],
                          previousRecord: parsedUpdate.previousRecord || originalKey,
                          status: parsedUpdate.status || 'IN_PROGRESS',
                          treatments: parsedUpdate.treatments || {
                            examinations: [],
                            medications: [],
                            vaccinations: []
                          },
                          flagCertificated: parsedUpdate.flagCertificated,
                          hospitalAccountId: parsedUpdate.hospitalAccountId || '',
                        };
                      } catch (error) {
                        console.error('수정 기록 파싱 오류:', error);
                        return null;
                      }
                    })
                    .filter((record: any) => record !== null);
                  
                  return {
                    originalRecord: originalBlockchainRecord,
                    updateRecords: updateBlockchainRecords
                  };
                } catch (error) {
                  console.error(`의료기록 ${originalKey} 조회 중 오류:`, error);
                  return null;
                }
              })
            );
            
            // null 값 제거 및 수정기록 타임스탬프 기준 내림차순 정렬
            const validRecords = recordsWithUpdates.filter((record: any) => record !== null);
            
            return {
              petDID,
              name: petInfo.name,
              gender: petInfo.gender,
              birth: petInfo.birth,
              breedName: petInfo.breedName,
              speciesName: petInfo.speciesName,
              flagNeutering: petInfo.flagNeutering,
              profileUrl: petInfo.profileUrl,
              records: validRecords
            };
          } catch (error) {
            console.error(`반려동물 ${petDID} 정보 조회 중 오류:`, error);
            return {
              petDID,
              name: '정보 조회 실패',
              records: []
            };
          }
        })
      );
      
      return petsWithRecords.filter(pet => pet !== null);
    } catch (error) {
      console.error('병원 반려동물 목록 조회 중 오류:', error);
      return [];
    }
  };
  

/**
 * 병원이 접근 가능한 반려동물 목록과 각 반려동물의 최신 의료기록만 조회하는 함수
 * 수정기록이 없다면 원본을, 수정기록이 있다면 가장 최근 수정기록만 반환합니다.
 * @returns 병원이 접근 가능한 반려동물 목록과 최신 의료기록
 */
export const getLatestPetRecords = async (): Promise<{ 
  success: boolean; 
  error?: string; 
  pets: any[];
}> => {
  try {
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      console.error('MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.');
      return { 
        success: false, 
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.',
        pets: [] 
      };
    }
    
    // 현재 병원 계정 주소 가져오기
    const hospitalAddress = await signer.getAddress();
    
    // 병원이 접근 가능한 반려동물 목록 가져오기
    const petAddresses = await contract.getHospitalPets(hospitalAddress);
    console.log(`병원(${hospitalAddress})이 접근 가능한 반려동물 수: ${petAddresses.length}개`);
    
    // 각 반려동물의 정보와 의료기록을 가져오기
    const petsWithRecords = await Promise.all(
      petAddresses.map(async (petDID: string) => {
        try {
          // 반려동물 기본 정보 가져오기
          const [names, values] = await contract.getAllAttributes(petDID);
          
          // 기본 속성 추출 (이름, 성별, 품종 등)
          const petInfo: any = {
            name: '이름 없음',
            gender: '',
            birth: '',
            breedName: '',
            speciesName: '',
            flagNeutering: false,
            profileUrl: ''
          };
          
          // 기본 속성 설정
          for (let i = 0; i < names.length; i++) {
            const name = names[i];
            const value = values[i];
            
            if (name === 'name') petInfo.name = value;
            else if (name === 'gender') petInfo.gender = value;
            else if (name === 'birth') petInfo.birth = value;
            else if (name === 'breedName') petInfo.breedName = value;
            else if (name === 'speciesName') petInfo.speciesName = value;
            else if (name === 'flagNeutering') petInfo.flagNeutering = value === 'true';
            else if (name === 'profileUrl') petInfo.profileUrl = value;
          }
          
          // 반려동물의 원본 의료기록 키 목록 가져오기
          const originalRecordKeys = await contract.getPetOriginalRecords(petDID);
          console.log(`반려동물(${petDID})의 원본 의료기록 수: ${originalRecordKeys.length}개`);
          
          // 모든 원본 의료기록과 수정기록을 가져와서 처리
          const allRecords: BlockChainRecord[] = [];
          
          // 모든 원본과 수정본 기록 처리
          await Promise.all(
            originalRecordKeys.map(async (originalKey: string) => {
              try {
                // 원본 의료기록과 수정기록 가져오기
                const [originalRecord, updateRecords] = await contract.getMedicalRecordWithUpdates(petDID, originalKey);
                
                // 원본 기록 파싱
                const parsedOriginal = safeJsonParse(originalRecord, {});
                if (!parsedOriginal || parsedOriginal.isDeleted) {
                  return; // 삭제된 기록은 건너뜀
                }
                
                // 원본 타임스탬프 추출
                let originalTimestamp = 0;
                if (parsedOriginal.createdAt) {
                  originalTimestamp = Number(parsedOriginal.createdAt);
                } else if (parsedOriginal.timestamp) {
                  originalTimestamp = Number(parsedOriginal.timestamp);
                } else if (originalKey.startsWith('medical_record_')) {
                  const parts = originalKey.split('_');
                  if (parts.length >= 3) {
                    try {
                      originalTimestamp = Number(parts[2]);
                    } catch (e) {
                      originalTimestamp = 0;
                    }
                  }
                }
                
                // 원본 의료기록 처리 - ID는 반드시 originalKey 사용
                const originalBlockchainRecord: BlockChainRecord = {
                  id: originalKey,
                  diagnosis: parsedOriginal.diagnosis || '정보 없음',
                  hospitalName: parsedOriginal.hospitalName || '병원 정보 없음',
                  doctorName: parsedOriginal.doctorName || '',
                  notes: parsedOriginal.notes || '',
                  createdAt: String(originalTimestamp),
                  timestamp: originalTimestamp,
                  isDeleted: false,
                  hospitalAddress: parsedOriginal.hospitalAddress || '',
                  pictures: parsedOriginal.pictures || [],
                  previousRecord: '',
                  status: parsedOriginal.status || 'IN_PROGRESS',
                  treatments: parsedOriginal.treatments || {
                    examinations: [],
                    medications: [],
                    vaccinations: []
                  },
                  flagCertificated: parsedOriginal.flagCertificated,
                  hospitalAccountId: parsedOriginal.hospitalAccountId || '',
                };
                
                // 수정 기록이 없는 경우 원본만 추가
                if (!updateRecords || updateRecords.length === 0) {
                  allRecords.push(originalBlockchainRecord);
                  return;
                }
                
                // 수정 기록 중 삭제되지 않은 것만 필터링하고 처리
                const validUpdateRecords: BlockChainRecord[] = [];
                
                for (const updateRecord of updateRecords) {
                  try {
                    const parsedUpdate = safeJsonParse(updateRecord, {});
                    if (!parsedUpdate || parsedUpdate.isDeleted) {
                      continue; // 삭제된 수정기록은 건너뜀
                    }
                    
                    // 수정 기록 타임스탬프 추출
                    let updateTimestamp = 0;
                    if (parsedUpdate.createdAt) {
                      updateTimestamp = Number(parsedUpdate.createdAt);
                    } else if (parsedUpdate.timestamp) {
                      updateTimestamp = Number(parsedUpdate.timestamp);
                    }
                    
                    // 수정 기록 ID 확인 또는 생성 (의미있는 ID로 생성)
                    let recordId = parsedUpdate.id || '';
                    
                    // ID가 없거나 형식이 맞지 않으면 생성
                    if (!recordId || !recordId.startsWith('medical_update_')) {
                      // ID로부터 타임스탬프 추출 시도
                      if (updateTimestamp === 0 && recordId && recordId.includes('_')) {
                        const parts = recordId.split('_');
                        if (parts.length >= 3) {
                          try {
                            const idTimestamp = Number(parts[2]);
                            if (!isNaN(idTimestamp) && idTimestamp > 0) {
                              updateTimestamp = idTimestamp;
                            }
                          } catch (e) {
                            console.warn('ID에서 타임스탬프 추출 실패:', e);
                          }
                        }
                      }
                      
                      // 타임스탬프가 여전히 0이면 현재 시간 사용
                      if (updateTimestamp === 0) {
                        updateTimestamp = Math.floor(Date.now() / 1000);
                      }
                      
                      // 새 수정 기록 ID 생성 (medical_update_ 접두사 사용)
                      const addressPart = parsedUpdate.hospitalAddress || hospitalAddress;
                      recordId = `medical_update_${updateTimestamp}_${addressPart}`;
                      console.log('수정본 ID 생성:', recordId);
                    }
                    
                    // 수정 기록 객체 생성 - ID는 반드시 수정 기록의 고유 ID 사용
                    const updateBlockchainRecord: BlockChainRecord = {
                      id: recordId, // 중요: 수정본 ID는 항상 medical_update_로 시작
                      diagnosis: parsedUpdate.diagnosis || '정보 없음',
                      hospitalName: parsedUpdate.hospitalName || '병원 정보 없음',
                      doctorName: parsedUpdate.doctorName || '',
                      notes: parsedUpdate.notes || '',
                      createdAt: String(updateTimestamp),
                      timestamp: updateTimestamp,
                      isDeleted: false,
                      hospitalAddress: parsedUpdate.hospitalAddress || '',
                      pictures: parsedUpdate.pictures || [],
                      previousRecord: parsedUpdate.previousRecord || originalKey,
                      status: parsedUpdate.status || 'IN_PROGRESS',
                      treatments: parsedUpdate.treatments || {
                        examinations: [],
                        medications: [],
                        vaccinations: []
                      },
                      flagCertificated: parsedUpdate.flagCertificated,
                      hospitalAccountId: parsedUpdate.hospitalAccountId || ''
                    };
                    
                    // 이전 기록과 타임스탬프가 동일한 경우 1초씩 차이 추가
                    if (validUpdateRecords.length > 0) {
                      const lastRecord = validUpdateRecords[validUpdateRecords.length - 1];
                      if (lastRecord.timestamp === updateTimestamp) {
                        updateBlockchainRecord.timestamp = updateTimestamp + 1;
                        updateBlockchainRecord.createdAt = String(updateTimestamp + 1);
                        console.log('동일한 타임스탬프 발견, 1초 차이 추가:', updateBlockchainRecord.timestamp);
                      }
                    }
                    
                    validUpdateRecords.push(updateBlockchainRecord);
                  } catch (error) {
                    console.error('수정 기록 파싱 오류:', error);
                  }
                }
                
                // 타임스탬프 기준 내림차순 정렬 (최신순)
                validUpdateRecords.sort((a, b) => {
                  const timeA = typeof a.timestamp === 'number' ? a.timestamp : parseInt(a.createdAt || '0');
                  const timeB = typeof b.timestamp === 'number' ? b.timestamp : parseInt(b.createdAt || '0');
                  return timeB - timeA;
                });
                
                // 수정 기록이 있으면 가장 최신 수정본만 추가
                if (validUpdateRecords.length > 0) {
                  allRecords.push(validUpdateRecords[0]);
                } else {
                  // 수정 기록이 없으면 원본 추가
                  allRecords.push(originalBlockchainRecord);
                }
              } catch (error) {
                console.error(`의료기록 ${originalKey} 조회 중 오류:`, error);
              }
            })
          );
          
          // 타임스탬프 기준 내림차순 정렬 (최신순)
          allRecords.sort((a, b) => {
            const timeA = typeof a.timestamp === 'number' ? a.timestamp : parseInt(a.createdAt || '0');
            const timeB = typeof b.timestamp === 'number' ? b.timestamp : parseInt(b.createdAt || '0');
            return timeB - timeA;
          });
          
          // 모든 기록 ID 로깅 (디버깅용)
          console.log(`반려동물(${petInfo.name})의 기록 ID 목록:`, 
            allRecords.map(record => ({
              id: record.id,
              isOriginal: record.id?.startsWith('medical_record_'),
              hasId: !!record.id
            }))
          );
          
          return {
            petDID,
            name: petInfo.name,
            gender: petInfo.gender,
            birth: petInfo.birth,
            breedName: petInfo.breedName,
            speciesName: petInfo.speciesName,
            flagNeutering: petInfo.flagNeutering,
            profileUrl: petInfo.profileUrl,
            records: allRecords
          };
        } catch (error) {
          console.error(`반려동물 ${petDID} 정보 조회 중 오류:`, error);
          return {
            petDID,
            name: '정보 조회 실패',
            records: []
          };
        }
      })
    );
    
    const filteredPets = petsWithRecords.filter(pet => pet !== null);
    
    return {
      success: true,
      pets: filteredPets
    };
  } catch (error) {
    console.error('병원 반려동물 목록 조회 중 오류:', error);
    return {
      success: false,
      error: `반려동물 목록 조회 중 오류가 발생했습니다: ${error instanceof Error ? error.message : '알 수 없는 오류'}`,
      pets: []
    };
  }
};

/**
 * 블록체인에 새로운 진료 기록을 생성하는 함수
 * @param petDID 반려동물 DID 주소
 * @param record 진료 기록 데이터
 * @returns 성공 여부와 오류 메시지, 성공 시 새 기록 ID
 */
export const createBlockchainTreatment = async (
  petDID: string,
  record: BlockChainRecord
): Promise<{ success: boolean; error?: string; newRecordId?: string }> => {
  try {
    // 트랜잭션 시작 시간 기록
    const startTime = performance.now();
    console.log(`[트랜잭션 시작] 진료 기록 생성 - ${new Date().toISOString()}`);
    
    // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
    const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
    const contract = await getRegistryContract();
    const signer = await getSigner();
    
    if (!contract || !signer) {
      return { 
        success: false, 
        error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.'
      };
    }
    
    // 반려동물 존재 여부 확인
    const exists = await contract.petExists(petDID);
    if (!exists) {
      return { 
        success: false, 
        error: '등록되지 않은 반려동물입니다.'
      };
    }
    
    // 접근 권한 확인
    const currentUserAddress = await signer.getAddress();
    const accessGranted = await contract.hasAccess(petDID, currentUserAddress);
    
    if (!accessGranted) {
      return { 
        success: false, 
        error: '이 반려동물 정보에 접근할 권한이 없습니다.'
      };
    }
    
    // 필수 정보 확인
    if (!record.diagnosis) {
      return {
        success: false,
        error: '진단명은 필수 항목입니다.'
      };
    }
    
    // 정제된 값 생성
    const sanitizedNotes = sanitizeObject(record.notes || '');
    const sanitizedTreatments = sanitizeObject(record.treatments || { examinations: [], medications: [], vaccinations: [] });
    const sanitizedPictures = sanitizeObject(record.pictures || []);
    
    // 이미지 URL 디버깅
    console.log('업데이트할 pictures 데이터:', {
      rawPictures: record.pictures,
      sanitizedPictures,
      hasRawPictures: !!record.pictures && Array.isArray(record.pictures) && record.pictures.length > 0,
      hasSanitizedPictures: !!sanitizedPictures && Array.isArray(sanitizedPictures) && sanitizedPictures.length > 0
    });
    
    // 각 항목의 기본값 설정 및 엄격한 검증
    const examinationsJson = JSON.stringify(sanitizedTreatments.examinations || []);
    const medicationsJson = JSON.stringify(sanitizedTreatments.medications || []);
    const vaccinationsJson = JSON.stringify(sanitizedTreatments.vaccinations || []);
    const picturesJson = JSON.stringify(sanitizedPictures || []);
    
    // 상태 값 설정 (status 필드 추가)
    const status = record.status || 'COMPLETED';
    
    // flagCertificated 값 설정
    const flagCertificated = record.flagCertificated !== undefined 
      ? record.flagCertificated 
      : true;
    
    // treatmentDate 설정 - 기존 타임스탬프 사용 (실제 진료 시간), 없으면 0
    const treatmentDate = record.timestamp || 0;
    
    console.log('진료 기록 생성 준비:', {
      petDID,
      diagnosis: sanitizeObject(record.diagnosis || ''),
      hospitalName: sanitizeObject(record.hospitalName || ''),
      doctorName: sanitizeObject(record.doctorName || ''),
      notesLength: sanitizedNotes ? sanitizedNotes.length : 0,
      examinationsLength: examinationsJson.length,
      medicationsLength: medicationsJson.length,
      vaccinationsLength: vaccinationsJson.length,
      picturesLength: picturesJson.length,
      status,
      flagCertificated,
      treatmentDate
    });
    
    try {
      // 트랜잭션 실행 시작 시간 기록
      const txStartTime = performance.now();
      console.log(`[트랜잭션 실행] 진료 기록 생성 요청 - ${new Date().toISOString()}`);
      
      // addMedicalRecord 함수 호출하여 새 의료 기록 생성
      const tx = await contract.addMedicalRecord(
        petDID,
        sanitizeObject(record.diagnosis || ''),
        sanitizeObject(record.hospitalName || ''),
        sanitizeObject(record.doctorName || ''),
        sanitizedNotes || '',
        examinationsJson || '[]',
        medicationsJson || '[]',
        vaccinationsJson || '[]',
        picturesJson || '[]',
        status,                // 진료 상태 추가
        flagCertificated,      // 병원 인증 여부 추가
        treatmentDate,         // 진료 일시 전달
        record.hospitalAccountId || '', // 병원 계정 ID 추가
        { gasLimit: 300000000 }  // 가스 한도 설정
      );
      
      console.log(`[트랜잭션 전송] TX Hash: ${tx.hash} - ${new Date().toISOString()}`);
      console.log(`트랜잭션 요청 시간: ${((performance.now() - txStartTime) / 1000).toFixed(2)}초`);
      
      // 트랜잭션 완료 대기 시작 시간
      const waitStartTime = performance.now();
      console.log(`[트랜잭션 대기] 블록 생성 대기 중... - ${new Date().toISOString()}`);
      
      // 트랜잭션 완료 대기
      const receipt = await tx.wait();
      
      // 트랜잭션 완료 시간 측정
      const waitEndTime = performance.now();
      const waitTime = (waitEndTime - waitStartTime) / 1000;
      console.log(`[트랜잭션 완료] 블록 확인 완료 - ${new Date().toISOString()}`);
      console.log(`트랜잭션 대기 시간: ${waitTime.toFixed(2)}초`);
      console.log(`블록 번호: ${receipt.blockNumber}, 가스 사용량: ${receipt.gasUsed.toString()}`);
      
      // 트랜잭션 상태 확인
      if (receipt.status === 0) {
        console.error('트랜잭션이 실패했습니다:', receipt);
        return {
          success: false,
          error: '블록체인 트랜잭션이 실패했습니다. 가스 한도나 네트워크 상태를 확인해주세요.'
        };
      }
      
      // 이벤트 로그에서 새 레코드 ID 찾기
      let actualRecordId = '';
      try {
        // MedicalRecordAdded 이벤트 찾기
        const medicalRecordAddedEvent = receipt.events?.find(
          (event: any) => event.event === 'MedicalRecordAdded'
        );
        
        if (medicalRecordAddedEvent && medicalRecordAddedEvent.args) {
          // 이벤트의 두 번째 인자가 새 레코드 ID (recordKey)
          actualRecordId = medicalRecordAddedEvent.args[1];
          console.log('이벤트에서 찾은 레코드 ID:', actualRecordId);
        }
      } catch (error) {
        console.warn('새 레코드 ID를 이벤트에서 찾지 못했습니다:', error);
        
        // 이벤트에서 찾지 못한 경우 예상 ID 생성
        // 예상 ID: "medical_record_timestamp_address" 형식
        const timestamp = Math.floor(Date.now() / 1000);
        const address = await signer.getAddress();
        actualRecordId = `medical_record_${timestamp}_${address}`;
        console.log('예상 레코드 ID 생성:', actualRecordId);
      }
      
      // 총 소요 시간 측정
      const endTime = performance.now();
      const totalTime = (endTime - startTime) / 1000;
      console.log(`[트랜잭션 완료] 총 소요 시간: ${totalTime.toFixed(2)}초 - ${new Date().toISOString()}`);
      
      return {
        success: true,
        newRecordId: actualRecordId
      };
    } catch (error: any) {
      // 트랜잭션 오류 시간 기록
      const errorTime = performance.now();
      const totalTime = (errorTime - startTime) / 1000;
      console.error(`[트랜잭션 오류] 진료 기록 생성 중 오류 (${totalTime.toFixed(2)}초 소요):`, error);
      
      // 오류 메시지 개선
      let errorMessage = error.message || '진료 기록 생성 중 오류가 발생했습니다.';
      
      // 가스 부족 오류
      if (errorMessage.includes('out of gas')) {
        errorMessage = '트랜잭션 가스가 부족합니다. 데이터가 너무 큽니다.';
      }
      // 트랜잭션 거부 오류
      else if (errorMessage.includes('reverted')) {
        errorMessage = '트랜잭션이 블록체인에서 거부되었습니다.';
      }
      // 사용자 거부 오류
      else if (errorMessage.includes('user rejected')) {
        errorMessage = '사용자가 MetaMask 트랜잭션을 거부했습니다.';
      }
      
      return {
        success: false,
        error: errorMessage
      };
    }
  } catch (error: any) {
    console.error('진료 기록 생성 준비 중 오류:', error);
    return {
      success: false,
      error: error.message || '진료 기록 생성 준비 중 오류가 발생했습니다.'
    };
  }
};
  

/**
 * 블록체인에 저장된 진료 기록을 소프트 삭제하는 함수
 * @param petDID 반려동물 DID 주소
 * @param recordKey 삭제할 진료 기록의 키
 * @returns 성공 여부와 오류 메시지
 */
export const softDeleteMedicalRecord = async (
    petDID: string,
    recordKey: string
  ): Promise<{ success: boolean; error?: string }> => {
    // 트랜잭션 시작 시간 기록
    const startTime = performance.now();
    console.log(`[트랜잭션 시작] 진료 기록 삭제 - ${new Date().toISOString()}`);
    console.log('softDeleteMedicalRecord 함수 시작:', { petDID, recordKey });
    
    // DID 형식 확인 (0x로 시작하는지)
    if (!petDID.startsWith('0x')) {
      console.error('잘못된 DID 형식:', petDID);
      return { 
        success: false, 
        error: '잘못된 DID 형식입니다. 이더리움 주소 형식(0x...)이 필요합니다.'
      };
    }
    
    try {
      console.log('블록체인 서비스 임포트 시작');
      // 블록체인 인증 서비스를 통해 계정 연결 및 Registry 컨트랙트 가져오기
      const { getRegistryContract, getSigner } = await import('@/services/blockchainAuthService');
      console.log('블록체인 서비스 임포트 완료');
      
      console.log('Registry 컨트랙트 및 서명자 가져오기');
      const contract = await getRegistryContract();
      const signer = await getSigner();
      console.log('컨트랙트 및 서명자 획득 상태:', !!contract, !!signer);
      
      if (!contract || !signer) {
        console.error('컨트랙트 또는 서명자 없음');
        return { 
          success: false, 
          error: 'MetaMask에 연결할 수 없습니다. 계정 연결 상태를 확인해주세요.'
        };
      }
      
      // 반려동물 존재 여부 확인
      console.log('반려동물 존재 여부 확인 시작:', petDID);
      let exists = false;
      try {
        exists = await contract.petExists(petDID);
        console.log('반려동물 존재 여부 확인 결과:', exists);
      } catch (existsError) {
        console.error('반려동물 존재 여부 확인 중 오류:', existsError);
        return { 
          success: false, 
          error: `반려동물 존재 여부 확인 중 오류: ${existsError}`
        };
      }
      
      if (!exists) {
        console.error('등록되지 않은 반려동물');
        return { 
          success: false, 
          error: '등록되지 않은 반려동물입니다.'
        };
      }
      
      // 접근 권한 확인
      console.log('계정 주소 가져오기');
      const currentUserAddress = await signer.getAddress();
      console.log('현재 사용자 주소:', currentUserAddress);
      
      console.log('접근 권한 확인 시작');
      let accessGranted = false;
      try {
        accessGranted = await contract.hasAccess(petDID, currentUserAddress);
        console.log('접근 권한 확인 결과:', accessGranted);
      } catch (accessError) {
        console.error('접근 권한 확인 중 오류:', accessError);
        return { 
          success: false, 
          error: `접근 권한 확인 중 오류: ${accessError}`
        };
      }
      
      if (!accessGranted) {
        console.error('접근 권한 없음');
        return { 
          success: false, 
          error: '이 진료 기록을 삭제할 권한이 없습니다.'
        };
      }
      
      console.log('진료 기록 삭제 시작:', { petDID, recordKey });
      
      try {
        // softDeleteMedicalRecord 함수 존재 여부 확인
        try {
          const fnDesc = contract.interface.getFunction('softDeleteMedicalRecord');
          console.log('softDeleteMedicalRecord 함수 존재 여부:', !!fnDesc, fnDesc || '함수 없음');
        } catch (fnError) {
          console.error('함수 검증 중 오류:', fnError);
        }
        
        // 트랜잭션 실행 시작 시간 기록
        const txStartTime = performance.now();
        console.log(`[트랜잭션 실행] 진료 기록 삭제 요청 - ${new Date().toISOString()}`);
        
        // softDeleteMedicalRecord 함수 호출하여 진료 기록 소프트 삭제
        console.log('소프트 삭제 트랜잭션 요청 시작');
        const tx = await contract.softDeleteMedicalRecord(
          petDID,
          recordKey,
          { gasLimit: 300000000 }  // 가스 한도 설정
        );
        
        console.log(`[트랜잭션 전송] TX Hash: ${tx.hash} - ${new Date().toISOString()}`);
        console.log(`트랜잭션 요청 시간: ${((performance.now() - txStartTime) / 1000).toFixed(2)}초`);
        
        // 트랜잭션 완료 대기 시작 시간
        const waitStartTime = performance.now();
        console.log(`[트랜잭션 대기] 블록 생성 대기 중... - ${new Date().toISOString()}`);
        
        // 트랜잭션 완료 대기
        console.log('트랜잭션 완료 대기...');
        const receipt = await tx.wait();
        
        // 트랜잭션 완료 시간 측정
        const waitEndTime = performance.now();
        const waitTime = (waitEndTime - waitStartTime) / 1000;
        console.log(`[트랜잭션 완료] 블록 확인 완료 - ${new Date().toISOString()}`);
        console.log(`트랜잭션 대기 시간: ${waitTime.toFixed(2)}초`);
        console.log(`블록 번호: ${receipt.blockNumber}, 가스 사용량: ${receipt.gasUsed.toString()}`);
        
        // 트랜잭션 상태 확인
        if (receipt.status === 0) {
          console.error('트랜잭션이 실패했습니다:', receipt);
          return {
            success: false,
            error: '블록체인 트랜잭션이 실패했습니다. 가스 한도나 네트워크 상태를 확인해주세요.'
          };
        }
        
        console.log('진료 기록 삭제 성공:', tx.hash);
        
        // 이벤트 확인
        try {
          const events = receipt.events || [];
          console.log('트랜잭션 이벤트 목록:', events.map((e: any) => e.event));
          const medicalRecordDeletedEvent = events.find(
            (event: any) => event.event === 'MedicalRecordDeleted'
          );
          
          if (medicalRecordDeletedEvent) {
            console.log('기록 삭제 이벤트 발생:', medicalRecordDeletedEvent);
          } else {
            console.warn('MedicalRecordDeleted 이벤트를 찾을 수 없음');
          }
        } catch (eventError) {
          console.warn('이벤트 조회 중 오류:', eventError);
        }
        
        // 총 소요 시간 측정
        const endTime = performance.now();
        const totalTime = (endTime - startTime) / 1000;
        console.log(`[트랜잭션 완료] 총 소요 시간: ${totalTime.toFixed(2)}초 - ${new Date().toISOString()}`);
        
        return {
          success: true
        };
      } catch (error: any) {
        console.error('진료 기록 삭제 중 오류:', error);
        console.error('오류 세부 정보:', {
          message: error.message,
          code: error.code,
          reason: error.reason,
          data: error.data
        });
        
        // 오류 메시지 개선
        let errorMessage = error.message || '진료 기록 삭제 중 오류가 발생했습니다.';
        
        // 이미 삭제된 기록
        if (errorMessage.includes('Medical record is already deleted')) {
          errorMessage = '이미 삭제된 진료 기록입니다.';
        }
        // 존재하지 않는 기록
        else if (errorMessage.includes('Medical record does not exist')) {
          errorMessage = '존재하지 않는 진료 기록입니다.';
        }
        // 권한 없음
        else if (errorMessage.includes('No permission to delete medical record')) {
          errorMessage = '이 진료 기록을 삭제할 권한이 없습니다.';
        }
        // 트랜잭션 거부 오류
        else if (errorMessage.includes('reverted')) {
          errorMessage = '트랜잭션이 블록체인에서 거부되었습니다.';
        }
        
        return {
          success: false,
          error: errorMessage
        };
      }
    } catch (error: any) {
      console.error('진료 기록 삭제 준비 중 오류:', error);
      return {
        success: false,
        error: error.message || '진료 기록 삭제 준비 중 오류가 발생했습니다.'
      };
    }
  };