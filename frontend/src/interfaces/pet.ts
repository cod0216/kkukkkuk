import {TreatmentState, Treatment} from "./treatment"
export interface Pet {
    id: number;
    name: string;
    breed: string;
    age: number;
    weight: number;
    gender: Gender;
    flagNeutered: boolean;
    state: TreatmentState;
    owner: string;
    phone: string;
    treatments: Treatment[];
  }

export enum Gender {
    MALE = "수컷",
    FEMAIL = "암컷"
}


// 변환 함수
export const normalizePets = (rawPets: any[]): Pet[] => {
    const petMap = new Map<number, Pet>();

    rawPets.forEach(pet => {
        const id = pet.id;
        const formattedPet: Pet = {
            id: id,
            name: pet.name,
            breed: pet.breed,
            age: pet.age,
            weight: pet.weight,
            gender: pet.gender,
            flagNeutered: pet.flagNeutered ?? pet.neutered ?? false,
            state: pet.state,
            owner: pet.owner,
            phone: pet.phone,
            treatments: pet.treatments || []
        };

        if (petMap.has(id)) {
            petMap.get(id)!.treatments.push(...formattedPet.treatments);
        } else {
            petMap.set(id, formattedPet);
        }
    });

    return Array.from(petMap.values());
};