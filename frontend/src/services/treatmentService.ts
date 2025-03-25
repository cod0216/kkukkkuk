import { GetTreatmentRequest, TreatmentResponse } from "@/interfaces";
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";

///api/hospitals/me/treatment?expired={expired}&state={state}&pet_id={petId}



/**
 * getTreatments API
 */
export const getTreatments = async (data: GetTreatmentRequest): Promise<ApiResponse<TreatmentResponse>> => {
  const response = await request.get<TreatmentResponse>(
    `/api/hospitals/me/treatment?expired=${data.expired}&state=${data.state}&pet_id=${data.petId}`,
    data
  );
  return response;
};