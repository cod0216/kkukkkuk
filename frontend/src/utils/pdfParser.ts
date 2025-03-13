import * as pdfjs from 'pdfjs-dist';
import { TreatmentItem } from '../redux/slices/treatmentSlice';

// PDF.js 워커 설정
pdfjs.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.min.js`;

interface ParsedPdfData {
  diagnosis: string;
  diseaseName?: string;
  onsetDate?: string;
  diagnosisDate?: string;
  prognosis?: string;
  items: TreatmentItem[];
  nextAppointment?: string;
  petName?: string;
  petSpecies?: string;
  petBreed?: string;
  petGender?: string;
  petWeight?: string;
  petAge?: string;
  petColor?: string;
  hospitalName?: string;
  treatmentDate?: string;
  documentType: 'receipt' | 'diagnosis' | 'none';
  veterinarianName?: string;
  veterinarianLicense?: string;
}

// 공통 정규식
const hospitalNameRegex = /(.*)[병원동물의원센터]/;
const treatmentDateRegex = /(20\d{2}[\-/.년]\s*\d{1,2}[\-/.월]\s*\d{1,2}[일]?)/;
const petNameRegex = /[환자명동물명반려동물명:\s]+([가-힣a-zA-Z0-9\s]+)/;
const petSpeciesRegex = /[종류동물품종:\s]+([가-힣a-zA-Z]+)/;
const petBreedRegex = /[품종:\s]+([가-힣a-zA-Z\s]+)/;
const petGenderRegex = /[성별:\s]+([수암]\s*컷|[수암])/;
const petWeightRegex = /[체중무게:\s]+([0-9.]+)\s*kg/i;
const veterinarianNameRegex = /수의사[명\s:]+([가-힣a-zA-Z\s]+)/;
const veterinarianLicenseRegex = /수의사[면허\s:]+(제\s*\d+\s*호|[0-9\-]+)/;

// 진료세부내역영수증 관련 정규식
// 진료 항목 정규식은 가격 없이 항목과 수량만 추출하도록 변경
const treatmentItemRegex = /([가-힣a-zA-Z0-9\s\-_()]+)[\s\t]*x?\s*(\d+)(?:\s*회|개|정|캡슐|알)?/g;
// 진단명을 추출하는 정규식
const diagnosisRegex = /진단[명소견내용:\s]+(.*?)(?=\n|$)/;
// 다음 예약일을 추출하는 정규식
const nextAppointmentRegex = /다음[\s예약진료방문]*[일자:]+[:\s]*(20\d{2}[년\-/.]*\d{1,2}[월\-/.]*\d{1,2}[일]?)/;

// 진단서 관련 정규식
const diseaseNameRegex = /[병명질환:\s]+([가-힣a-zA-Z0-9\s\-_()]+)/;
const onsetDateRegex = /[발병일자날짜시작일:\s]+(20\d{2}[년\-/.]*\d{1,2}[월\-/.]*\d{1,2}[일]?)/;
const diagnosisDateRegex = /[진단일자날짜:\s]+(20\d{2}[년\-/.]*\d{1,2}[월\-/.]*\d{1,2}[일]?)/;
const prognosisRegex = /[예후소견처치방법:\s]+(.*?)(?=\n|$)/;
const petAgeRegex = /[나이연령:\s]+([0-9]+)[\s세살년]/;
const petColorRegex = /[모색털색:\s]+([가-힣a-zA-Z\s]+)/;

// 문서 유형 감지 함수
const detectDocumentType = (text: string): 'receipt' | 'diagnosis' | 'none' => {
  // 진단서에 특징적인 단어들
  const diagnosisKeywords = ['진단서', '수의사', '면허', '진단일', '발병일', '예후', '소견'];
  // 영수증에 특징적인 단어들
  const receiptKeywords = ['영수증', '결제', '금액', '합계', '세부내역', '진료비'];
  
  let diagnosisScore = 0;
  let receiptScore = 0;
  
  // 각 키워드의 존재 여부 검사
  diagnosisKeywords.forEach(keyword => {
    if (text.includes(keyword)) diagnosisScore++;
  });
  
  receiptKeywords.forEach(keyword => {
    if (text.includes(keyword)) receiptScore++;
  });
  
  // 점수에 기반하여 문서 타입 결정
  if (diagnosisScore > receiptScore && diagnosisScore >= 2) {
    return 'diagnosis';
  } else if (receiptScore > diagnosisScore && receiptScore >= 2) {
    return 'receipt';
  } else {
    // 단어 등장 횟수로 더 정확한 판단
    const diagnosisWordCount = diagnosisKeywords.filter(keyword => text.includes(keyword)).length;
    const receiptWordCount = receiptKeywords.filter(keyword => text.includes(keyword)).length;
    
    if (diagnosisWordCount > receiptWordCount) {
      return 'diagnosis';
    } else if (receiptWordCount > diagnosisWordCount) {
      return 'receipt';
    } else {
      return 'none';
    }
  }
};

/**
 * PDF 파일에서 텍스트를 추출하는 함수
 */
export const extractTextFromPdf = async (file: File): Promise<string> => {
  return new Promise((resolve, reject) => {
    const fileReader = new FileReader();
    
    fileReader.onload = async (event) => {
      try {
        const typedArray = new Uint8Array(event.target!.result as ArrayBuffer);
        const loadingTask = pdfjs.getDocument(typedArray);
        const pdf = await loadingTask.promise;
        
        let fullText = '';
        
        // 모든 페이지의 텍스트 추출
        for (let i = 1; i <= pdf.numPages; i++) {
          const page = await pdf.getPage(i);
          const textContent = await page.getTextContent();
          const textItems = textContent.items as any[];
          const pageText = textItems.map(item => item.str).join(' ');
          fullText += pageText + '\n';
        }
        
        resolve(fullText);
      } catch (error) {
        reject(error);
      }
    };
    
    fileReader.onerror = (error) => {
      reject(error);
    };
    
    fileReader.readAsArrayBuffer(file);
  });
};

/**
 * 진료세부내역영수증 파싱 함수
 */
const parseReceiptData = (text: string): Partial<ParsedPdfData> => {
  const result: Partial<ParsedPdfData> = {
    items: [],
    documentType: 'receipt'
  };
  
  // 진단명 추출
  const diagnosisMatch = text.match(diagnosisRegex);
  if (diagnosisMatch && diagnosisMatch[1]) {
    result.diagnosis = diagnosisMatch[1].trim();
  }
  
  // 진료 항목 및 수량 추출
  let matches;
  while ((matches = treatmentItemRegex.exec(text)) !== null) {
    const name = matches[1].trim();
    const quantity = parseInt(matches[2], 10) || 1;
    
    // 특정 키워드로 용량과 횟수 추정
    let dosage = '';
    let frequency = '';
    
    if (name.includes('mg') || name.includes('ml') || name.includes('g')) {
      // 용량 추출 시도
      const dosageMatch = name.match(/(\d+(?:\.\d+)?\s*(?:mg|ml|g|mcg))/i);
      if (dosageMatch) dosage = dosageMatch[1];
    }
    
    if (name.includes('일') || name.includes('회') || name.includes('시간')) {
      // 복용 빈도 추출 시도
      const freqMatch = name.match(/(하루\s*\d+회|매일|아침|저녁|\d+시간마다)/);
      if (freqMatch) frequency = freqMatch[1];
    }
    
    result.items!.push({
      name,
      quantity,
      dosage,
      frequency
    });
  }
  
  // 다음 예약일 추출
  const nextAppointmentMatch = text.match(nextAppointmentRegex);
  if (nextAppointmentMatch && nextAppointmentMatch[1]) {
    result.nextAppointment = nextAppointmentMatch[1];
  }
  
  // 병원명 추출
  const hospitalNameMatch = text.match(hospitalNameRegex);
  if (hospitalNameMatch && hospitalNameMatch[0]) {
    result.hospitalName = hospitalNameMatch[0].trim();
  }
  
  // 진료일 추출
  const treatmentDateMatch = text.match(treatmentDateRegex);
  if (treatmentDateMatch && treatmentDateMatch[1]) {
    result.treatmentDate = treatmentDateMatch[1];
  }
  
  // 반려동물 이름 추출
  const petNameMatch = text.match(petNameRegex);
  if (petNameMatch && petNameMatch[1]) {
    result.petName = petNameMatch[1].trim();
  }
  
  // 반려동물 종류 추출
  const petSpeciesMatch = text.match(petSpeciesRegex);
  if (petSpeciesMatch && petSpeciesMatch[1]) {
    result.petSpecies = petSpeciesMatch[1].trim();
  }
  
  // 반려동물 품종 추출
  const petBreedMatch = text.match(petBreedRegex);
  if (petBreedMatch && petBreedMatch[1]) {
    result.petBreed = petBreedMatch[1].trim();
  }
  
  // 반려동물 성별 추출
  const petGenderMatch = text.match(petGenderRegex);
  if (petGenderMatch && petGenderMatch[1]) {
    result.petGender = petGenderMatch[1].includes('수') ? 'male' : 'female';
  }
  
  // 반려동물 체중 추출
  const petWeightMatch = text.match(petWeightRegex);
  if (petWeightMatch && petWeightMatch[1]) {
    result.petWeight = petWeightMatch[1];
  }
  
  // 수의사 이름 추출
  const veterinarianNameMatch = text.match(veterinarianNameRegex);
  if (veterinarianNameMatch && veterinarianNameMatch[1]) {
    result.veterinarianName = veterinarianNameMatch[1].trim();
  }
  
  // 수의사 면허번호 추출
  const veterinarianLicenseMatch = text.match(veterinarianLicenseRegex);
  if (veterinarianLicenseMatch && veterinarianLicenseMatch[1]) {
    result.veterinarianLicense = veterinarianLicenseMatch[1].trim();
  }
  
  return result;
};

/**
 * 진단서 파싱 함수
 */
const parseDiagnosisData = (text: string): Partial<ParsedPdfData> => {
  const result: Partial<ParsedPdfData> = {
    items: [],
    documentType: 'diagnosis'
  };
  
  // 진단명 추출
  const diagnosisMatch = text.match(diagnosisRegex);
  if (diagnosisMatch && diagnosisMatch[1]) {
    result.diagnosis = diagnosisMatch[1].trim();
  }
  
  // 병명 추출
  const diseaseNameMatch = text.match(diseaseNameRegex);
  if (diseaseNameMatch && diseaseNameMatch[1]) {
    result.diseaseName = diseaseNameMatch[1].trim();
  }
  
  // 발병일 추출
  const onsetDateMatch = text.match(onsetDateRegex);
  if (onsetDateMatch && onsetDateMatch[1]) {
    result.onsetDate = onsetDateMatch[1].trim();
  }
  
  // 진단일 추출
  const diagnosisDateMatch = text.match(diagnosisDateRegex);
  if (diagnosisDateMatch && diagnosisDateMatch[1]) {
    result.diagnosisDate = diagnosisDateMatch[1].trim();
  }
  
  // 예후 소견 추출
  const prognosisMatch = text.match(prognosisRegex);
  if (prognosisMatch && prognosisMatch[1]) {
    result.prognosis = prognosisMatch[1].trim();
  }
  
  // 병원명 추출
  const hospitalNameMatch = text.match(hospitalNameRegex);
  if (hospitalNameMatch && hospitalNameMatch[0]) {
    result.hospitalName = hospitalNameMatch[0].trim();
  }
  
  // 진료일 추출
  const treatmentDateMatch = text.match(treatmentDateRegex);
  if (treatmentDateMatch && treatmentDateMatch[1]) {
    result.treatmentDate = treatmentDateMatch[1];
  }
  
  // 반려동물 이름 추출
  const petNameMatch = text.match(petNameRegex);
  if (petNameMatch && petNameMatch[1]) {
    result.petName = petNameMatch[1].trim();
  }
  
  // 반려동물 종류 추출
  const petSpeciesMatch = text.match(petSpeciesRegex);
  if (petSpeciesMatch && petSpeciesMatch[1]) {
    result.petSpecies = petSpeciesMatch[1].trim();
  }
  
  // 반려동물 품종 추출
  const petBreedMatch = text.match(petBreedRegex);
  if (petBreedMatch && petBreedMatch[1]) {
    result.petBreed = petBreedMatch[1].trim();
  }
  
  // 반려동물 성별 추출
  const petGenderMatch = text.match(petGenderRegex);
  if (petGenderMatch && petGenderMatch[1]) {
    result.petGender = petGenderMatch[1].includes('수') ? 'male' : 'female';
  }
  
  // 반려동물 나이 추출
  const petAgeMatch = text.match(petAgeRegex);
  if (petAgeMatch && petAgeMatch[1]) {
    result.petAge = petAgeMatch[1].trim();
  }
  
  // 반려동물 모색 추출
  const petColorMatch = text.match(petColorRegex);
  if (petColorMatch && petColorMatch[1]) {
    result.petColor = petColorMatch[1].trim();
  }
  
  // 수의사 이름 추출
  const veterinarianNameMatch = text.match(veterinarianNameRegex);
  if (veterinarianNameMatch && veterinarianNameMatch[1]) {
    result.veterinarianName = veterinarianNameMatch[1].trim();
  } else {
    // 진단서 하단에 서명 부분에서 추출 시도
    const signatureMatch = text.match(/수의사[^가-힣]*([가-힣]{2,5})[^\n]*/);
    if (signatureMatch && signatureMatch[1]) {
      result.veterinarianName = signatureMatch[1].trim();
    }
  }
  
  // 수의사 면허번호 추출
  const veterinarianLicenseMatch = text.match(veterinarianLicenseRegex);
  if (veterinarianLicenseMatch && veterinarianLicenseMatch[1]) {
    result.veterinarianLicense = veterinarianLicenseMatch[1].trim();
  } else {
    // 면허번호 형식으로 추출 시도
    const licenseMatch = text.match(/제\s*(\d+)\s*호/);
    if (licenseMatch && licenseMatch[1]) {
      result.veterinarianLicense = `제${licenseMatch[1]}호`;
    }
  }
  
  return result;
};

/**
 * 추출된 텍스트에서 진료 정보를 파싱하는 함수
 */
export const parseTreatmentData = (text: string): ParsedPdfData => {
  // 문서 유형 감지
  const documentType = detectDocumentType(text);
  
  // 초기 결과 객체
  const baseResult: ParsedPdfData = {
    diagnosis: '',
    items: [],
    documentType
  };
  
  // 문서 유형에 따라 적절한 파서 선택
  let parsedData: Partial<ParsedPdfData> = {};
  
  if (documentType === 'receipt') {
    parsedData = parseReceiptData(text);
  } else if (documentType === 'diagnosis') {
    parsedData = parseDiagnosisData(text);
  } else {
    // 유형 감지 실패 시 양쪽 다 시도
    const receiptData = parseReceiptData(text);
    const diagnosisData = parseDiagnosisData(text);
    
    // 더 많은 정보를 추출한 파서의 결과 사용
    const receiptDataCount = Object.keys(receiptData).filter(key => Boolean((receiptData as any)[key])).length;
    const diagnosisDataCount = Object.keys(diagnosisData).filter(key => Boolean((diagnosisData as any)[key])).length;
    
    parsedData = receiptDataCount >= diagnosisDataCount ? receiptData : diagnosisData;
  }
  
  // 수의사 정보가 없을 경우 기본값 설정
  if (!parsedData.veterinarianName) {
    parsedData.veterinarianName = '담당 수의사';
  }
  
  return { ...baseResult, ...parsedData };
};

/**
 * PDF 파일에서 진료 정보를 파싱하는 메인 함수
 */
export const parsePdfFile = async (file: File): Promise<ParsedPdfData> => {
  try {
    const text = await extractTextFromPdf(file);
    return parseTreatmentData(text);
  } catch (error) {
    console.error("PDF 파싱 오류:", error);
    throw new Error("PDF 파일을 처리하는 동안 오류가 발생했습니다.");
  }
}; 