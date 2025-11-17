
export interface Department {
  name: string;
  courses: Course[];
}

export interface Course {
  courseName: string;
  code: string;
  curriculum: Semester[];
}

export interface Semester {
  name: string;
  subjects: Subject[];
}

export type Subject =
  | {
      subType: string;
      elective: false;
      subCode: string;
      subName: string;
      LTP: number[];
      credits: number;
      syllabus?: string;
    }
  | {
      subType: string;
      elective: true;
    };
