// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DID 레지스트리 컨트랙트
 * @author C206 seonghun
 * @notice 이 컨트랙트는 반려동물과 병원 간의 의료정보 공유를 위한 DID(탈중앙화 식별자) 레지스트리입니다.
 * @dev 이 컨트랙트에는 두 가지 종류의 함수가 있습니다:
 *      1. 현재 권장되는 함수
 *      2. 레거시 지원을 위한 함수 (_로 시작하는 함수들)
 * 
 * 권장되는 함수:
 * - registerPetWithAttributes: 반려동물 등록과 속성 설정을 한번에 처리
 * - addHospitalWithSharing: 병원 접근권한과 공유계약을 함께 생성
 * - revokeSharingAgreement: 병원 공유계약 해지
 * 
 * 레거시 함수 (_로 시작):
 * - _registerPetOwnership: 단순 반려동물 등록 (registerPetWithAttributes로 대체됨)
 * - _addHospital: 단순 병원 접근권한 추가 (addHospitalWithSharing로 대체됨)
 * - _removeHospital: 단순 병원 접근권한 제거 (revokeSharingAgreement로 대체됨)
 * 
 * 컨트랙트 버전: 3.0.0
 */
contract DIDRegistry {
    // 반려동물 주소 => 소유자(보호자) 주소
    mapping(address => address) public owners;
    
    // 반려동물 주소 => 접근 권한이 있는 병원 주소 배열
    mapping(address => address[]) public hospitals;
    
    // 반려동물 주소 => 속성명 => 속성 구조체
    mapping(address => mapping(string => Attribute)) private attributes;
    
    // 반려동물 주소 => 속성명 배열 (전체 속성 조회용)
    mapping(address => string[]) private attributeNames;
    
    // 소유자 주소 => 소유한 반려동물 주소 배열
    mapping(address => address[]) private ownerPets;
    
    // 반려동물 주소 => 소유자의 배열 내 인덱스 (삭제 효율화용)
    mapping(address => uint256) private petToOwnerIndex;
    
    // 속성 구조체 정의
    struct Attribute {
        string value;      // 속성값
        uint expireDate;   // 만료일시 (타임스탬프)
    }
    
    // 이벤트 정의
    event OwnerChanged(address indexed petAddress, address indexed ownerAddress, uint timestamp);
    event AttributeChanged(address indexed petAddress, bytes32 indexed name, string value, uint expireDate, uint timestamp);
    event PetAttributeChanged(address indexed petAddress, address indexed ownerAddress, uint timestamp);
    event HospitalChanged(address indexed petAddress, address indexed hospitalAddress, uint timestamp);
    event PetDeleted(address indexed petAddress, address indexed ownerAddress, uint timestamp);
    event MedicalRecordDeleted(address indexed petAddress, string indexed recordKey, address indexed deletedBy, uint timestamp);
    event MedicalRecordAdded(address indexed petAddress, string indexed recordKey, string previousRecordKey, address indexed addedBy, uint timestamp);
    event PetRegistered(address indexed petAddress, address indexed ownerAddress, uint timestamp);
    
    // 공유 계약 구조체 추가
    struct SharingAgreement {
        bool exists;           // 계약 존재 여부
        string scope;          // 공유 범위 (예: "all", "basic", "medical")
        uint createdAt;        // 생성 시간
        uint expireDate;       // 만료 시간
        bool notificationSent; // 만료 알림 전송 여부
    }
    
    // 공유 관련 상수
    uint public constant MIN_SHARING_PERIOD = 1 days;
    uint public constant MAX_SHARING_PERIOD = 30 days;
    uint public constant NOTIFICATION_THRESHOLD = 3 days;
    
    // 반려동물 주소 => 병원 주소 => 공유 계약
    mapping(address => mapping(address => SharingAgreement)) public sharingAgreements;
    
    // 병원별 공유 중인 반려동물 목록 (조회용)
    mapping(address => address[]) public hospitalPets;
    
    // 각 반려동물별 공유 병원 목록 (조회용)
    mapping(address => address[]) public petHospitals;
    
    // 추가 이벤트 정의
    event SharingAgreementCreated(
        address indexed petAddress,
        address indexed hospitalAddress, 
        string scope,
        uint expireDate,
        uint createdAt
    );
    
    event SharingAgreementRevoked(
        address indexed petAddress,
        address indexed hospitalAddress,
        uint timestamp
    );
    
    event SharingAgreementExpiringSoon(
        address indexed petAddress,
        address indexed hospitalAddress,
        uint expireDate,
        uint notificationTime
    );
    
    constructor() {
        // 컨트랙트 생성자
    }

    // 반려동물 아이덴티티 생성 함수 (legacy) - registerPetWithAttributes 함수 사용 권장
    function _registerPetOwnership(address petAddress) public {
        require(owners[petAddress] == address(0), "Pet address is already registered");
        owners[petAddress] = msg.sender;
        
        // 소유자의 반려동물 목록에 추가
        _addPetToOwner(msg.sender, petAddress);
        
        emit OwnerChanged(petAddress, msg.sender, block.timestamp);
    }
    
    // 반려동물 등록 및 모든 속성을 한 번에 설정하는 새로운 함수
    function registerPetWithAttributes(
        address petAddress,
        string memory name,
        string memory gender,
        string memory breedName,
        string memory birth,
        bool flagNeutering,
        string memory speciesName,
        string memory profileUrl
    ) public {
        // 소유권 등록
        require(owners[petAddress] == address(0), "Pet address is already registered");
        owners[petAddress] = msg.sender;
        
        // 소유자의 반려동물 목록에 추가
        _addPetToOwner(msg.sender, petAddress);
        
        // 유효기간 (100년)
        uint validity = 100 * 365 * 24 * 60 * 60;
        
        // 기본 속성 설정
        _setAttributeInternal(petAddress, "name", name, validity);
        _setAttributeInternal(petAddress, "gender", gender, validity);
        _setAttributeInternal(petAddress, "breedName", breedName, validity);
        _setAttributeInternal(petAddress, "speciesName", speciesName, validity);
        
        // 프로필 URL 설정
        if (bytes(profileUrl).length > 0) {
            _setAttributeInternal(petAddress, "profileUrl", profileUrl, validity);
        }
        
        // 선택적 속성
        if (bytes(birth).length > 0) {
            _setAttributeInternal(petAddress, "birth", birth, validity);
        }
        
        _setAttributeInternal(petAddress, "flagNeutering", flagNeutering ? "true" : "false", validity);
        
        // 이벤트 발생
        emit OwnerChanged(petAddress, msg.sender, block.timestamp);
        emit PetAttributeChanged(petAddress, msg.sender, block.timestamp);
        emit PetRegistered(petAddress, msg.sender, block.timestamp);
    }
    
    // 내부 속성 설정 함수 (가스 절약을 위해 중복 코드 제거)
    function _setAttributeInternal(
        address petAddress, 
        string memory name, 
        string memory value, 
        uint validity
    ) internal {
        // 속성이 처음 설정되는 경우 이름 배열에 추가
        if (attributes[petAddress][name].expireDate == 0) {
            attributeNames[petAddress].push(name);
        }
        
        // 속성 설정
        attributes[petAddress][name] = Attribute(value, block.timestamp + validity);
        
        // 이벤트 발생
        emit AttributeChanged(petAddress, keccak256(bytes(name)), value, block.timestamp + validity, block.timestamp);
    }
    
    // 소유자 변경 함수
    function changeOwner(address petAddress, address newOwner) public {
        require(msg.sender == owners[petAddress], "Only owner can change ownership");
        require(!isPetDeleted(petAddress), "Cannot change ownership of deleted pet");
        
        // 기존 소유자의 목록에서 제거
        _removePetFromOwner(msg.sender, petAddress);
        
        // 새 소유자 설정
        owners[petAddress] = newOwner;
        
        // 새 소유자의 목록에 추가
        _addPetToOwner(newOwner, petAddress);
        
        emit OwnerChanged(petAddress, newOwner, block.timestamp);
    }
    
    // 병원 접근 권한 추가 함수 (legacy) - addHospitalWithSharing로 대체됨
    function _addHospital(address petAddress, address hospitalAddress) public {
        require(msg.sender == owners[petAddress], "Only owner can add hospital access");
        require(!isPetDeleted(petAddress), "Cannot add hospital access to deleted pet");
        hospitals[petAddress].push(hospitalAddress);
        emit HospitalChanged(petAddress, hospitalAddress, block.timestamp);
    }
    
    // 병원 접근 권한 제거 함수 (legacy) - revokeSharingAgreement로 대체됨
    function _removeHospital(address petAddress, address hospitalAddress) public {
        require(msg.sender == owners[petAddress], "Only owner can remove hospital access");
        
        address[] storage hospitalList = hospitals[petAddress];
        for (uint i = 0; i < hospitalList.length; i++) {
            if (hospitalList[i] == hospitalAddress) {
                // 마지막 요소를 현재 위치로 이동시키고 배열 크기 감소
                hospitalList[i] = hospitalList[hospitalList.length - 1];
                hospitalList.pop();
                emit HospitalChanged(petAddress, hospitalAddress, block.timestamp);
                return;
            }
        }
        
        revert("Hospital not found");
    }
    
    // 속성 설정/변경 함수
    function setAttribute(address petAddress, string memory name, string memory value, uint validity) public {
        // 접근 권한 확인 (소유자 또는 등록된 병원)
        bool userHasAccess = (msg.sender == owners[petAddress]);
        
        if (!userHasAccess) {
            address[] storage hospitalList = hospitals[petAddress];
            for (uint i = 0; i < hospitalList.length; i++) {
                if (hospitalList[i] == msg.sender) {
                    userHasAccess = true;
                    break;
                }
            }
        }
        
        // 신규 반려동물인 경우 자동 등록 (소유자가 아닌 경우 제한)
        if (owners[petAddress] == address(0)) {
            require(userHasAccess, "No access permission");
            owners[petAddress] = msg.sender;
            emit OwnerChanged(petAddress, msg.sender, block.timestamp);
        } else {
            require(userHasAccess, "No access permission");
        }
        
        // deleteDate 속성의 경우 추가 검증
        if (keccak256(bytes(name)) == keccak256(bytes("deleteDate"))) {
            require(msg.sender == owners[petAddress], "Only owner can delete pet");
        }
        
        // 속성이 처음 설정되는 경우 이름 배열에 추가
        if (attributes[petAddress][name].expireDate == 0) {
            attributeNames[petAddress].push(name);
        }
        
        // 속성 설정
        attributes[petAddress][name] = Attribute(value, block.timestamp + validity);
        
        // 이벤트 발생
        emit AttributeChanged(petAddress, keccak256(bytes(name)), value, block.timestamp + validity, block.timestamp);
        
        // 반려동물 속성 변경 이벤트
        if (
            keccak256(bytes(name)) == keccak256(bytes("name")) ||
            keccak256(bytes(name)) == keccak256(bytes("gender")) ||
            keccak256(bytes(name)) == keccak256(bytes("flagNeutering")) ||
            keccak256(bytes(name)) == keccak256(bytes("breedName")) ||
            keccak256(bytes(name)) == keccak256(bytes("birth")) ||
            keccak256(bytes(name)) == keccak256(bytes("speciesName")) ||
            keccak256(bytes(name)) == keccak256(bytes("profileUrl"))
        ) {
            emit PetAttributeChanged(petAddress, msg.sender, block.timestamp);
        }
    }
    
    // 속성 조회 함수
    function getAttribute(address petAddress, string memory name) public view returns (string memory value, uint expireDate) {
        Attribute memory attr = attributes[petAddress][name];
        return (attr.value, attr.expireDate);
    }
    
    // 모든 속성 조회 함수
    function getAllAttributes(address petAddress) public view returns (string[] memory names, string[] memory values, uint[] memory expireDates) {
        uint count = attributeNames[petAddress].length;
        
        names = new string[](count);
        values = new string[](count);
        expireDates = new uint[](count);
        
        for (uint i = 0; i < count; i++) {
            string memory name = attributeNames[petAddress][i];
            names[i] = name;
            values[i] = attributes[petAddress][name].value;
            expireDates[i] = attributes[petAddress][name].expireDate;
        }
        
        return (names, values, expireDates);
    }
    
    // 의료기록 추가 함수
    function addMedicalRecord(
        address petAddress,
        string memory diagnosis,
        string memory hospitalName,
        string memory doctorName,
        string memory notes,
        string memory examinationsJson,
        string memory medicationsJson,
        string memory vaccinationsJson,
        string memory picturesJson,  // JSON 배열 형식으로 받음
        string memory status,        // 진료 상태 (WAITING, IN_PROGRESS, COMPLETED, CANCELLED, SHARED, NONE)
        bool flagCertificated        // 병원 인증 여부 (병원 작성: true, 보호자 작성: false)
    ) public {
        // 접근 권한 확인 (소유자 또는 등록된 병원)
        bool userHasAccess = (msg.sender == owners[petAddress]);
        
        if (!userHasAccess) {
            address[] storage hospitalList = hospitals[petAddress];
            for (uint i = 0; i < hospitalList.length; i++) {
                if (hospitalList[i] == msg.sender) {
                    userHasAccess = true;
                    break;
                }
            }
        }
        
        require(userHasAccess, "No permission to add medical record");
        require(!isPetDeleted(petAddress), "Cannot add medical record to deleted pet");
        
        // 병원인 경우 기본값 flagCertificated = true, 그 외 경우 입력값 사용
        bool isCertificated = flagCertificated;
        if (msg.sender != owners[petAddress]) {
            isCertificated = true; // 병원에서 작성하는 경우 항상 인증됨
        }
        
        // treatments JSON 구조 생성
        string memory treatmentsJson = string(abi.encodePacked(
            '{"examinations":', examinationsJson, ',',
            '"medications":', medicationsJson, ',',
            '"vaccinations":', vaccinationsJson, '}'
        ));
        
        // JSON 형태의 의료기록 생성
        string memory recordData = string(abi.encodePacked(
            '{"diagnosis":"', diagnosis, '",',
            '"treatments":', treatmentsJson, ',',
            '"hospitalName":"', hospitalName, '",',
            '"doctorName":"', doctorName, '",',
            '"notes":"', notes, '",',
            '"hospitalAddress":"', addressToString(msg.sender), '",',
            '"pictures":', (bytes(picturesJson).length > 0) ? picturesJson : '[]', ',',
            '"status":"', status, '",',
            '"flagCertificated":', isCertificated ? "true" : "false", ',',
            '"createdAt":', uint2str(block.timestamp), ',',
            '"isDeleted":false}'
        ));
        
        // 고유한 키 생성 (medical_record_timestamp_hospitalAddress)
        string memory recordKey = string(abi.encodePacked(
            "medical_record_",
            uint2str(block.timestamp),
            "_",
            addressToString(msg.sender)
        ));
        
        // 속성으로 저장 (5년 유효)
        setAttribute(petAddress, recordKey, recordData, 5 * 365 days);
    }
    
    // 의료기록 추가(이전 기록 참조) 함수
    function appendMedicalRecord(
        address petAddress, 
        string memory previousRecordKey, 
        string memory diagnosis, 
        string memory hospitalName,
        string memory doctorName, 
        string memory notes,
        string memory examinationsJson,
        string memory medicationsJson,
        string memory vaccinationsJson,
        string memory picturesJson,  // JSON 배열 형식으로 받음
        string memory status,        // 진료 상태 (WAITING, IN_PROGRESS, COMPLETED, CANCELLED, SHARED, NONE)
        bool flagCertificated        // 병원 인증 여부 (병원 작성: true, 보호자 작성: false)
    ) public {
        require(hasAccess(petAddress, msg.sender), "No access permission");
        require(!isPetDeleted(petAddress), "Pet is deleted");
        
        // 이전 기록 조회
        (string memory prevRecord, ) = getAttribute(petAddress, previousRecordKey);
        require(bytes(prevRecord).length > 0, "Previous record does not exist");
        
        // 병원인 경우 기본값 flagCertificated = true, 그 외 경우 입력값 사용
        bool isCertificated = flagCertificated;
        if (msg.sender != owners[petAddress]) {
            isCertificated = true; // 병원에서 작성하는 경우 항상 인증됨
        }
        
        // 새 기록 생성
        string memory timestamp = uint2str(block.timestamp);
        string memory hospitalAddress = addressToString(msg.sender);
        string memory recordKey = string(abi.encodePacked("medical_", timestamp));
        
        // treatments JSON 구조 생성
        string memory treatmentsJson = string(abi.encodePacked(
            '{"examinations":', examinationsJson, ',',
            '"medications":', medicationsJson, ',',
            '"vaccinations":', vaccinationsJson, '}'
        ));
        
        // JSON 형태의 의료기록 생성 시작
        string memory medicalData = string(abi.encodePacked(
            '{"diagnosis":"', diagnosis, '",',
            '"treatments":', treatmentsJson, ',',
            '"hospitalName":"', hospitalName, '",',
            '"doctorName":"', doctorName, '",',
            '"notes":"', notes, '",',
            '"hospitalAddress":"', hospitalAddress, '",',
            '"previousRecord":"', previousRecordKey, '",',
            '"pictures":', (bytes(picturesJson).length > 0) ? picturesJson : '[]', ',',
            '"status":"', status, '",',
            '"flagCertificated":', isCertificated ? "true" : "false", ',',
            '"timestamp":"', timestamp, '",',
            '"isDeleted":false}'
        ));
        
        // 의료 기록 저장
        setAttribute(petAddress, recordKey, medicalData, 0);
        emit MedicalRecordAdded(petAddress, recordKey, previousRecordKey, msg.sender, block.timestamp);
    }
    
    // 의료기록 소프트 삭제 함수
    function softDeleteMedicalRecord(address petAddress, string memory recordKey) public {
        // 접근 권한 확인 (소유자 또는 등록된 병원)
        bool userHasAccess = (msg.sender == owners[petAddress]);
        
        if (!userHasAccess) {
            address[] storage hospitalList = hospitals[petAddress];
            for (uint i = 0; i < hospitalList.length; i++) {
                if (hospitalList[i] == msg.sender) {
                    userHasAccess = true;
                    break;
                }
            }
        }
        
        require(userHasAccess, "No permission to delete medical record");
        
        // 기존 기록 가져오기
        (string memory recordData, uint expireDate) = getAttribute(petAddress, recordKey);
        require(bytes(recordData).length > 0, "Medical record does not exist");
        
        // 이미 삭제된 기록인지 확인
        require(!isRecordDeleted(recordData), "Medical record is already deleted");
        
        // 삭제 표시 추가
        string memory updatedData = replaceJsonBoolValue(recordData, "isDeleted", "true");
        updatedData = addJsonFieldValue(updatedData, "deletedAt", uint2str(block.timestamp));
        updatedData = addJsonFieldValue(updatedData, "deletedBy", addressToString(msg.sender));
        
        // 수정된 기록 저장
        setAttribute(petAddress, recordKey, updatedData, expireDate - block.timestamp);
        
        // 의료기록 삭제 이벤트 발생
        emit MedicalRecordDeleted(petAddress, recordKey, msg.sender, block.timestamp);
    }
    
    // 반려동물 소프트 삭제 함수
    function softDeletePet(address petAddress) public {
        require(msg.sender == owners[petAddress], "Only owner can delete pet");
        require(!isPetDeleted(petAddress), "Pet is already deleted");
        
        // deleteDate 속성 추가 (100년 유효)
        setAttribute(petAddress, "deleteDate", uint2str(block.timestamp), 100 * 365 days);
        
        // 반려동물 삭제 이벤트 발생
        emit PetDeleted(petAddress, msg.sender, block.timestamp);
    }
    
    // 반려동물 삭제 상태 확인 함수
    function isPetDeleted(address petAddress) public view returns (bool) {
        (string memory value, ) = getAttribute(petAddress, "deleteDate");
        return (bytes(value).length > 0);
    }
    
    // 의료기록 삭제 상태 확인 내부 함수
    function isRecordDeleted(string memory recordData) internal pure returns (bool) {
        bytes memory deletedFlag = bytes(',"isDeleted":true');
        bytes memory recordBytes = bytes(recordData);
        
        // 단순화된 문자열 검색
        if (recordBytes.length < deletedFlag.length) {
            return false;
        }
        
        // "isDeleted":true를 포함하는지 확인
        for (uint i = 0; i < recordBytes.length - deletedFlag.length + 1; i++) {
            bool found = true;
            for (uint j = 0; j < deletedFlag.length; j++) {
                if (recordBytes[i + j] != deletedFlag[j]) {
                    found = false;
                    break;
                }
            }
            if (found) {
                return true;
            }
        }
        
        return false;
    }
    
    // 반려동물 등록 여부 확인 함수
    function petExists(address petAddress) public view returns (bool) {
        return owners[petAddress] != address(0);
    }
    
    // 접근 권한 확인 함수
    function hasAccess(address petAddress, address user) public view returns (bool) {
        // 소유자인 경우
        if (owners[petAddress] == user) {
            return true;
        }
        
        // 공유 계약 확인
        SharingAgreement memory agreement = sharingAgreements[petAddress][user];
        if (agreement.exists) {
            // 만료되지 않은 계약이면 접근 권한 있음
            if (block.timestamp <= agreement.expireDate) {
                return true;
            }
            // 만료된 계약은 접근 권한 없음 (자동으로 처리되어야 함)
            return false;
        }
        
        // 공유 계약이 없으면 병원 목록 확인
        address[] storage hospitalList = hospitals[petAddress];
        for (uint i = 0; i < hospitalList.length; i++) {
            if (hospitalList[i] == user) {
                return true;
            }
        }
        
        return false;
    }
    
    // JSON 필드 값 변경 (불리언 값 전용)
    function replaceJsonBoolValue(string memory json, string memory fieldName, string memory newValue) internal pure returns (string memory) {
        bytes memory searchField = abi.encodePacked('"', fieldName, '":false');
        bytes memory jsonBytes = bytes(json);
        bytes memory fieldBytes = bytes(searchField);
        bytes memory newValueBytes = bytes(newValue);
        bytes memory fieldNameBytes = bytes(fieldName);
        
        for (uint i = 0; i < jsonBytes.length - fieldBytes.length + 1; i++) {
            bool found = true;
            for (uint j = 0; j < fieldBytes.length; j++) {
                if (jsonBytes[i + j] != fieldBytes[j]) {
                    found = false;
                    break;
                }
            }
            
            if (found) {
                // 필드를 찾았으면 값 변경
                bytes memory result = new bytes(jsonBytes.length - 5 + newValueBytes.length);
                
                // 필드 이전 부분 복사
                for (uint j = 0; j < i + fieldNameBytes.length + 3; j++) {
                    result[j] = jsonBytes[j];
                }
                
                // 새 값 복사
                for (uint j = 0; j < newValueBytes.length; j++) {
                    result[i + fieldNameBytes.length + 3 + j] = newValueBytes[j];
                }
                
                // 필드 이후 부분 복사
                for (uint j = 0; j < jsonBytes.length - (i + fieldBytes.length); j++) {
                    result[i + fieldNameBytes.length + 3 + newValueBytes.length + j] = jsonBytes[i + fieldBytes.length + j];
                }
                
                return string(result);
            }
        }
        
        // 필드를 찾지 못했으면 원본 반환
        return json;
    }
    
    // JSON에 새 필드 추가 함수
    function addJsonFieldValue(string memory json, string memory fieldName, string memory value) internal pure returns (string memory) {
        bytes memory jsonBytes = bytes(json);
        
        // 빈 JSON 체크
        if (jsonBytes.length == 0) {
            return string(abi.encodePacked('{"', fieldName, '":"', value, '"}'));
        }
        
        // JSON 마지막 } 위치 찾기
        uint lastBracePos = 0;
        bool foundBrace = false;
        
        for (uint i = 0; i < jsonBytes.length; i++) {
            if (jsonBytes[jsonBytes.length - 1 - i] == '}') {
                lastBracePos = jsonBytes.length - 1 - i;
                foundBrace = true;
                break;
            }
        }
        
        // 닫는 괄호가 없는 경우 처리
        if (!foundBrace) {
            return string(abi.encodePacked(json, '{"', fieldName, '":"', value, '"}'));
        }
        
        // 새 필드를 추가할 새 JSON 문자열 생성
        bytes memory fieldToAdd = abi.encodePacked(',"', fieldName, '":"', value, '"');
        bytes memory result = new bytes(jsonBytes.length - 1 + fieldToAdd.length);
        
        // 마지막 } 이전 부분 복사
        for (uint i = 0; i < lastBracePos; i++) {
            result[i] = jsonBytes[i];
        }
        
        // 새 필드 추가
        bytes memory fieldBytes = bytes(fieldToAdd);
        for (uint i = 0; i < fieldBytes.length; i++) {
            result[lastBracePos + i] = fieldBytes[i];
        }
        
        // 마지막 } 추가
        result[result.length - 1] = '}';
        
        return string(result);
    }
    
    // 주소를 문자열로 변환하는 유틸리티 함수
    function addressToString(address _addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";
        
        bytes memory str = new bytes(42);
        str[0] = "0";
        str[1] = "x";
        
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        
        return string(str);
    }
    
    // 정수를 문자열로 변환하는 유틸리티 함수
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        
        uint256 j = _i;
        uint256 length;
        
        while (j != 0) {
            length++;
            j /= 10;
        }
        
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        
        return string(bstr);
    }

    // 소유자의 반려동물 목록에 추가하는 내부 함수
    function _addPetToOwner(address owner, address petAddress) internal {
        // 소유자의 반려동물 목록에 추가
        ownerPets[owner].push(petAddress);
        // 인덱스 저장 (배열 위치 - 1)
        petToOwnerIndex[petAddress] = ownerPets[owner].length - 1;
    }

    // 소유자의 반려동물 목록에서 제거하는 내부 함수
    function _removePetFromOwner(address owner, address petAddress) internal {
        // 빈 배열 체크
        if (ownerPets[owner].length == 0) return;
        
        // 제거할 반려동물의 인덱스
        uint256 index = petToOwnerIndex[petAddress];
        // 배열 마지막 요소
        address lastPet = ownerPets[owner][ownerPets[owner].length - 1];
        
        if (index < ownerPets[owner].length) {
            // 마지막 요소를 제거할 위치로 이동
            ownerPets[owner][index] = lastPet;
            // 마지막 요소의 인덱스 업데이트
            petToOwnerIndex[lastPet] = index;
        }
        
        // 배열 크기 감소
        ownerPets[owner].pop();
        // 인덱스 매핑 제거
        delete petToOwnerIndex[petAddress];
    }

    // 새 함수: 소유자의 반려동물 목록 조회
    function getPetsByOwner(address owner) public view returns (address[] memory) {
        return ownerPets[owner];
    }

    // 새 함수: 소유자의 반려동물 수 조회
    function getOwnedPetsCount(address owner) public view returns (uint256) {
        return ownerPets[owner].length;
    }

    // 새 함수: 소유자의 반려동물 목록 조회 (삭제되지 않은 것만)
    function getActivePetsByOwner(address owner) public view returns (address[] memory) {
        // 활성 상태 반려동물 수 계산
        uint activeCount = 0;
        for (uint i = 0; i < ownerPets[owner].length; i++) {
            if (!isPetDeleted(ownerPets[owner][i])) {
                activeCount++;
            }
        }
        
        // 결과 배열 생성
        address[] memory activePets = new address[](activeCount);
        uint currentIndex = 0;
        
        // 활성 상태 반려동물만 추가
        for (uint i = 0; i < ownerPets[owner].length; i++) {
            address petAddress = ownerPets[owner][i];
            if (!isPetDeleted(petAddress)) {
                activePets[currentIndex] = petAddress;
                currentIndex++;
            }
        }
        
        return activePets;
    }

    // 병원 접근 권한 추가 함수에 공유 기능 통합
    function addHospitalWithSharing(
        address petAddress, 
        address hospitalAddress, 
        string memory scope, 
        uint sharingPeriod
    ) public {
        require(msg.sender == owners[petAddress], "Only owner can add hospital access");
        require(!isPetDeleted(petAddress), "Cannot add hospital access to deleted pet");
        require(hospitalAddress != address(0), "Invalid hospital address");
        
        // 공유 기간 유효성 검사
        require(sharingPeriod >= MIN_SHARING_PERIOD, "Sharing period must be at least 1 day");
        require(sharingPeriod <= MAX_SHARING_PERIOD, "Sharing period can be at most 30 days");
        
        // 현재 시간과 만료 시간 계산
        uint currentTime = block.timestamp;
        uint expireDate = currentTime + sharingPeriod;
        
        // 기존 병원 목록에 추가 - 내부 함수 직접 구현
        bool hospitalExists = false;
        for (uint i = 0; i < hospitals[petAddress].length; i++) {
            if (hospitals[petAddress][i] == hospitalAddress) {
                hospitalExists = true;
                break;
            }
        }
        
        if (!hospitalExists) {
            // _addHospital 함수를 직접 호출하지 않고 동일한 로직 수행
            hospitals[petAddress].push(hospitalAddress);
            emit HospitalChanged(petAddress, hospitalAddress, currentTime);
        }
        
        // 공유 계약 생성/갱신
        bool isNew = !sharingAgreements[petAddress][hospitalAddress].exists;
        
        // 계약 저장
        sharingAgreements[petAddress][hospitalAddress] = SharingAgreement(
            true,
            scope,
            currentTime,
            expireDate,
            false
        );
        
        // 조회 목록 업데이트 (새 계약인 경우에만)
        if (isNew) {
            hospitalPets[hospitalAddress].push(petAddress);
            petHospitals[petAddress].push(hospitalAddress);
        }
        
        // 이벤트 발생
        emit SharingAgreementCreated(
            petAddress, 
            hospitalAddress, 
            scope, 
            expireDate, 
            currentTime
        );
    }
    
    // 공유 계약 취소 함수
    function revokeSharingAgreement(address petAddress, address hospitalAddress) public {
        require(msg.sender == owners[petAddress], "Only pet owner can revoke sharing agreement");
        
        // 계약 존재 확인
        require(sharingAgreements[petAddress][hospitalAddress].exists, "Sharing agreement does not exist");
        
        // 계약 삭제
        delete sharingAgreements[petAddress][hospitalAddress];
        
        // 병원 접근 권한 제거 (기존 함수 재사용)
        try this._removeHospital(petAddress, hospitalAddress) {
            // 성공 시 아무 작업 없음
        } catch {
            // 실패 시 무시하고 계속 진행 - 병원이 삭제되었을 수 있음
        }
        
        // 병원별 반려동물 목록 및 반려동물별 병원 목록에서 제거
        removeFromArray(hospitalPets[hospitalAddress], petAddress);
        removeFromArray(petHospitals[petAddress], hospitalAddress);
        
        // 이벤트 발생
        emit SharingAgreementRevoked(petAddress, hospitalAddress, block.timestamp);
    }
    
    // 접근 권한 확인 함수 - 상태 변경 포함 (만료 계약 처리)
    function checkSharingPermission(address petAddress, address hospitalAddress) public returns (bool) {
        SharingAgreement storage agreement = sharingAgreements[petAddress][hospitalAddress];
        
        if (!agreement.exists) {
            return false;
        }
        
        // 만료 시간 확인
        if (block.timestamp > agreement.expireDate) {
            // 만료된 계약 자동 제거
            handleExpiredAgreement(petAddress, hospitalAddress);
            return false;
        }
        
        // 만료 임박 알림 체크 (3일 이내 만료 예정이고 아직 알림을 보내지 않은 경우)
        if (!agreement.notificationSent && 
            agreement.expireDate - block.timestamp <= NOTIFICATION_THRESHOLD) {
            agreement.notificationSent = true;
            emit SharingAgreementExpiringSoon(
                petAddress, 
                hospitalAddress, 
                agreement.expireDate, 
                block.timestamp
            );
        }
        
        return true;
    }
    
    // 만료된 계약 처리 함수
    function handleExpiredAgreement(address petAddress, address hospitalAddress) private {
        // 계약 삭제
        delete sharingAgreements[petAddress][hospitalAddress];
        
        // 병원 접근 권한 제거
        try this._removeHospital(petAddress, hospitalAddress) {
            // 성공 시 아무 작업 없음
        } catch {
            // 실패 시 무시하고 계속 진행
        }
        
        // 병원별 반려동물 목록 및 반려동물별 병원 목록에서 제거
        removeFromArray(hospitalPets[hospitalAddress], petAddress);
        removeFromArray(petHospitals[petAddress], hospitalAddress);
        
        // 이벤트 발생
        emit SharingAgreementRevoked(petAddress, hospitalAddress, block.timestamp);
    }
    
    // 배열에서 요소 제거 도우미 함수
    function removeFromArray(address[] storage array, address value) private {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                // 마지막 요소를 현재 위치로 이동하고 배열 크기 감소
                array[i] = array[array.length - 1];
                array.pop();
                return;
            }
        }
    }
    
    // 병원별 공유 중인 반려동물 목록 반환
    function getHospitalPets(address hospitalAddress) public view returns (address[] memory) {
        return hospitalPets[hospitalAddress];
    }
    
    // 반려동물별 공유 중인 병원 목록 반환
    function getPetHospitals(address petAddress) public view returns (address[] memory) {
        require(petExists(petAddress), "Pet does not exist");
        require(msg.sender == owners[petAddress] || hasAccess(petAddress, msg.sender), "No permission to view hospital list");
        return petHospitals[petAddress];
    }
    
    // 계약 정보 조회 함수
    function getAgreementDetails(address petAddress, address hospitalAddress) 
        public view returns (bool exists, string memory scope, uint createdAt, uint expireDate) {
        SharingAgreement memory agreement = sharingAgreements[petAddress][hospitalAddress];
        return (agreement.exists, agreement.scope, agreement.createdAt, agreement.expireDate);
    }
    
    // 만료 임박 계약 체크 (외부에서 주기적으로 호출)
    function checkExpiringAgreements(address hospitalAddress) public {
        address[] memory pets = hospitalPets[hospitalAddress];
        
        for (uint i = 0; i < pets.length; i++) {
            SharingAgreement storage agreement = sharingAgreements[pets[i]][hospitalAddress];
            
            // 만료 임박 알림 (3일 이내 만료 예정이고 아직 알림을 보내지 않은 경우)
            if (agreement.exists && 
                !agreement.notificationSent && 
                agreement.expireDate - block.timestamp <= NOTIFICATION_THRESHOLD) {
                
                agreement.notificationSent = true;
                emit SharingAgreementExpiringSoon(
                    pets[i], 
                    hospitalAddress, 
                    agreement.expireDate, 
                    block.timestamp
                );
            }
            
            // 만료된 계약 처리
            if (agreement.exists && block.timestamp > agreement.expireDate) {
                handleExpiredAgreement(pets[i], hospitalAddress);
            }
        }
    }
}




