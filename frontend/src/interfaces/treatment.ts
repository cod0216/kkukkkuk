export enum TreatmentState {
    WAITING = "대기중",
    IN_PROGRESS = "진료중",
    COMPLETED = "진료완료",
    NONE = "전체",
  }


export interface Treatment {
  disease: string;
  date: string;
  hospital: string;
}
