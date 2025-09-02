export interface PharmaceuticalAttributesDTO {
  id: string;
  strength?: string;
  dosage_form?: string;
  active_ingredient?: string;
  therapeutic_class?: string;
  generic_name?: string;
  manufacturer?: string;
  route_of_administration?: string;
  prescription_status?: "prescription" | "over_the_counter" | "controlled_substance";
  storage_conditions?: string;
  packaging_size?: string;
  primary_indication?: string;
  contraindications?: string;
  created_at: Date;
  updated_at: Date;
}

export type PrescriptionStatus = "prescription" | "over_the_counter" | "controlled_substance";

export interface PharmaceuticalProduct {
  pharmaceutical_attributes?: PharmaceuticalAttributesDTO;
}

// Extended StoreProduct type with pharmaceutical attributes
export interface StoreProductWithPharmaceuticalAttributes {
  id: string;
  title: string;
  description?: string;
  pharmaceutical_attributes?: PharmaceuticalAttributesDTO;
  // Add other product properties as needed
}