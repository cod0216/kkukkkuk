
// 네트워크 설정
export const NETWORK_CONFIG = {
  rpcUrl: 'https://rpc.ssafy-blockchain.com',
  wsUrl: 'wss://ws.ssafy-blockchain.com',
  chainId: 31221,
  chainName: 'SSAFY',
  nativeCurrency: {
    name: 'ETH',
    symbol: 'ETH',
    decimals: 18
  }
};

// 컨트랙트 주소
export const DID_REGISTRY_ADDRESS = '0x56e3e3B9d31B070c96e264b645D0763b2DC49e65';

// 가스 설정
export const GAS_SETTINGS = {
  gasLimit: 3000000,
  gasPrice: '20000000000' // 20 Gwei
};

// DID 레지스트리 ABI 정의
export const didRegistryABI = [
  {
    "inputs": [],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "bytes32",
        "name": "name",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "value",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "expireDate",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "AttributeChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "HospitalChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "string",
        "name": "recordKey",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "previousRecordKey",
        "type": "string"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "addedBy",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "MedicalRecordAdded",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "string",
        "name": "recordKey",
        "type": "string"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "deletedBy",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "MedicalRecordDeleted",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "ownerAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "OwnerChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "ownerAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "PetAttributeChanged",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "ownerAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "PetDeleted",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "ownerAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "PetRegistered",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "string",
        "name": "scope",
        "type": "string"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "expireDate",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "createdAt",
        "type": "uint256"
      }
    ],
    "name": "SharingAgreementCreated",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "expireDate",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "notificationTime",
        "type": "uint256"
      }
    ],
    "name": "SharingAgreementExpiringSoon",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "timestamp",
        "type": "uint256"
      }
    ],
    "name": "SharingAgreementRevoked",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "MAX_SHARING_PERIOD",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "MIN_SHARING_PERIOD",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "NOTIFICATION_THRESHOLD",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "_addHospital",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "_registerPetOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "_removeHospital",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "scope",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "sharingPeriod",
        "type": "uint256"
      }
    ],
    "name": "addHospitalWithSharing",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "diagnosis",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "hospitalName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "doctorName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "notes",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "examinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "medicationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "vaccinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "picturesJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "status",
        "type": "string"
      },
      {
        "internalType": "bool",
        "name": "flagCertificated",
        "type": "bool"
      },
      {
        "internalType": "uint256",
        "name": "treatmentDate",
        "type": "uint256"
      }
    ],
    "name": "addMedicalRecord",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "diagnosis",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "hospitalName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "doctorName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "notes",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "examinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "medicationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "vaccinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "picturesJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "status",
        "type": "string"
      },
      {
        "internalType": "bool",
        "name": "flagCertificated",
        "type": "bool"
      },
      {
        "internalType": "uint256",
        "name": "treatmentDate",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "hospitalAccountId",
        "type": "string"
      }
    ],
    "name": "addMedicalRecord",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "previousRecordKey",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "diagnosis",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "hospitalName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "doctorName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "notes",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "examinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "medicationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "vaccinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "picturesJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "status",
        "type": "string"
      },
      {
        "internalType": "bool",
        "name": "flagCertificated",
        "type": "bool"
      },
      {
        "internalType": "uint256",
        "name": "treatmentDate",
        "type": "uint256"
      }
    ],
    "name": "appendMedicalRecord",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "previousRecordKey",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "diagnosis",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "hospitalName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "doctorName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "notes",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "examinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "medicationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "vaccinationsJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "picturesJson",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "status",
        "type": "string"
      },
      {
        "internalType": "bool",
        "name": "flagCertificated",
        "type": "bool"
      },
      {
        "internalType": "uint256",
        "name": "treatmentDate",
        "type": "uint256"
      },
      {
        "internalType": "string",
        "name": "hospitalAccountId",
        "type": "string"
      }
    ],
    "name": "appendMedicalRecord",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "changeOwner",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "checkExpiringAgreements",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "checkSharingPermission",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "owner",
        "type": "address"
      }
    ],
    "name": "getActivePetsByOwner",
    "outputs": [
      {
        "internalType": "address[]",
        "name": "",
        "type": "address[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "getAgreementDetails",
    "outputs": [
      {
        "internalType": "bool",
        "name": "exists",
        "type": "bool"
      },
      {
        "internalType": "string",
        "name": "scope",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "createdAt",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "expireDate",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "getAllAttributes",
    "outputs": [
      {
        "internalType": "string[]",
        "name": "names",
        "type": "string[]"
      },
      {
        "internalType": "string[]",
        "name": "values",
        "type": "string[]"
      },
      {
        "internalType": "uint256[]",
        "name": "expireDates",
        "type": "uint256[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "name",
        "type": "string"
      }
    ],
    "name": "getAttribute",
    "outputs": [
      {
        "internalType": "string",
        "name": "value",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "expireDate",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "getHospitalPets",
    "outputs": [
      {
        "internalType": "address[]",
        "name": "",
        "type": "address[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "originalRecordKey",
        "type": "string"
      }
    ],
    "name": "getMedicalRecordUpdates",
    "outputs": [
      {
        "internalType": "string[]",
        "name": "",
        "type": "string[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "originalRecordKey",
        "type": "string"
      }
    ],
    "name": "getMedicalRecordWithUpdates",
    "outputs": [
      {
        "internalType": "string",
        "name": "originalRecord",
        "type": "string"
      },
      {
        "internalType": "string[]",
        "name": "updateRecords",
        "type": "string[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "owner",
        "type": "address"
      }
    ],
    "name": "getOwnedPetsCount",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "getPetHospitals",
    "outputs": [
      {
        "internalType": "address[]",
        "name": "",
        "type": "address[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "getPetOriginalRecords",
    "outputs": [
      {
        "internalType": "string[]",
        "name": "",
        "type": "string[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "owner",
        "type": "address"
      }
    ],
    "name": "getPetsByOwner",
    "outputs": [
      {
        "internalType": "address[]",
        "name": "",
        "type": "address[]"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "user",
        "type": "address"
      }
    ],
    "name": "hasAccess",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "hospitalPets",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "hospitals",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "string",
        "name": "recordKey",
        "type": "string"
      }
    ],
    "name": "isOriginalRecord",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "pure",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "isPetDeleted",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "owners",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "petExists",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "petHospitals",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "name",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "gender",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "breedName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "birth",
        "type": "string"
      },
      {
        "internalType": "bool",
        "name": "flagNeutering",
        "type": "bool"
      },
      {
        "internalType": "string",
        "name": "speciesName",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "profileUrl",
        "type": "string"
      }
    ],
    "name": "registerPetWithAttributes",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "hospitalAddress",
        "type": "address"
      }
    ],
    "name": "revokeSharingAgreement",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "name",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "value",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "validity",
        "type": "uint256"
      }
    ],
    "name": "setAttribute",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "sharingAgreements",
    "outputs": [
      {
        "internalType": "bool",
        "name": "exists",
        "type": "bool"
      },
      {
        "internalType": "string",
        "name": "scope",
        "type": "string"
      },
      {
        "internalType": "uint256",
        "name": "createdAt",
        "type": "uint256"
      },
      {
        "internalType": "uint256",
        "name": "expireDate",
        "type": "uint256"
      },
      {
        "internalType": "bool",
        "name": "notificationSent",
        "type": "bool"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "recordKey",
        "type": "string"
      }
    ],
    "name": "softDeleteMedicalRecord",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "petAddress",
        "type": "address"
      }
    ],
    "name": "softDeletePet",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];