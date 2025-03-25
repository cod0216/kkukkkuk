/**
 * Hospital Base Info interface
 */
export interface HospitalBase {
  id: number;
  name?: string;
  address?: string;
  phone_number?: string;
  authorization_number?: string;
  x_axis?: number;
  y_axis?: number;
}

/**
 * Hospital Detail Info Interface
 */
export interface HospitalDetail extends HospitalBase {
  phone_number?: string;
  did?: string;
  account?: string;
  password?: string;
  public_key?: string;
  delete_date?: string;
  email?: string;
  doctor_name?: string;
}
