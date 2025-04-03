/**
 * @module treatmentImageService
 * @file treatmentImageService.ts
 * @author seonghun
 * @date 2025-04-02
 * @description 이미지 업로드 서비스
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-02        seonghun     최초 생성
 */




import axios from 'axios';
import { getAccessToken } from '@/utils/tokenUtil';
import { ApiResponse, ResponseStatus } from '@/types';

// 이미지 업로드 엔드포인트 URL
const SERVER_URL = import.meta.env.VITE_SERVER_URL;
const IMAGE_UPLOAD_URL = '/api/images/permanent';

// 가능한 응답 형식을 정의하는 타입
type ImageResponseType = ApiResponse<string> | string | { data: string } | Record<string, any>;

/**
 * 이미지를 서버에 업로드하고 S3 URL을 반환합니다.
 * @param imageFile 업로드할 이미지 파일
 * @param domain 이미지가 속한 도메인 (기본값: 'treatment')
 * @returns 성공 시 S3 URL, 실패 시 null
 */
export const uploadImage = async (imageFile: File, domain: string = 'treatment'): Promise<string | null> => {
  if (!imageFile) {
    console.error('업로드할 이미지 파일이 없습니다.');
    return null;
  }

  try {
    console.log(`이미지 업로드 시작: ${imageFile.name} (${(imageFile.size / 1024).toFixed(2)} KB), 도메인: ${domain}`);
    
    // FormData 설정 - curl 명령어와 동일한 방식으로
    const formData = new FormData();
    formData.append('image', imageFile);
    formData.append('domain', domain);
    
    // FormData 내용 확인
    console.log('FormData 항목 확인:');
    for (const pair of formData.entries()) {
      console.log(`- ${pair[0]}: ${typeof pair[1] === 'object' ? '파일 객체' : pair[1]}`);
    }
    
    // 액세스 토큰 가져오기
    const accessToken = getAccessToken();
    
    // 전체 URL 구성
    const fullUrl = `${SERVER_URL}${IMAGE_UPLOAD_URL}`;
    console.log(`요청 URL: ${fullUrl}`);
    
    // axios를 사용한 직접 요청 (apiClient 우회)
    const response = await axios<ImageResponseType>({
      method: 'POST',
      url: fullUrl,
      data: formData,
      headers: {
        'Accept': '*/*',
        'Authorization': accessToken ? `Bearer ${accessToken}` : '',
        // Content-Type은 FormData에서 자동으로 설정됨
      },
      // 요청 상태 디버깅
      onUploadProgress: (progressEvent) => {
        const percentCompleted = Math.round((progressEvent.loaded * 100) / (progressEvent.total || 1));
        console.log(`업로드 진행률: ${percentCompleted}%`);
      }
    });
    
    // 응답 로깅
    console.log('응답 상태:', response.status);
    console.log('응답 데이터 타입:', typeof response.data);
    console.log('응답 데이터:', response.data);
    
    // 응답 데이터 처리 (ApiResponse 타입에 맞게 수정)
    if (response.status >= 200 && response.status < 300) {
      // ApiResponse 구조에 맞는 응답인지 확인
      if (response.data && typeof response.data === 'object' && 'status' in response.data) {
        // ApiResponse 형식의 응답
        const apiResponse = response.data as ApiResponse<string>;
        
        if (apiResponse.status === ResponseStatus.SUCCESS && apiResponse.data) {
          const imageUrl = apiResponse.data;
          console.log('이미지 업로드 성공 (ApiResponse):', imageUrl);
          return imageUrl;
        } else {
          console.error('이미지 업로드 실패:', apiResponse.message || '알 수 없는 오류');
        }
      } 
      // 직접 URL을 반환하는 경우
      else if (typeof response.data === 'string' && response.data.includes('https://')) {
        const imageUrl = response.data;
        console.log('이미지 업로드 성공 (직접 URL):', imageUrl);
        return imageUrl;
      }
      // 다른 형식의 응답 객체인 경우
      else if (response.data && typeof response.data === 'object') {
        // data 필드에 URL이 있는 경우
        const responseObj = response.data as Record<string, any>;
        if (responseObj.data && typeof responseObj.data === 'string') {
          const imageUrl = responseObj.data;
          console.log('이미지 업로드 성공 (data 필드):', imageUrl);
          return imageUrl;
        }
        // 응답 객체에 URL이 포함된 경우
        else {
          const responseText = JSON.stringify(responseObj);
          const urlMatch = responseText.match(/https:\/\/[^"'\s]+/);
          if (urlMatch) {
            const imageUrl = urlMatch[0];
            console.log('이미지 업로드 성공 (URL 추출):', imageUrl);
            return imageUrl;
          }
        }
      }
      
      console.error('응답에서 이미지 URL을 찾을 수 없습니다:', response.data);
    } else {
      console.error('서버 응답 오류:', response.status, response.data);
    }
    
    return null;
  } catch (error: any) {
    // 에러 객체 로깅
    console.error('이미지 업로드 중 오류 발생:');
    console.error('- 메시지:', error.message);
    
    if (error.response) {
      console.error('- 응답 상태:', error.response.status);
      console.error('- 응답 데이터:', error.response.data);
      
      // ApiResponse 형식의 에러 응답인 경우 메시지 추출
      if (error.response.data && 
          typeof error.response.data === 'object' && 
          'message' in error.response.data) {
        console.error('- 에러 메시지:', error.response.data.message);
      }
    }
    
    if (error.request) {
      console.error('- 요청 정보:', error.request);
    }
    
    return null;
  }
};
