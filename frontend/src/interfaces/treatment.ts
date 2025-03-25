import { Gender } from "./pet";

export enum TreatmentState {
    WAITING = "대기중",
    IN_PROGRESS = "진료중",
    COMPLETED = "진료완료",
    NONE = "",
}

export interface GetTreatmentRequest {
  expired? : boolean;
  petId? : number;
  state? : TreatmentState
}


export interface Treatment {
  state: TreatmentState;
  id: number;
  expireDate: string;
  createdAt: string;

  petId: number;
  petDid: string;
  name: string;
  birth: string;
  age: number;
  gender: Gender;
  flagNeutering: boolean;
  breedName: string;
}


export interface TreatmentResponse {
  treatments:Treatment[]
}



export interface BlockChainTreatment {
  disease: string;
  date: string;
  hospital: string;
}