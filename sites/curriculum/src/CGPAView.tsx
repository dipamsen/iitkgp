import {
  Box,
  Button,
  Container,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControl,
  InputLabel,
  MenuItem,
  NativeSelect,
  Select,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Typography,
} from "@mui/material";
import { useEffect, useState } from "react";

interface Department {
  name: string;
  courses: Course[];
}

interface Course {
  courseName: string;
  code: string;
  curriculum: Semester[];
}

interface Semester {
  name: string;
  subjects: Subject[];
}

interface Subject {
  subType: string;
  subCode: string;
  subName: string;
  LTP: number[];
  credits: number;
  syllabus?: string;
}

const grades = {
  EX: 10,
  A: 9,
  B: 8,
  C: 7,
  D: 6,
  P: 5,
  // F: 0,
  // X: 0,
};

type Grade = keyof typeof grades;

function CGPAView() {
  const [_startYear, set_StartYear] = useState<number>(2024);
  const [_selectedDept, set_SelectedDept] = useState<number | "">("");
  const [_selectedCourse, set_SelectedCourse] = useState<string>("");

  const [data, setData] = useState<Department[]>([]);

  const [startYear, setStartYear] = useState<number>(2024);
  const [selectedDept, setSelectedDept] = useState<number | "">("");
  const [selectedCourse, setSelectedCourse] = useState<string>("");

  const [configModal, setConfigModal] = useState<boolean>(false);

  const [semWiseGrades, setSemWiseGrades] = useState<Record<string, Grade>[]>(
    []
  );

  useEffect(() => {
    fetch(
      import.meta.env.PROD
        ? "https://dipamsen.github.io/iitkgp/curriculum.json"
        : "curriculum.json"
    )
      .then((res) => res.json())
      .then((data: Department[]) => {
        const cleaned = data
          .map((dept) => {
            dept.courses = dept.courses.filter((c) => c.curriculum.length > 0);
            return dept;
          })
          .filter((dept) => dept.courses.length > 0);

        setData(cleaned);
      });
  }, []);

  useEffect(() => {
    if (data.length === 0) return;
    // first time, choose config (yr, dept, course)
    // save to local storage
    // if local storage exists, load from there

    if (localStorage.getItem("kgp-curriculum")) {
      const { year, course } = JSON.parse(
        localStorage.getItem("kgp-curriculum")!
      );
      setStartYear(year);
      setSelectedCourse(course);
      setSelectedDept(
        data.findIndex((dept) =>
          dept.courses.some((crs) => crs.code === course)
        ) + 1
      );
      if (localStorage.getItem("kgp-curriculum-grades")) {
        setSemWiseGrades(
          JSON.parse(localStorage.getItem("kgp-curriculum-grades")!)
        );
      } else {
        const initGrades = Array(
          data
            .find((dept) => dept.courses.some((crs) => crs.code === course)!)!
            .courses.find((x) => x.code === course)!.curriculum.length
        ).fill({});
        for (let i = 0; i < initGrades.length; i++) {
          initGrades[i] = data
            .find((dept) => dept.courses.some((crs) => crs.code === course))!
            .courses.find((x) => x.code === course)!
            .curriculum[i].subjects.reduce(
              (acc, curr) => ({ ...acc, [curr.subCode]: "EX" }),
              {}
            );
        }

        setSemWiseGrades(initGrades);
      }
    } else {
      // show modal
      setConfigModal(true);
    }
  }, [data]);

  useEffect(() => {
    if (semWiseGrades.length === 0) return;
    localStorage.setItem(
      "kgp-curriculum-grades",
      JSON.stringify(semWiseGrades)
    );
  }, [semWiseGrades]);

  const course = selectedDept
    ? data[selectedDept - 1]?.courses.find((c) => c.code === selectedCourse)
    : undefined;

  const getSemName = (i: number) => {
    let sem = "";
    if (i % 2 === 1) {
      sem = "Autumn";
    } else {
      sem = "Spring";
    }
    sem += " ";
    sem += Math.floor(i / 2) + startYear;
    return sem;
  };

  return (
    <>
      <Container maxWidth="lg" sx={{ marginTop: "20px", flex: 1 }}>
        {data.length === 0 ? (
          <Typography>Loading...</Typography>
        ) : (
          <>
            <Box
              sx={{
                display: "flex",
                flexDirection: "row",
                gap: "20px",
                marginTop: "20px",
              }}
            >
              <Dialog
                open={configModal}
                onClose={() => {
                  if (!selectedDept || !selectedCourse) return;
                  setConfigModal(false);
                }}
                maxWidth="sm"
                fullWidth
                PaperProps={{
                  component: "form",
                  onSubmit: (event: React.FormEvent<HTMLFormElement>) => {
                    event.preventDefault();
                    if (!_selectedDept || !_selectedCourse) return;
                    if (_startYear < 2024) return;
                    setStartYear(_startYear);
                    setSelectedDept(_selectedDept);
                    setSelectedCourse(_selectedCourse);
                    setConfigModal(false);
                    localStorage.setItem(
                      "kgp-curriculum",
                      JSON.stringify({
                        year: _startYear,
                        course: _selectedCourse,
                      })
                    );
                  },
                }}
              >
                <DialogTitle>Choose Batch</DialogTitle>
                <DialogContent
                  sx={{
                    display: "flex",
                    flexDirection: "column",
                    gap: "20px",
                  }}
                >
                  <TextField
                    label="Admission Year"
                    type="number"
                    value={_startYear}
                    onChange={(e) => set_StartYear(+e.target.value)}
                    variant="standard"
                    error={_startYear < 2024}
                    helperText={
                      _startYear < 2024
                        ? "Admission year must be 2024 or later"
                        : ""
                    }
                  />
                  <FormControl fullWidth>
                    <InputLabel id="department">Department</InputLabel>
                    <Select
                      variant="standard"
                      labelId="department"
                      label="Department"
                      value={_selectedDept}
                      onChange={(e) => {
                        set_SelectedDept(e.target.value as number);
                        if (
                          data[(e.target.value as number) - 1].courses
                            .length === 1
                        )
                          set_SelectedCourse(
                            data[(e.target.value as number) - 1].courses[0].code
                          );
                        else set_SelectedCourse("");
                      }}
                      error={!_selectedDept}
                    >
                      {data.map((dept, i) => (
                        <MenuItem key={dept.name} value={i + 1}>
                          {dept.name}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>

                  <FormControl fullWidth>
                    <InputLabel id="course">Course</InputLabel>
                    <Select
                      labelId="course"
                      variant="standard"
                      label="Course"
                      value={_selectedCourse}
                      onChange={(e) =>
                        set_SelectedCourse(e.target.value as string)
                      }
                      error={!_selectedCourse}
                    >
                      {_selectedDept &&
                        data[_selectedDept - 1].courses.map((course) => (
                          <MenuItem key={course.code} value={course.code}>
                            {course.courseName}
                          </MenuItem>
                        ))}
                    </Select>
                  </FormControl>
                </DialogContent>
                <DialogActions>
                  <Button type="submit">Select</Button>
                </DialogActions>
              </Dialog>
            </Box>
            {course &&
              (() => {
                const numSems = course.curriculum.length;
                const semesterGPA = course.curriculum.map((semester, i) => {
                  return (
                    semester.subjects.reduce((acc, curr) => {
                      return (
                        acc +
                        curr.credits * grades[semWiseGrades[i][curr.subCode]]
                      );
                    }, 0) /
                    semester.subjects.reduce((acc, curr) => {
                      return acc + curr.credits;
                    }, 0)
                  );
                });
                const cumulativeGPA = new Array(numSems).fill(0).map((_, i) => {
                  // cgpa for sem 1 to i
                  return (
                    course.curriculum.slice(0, i + 1).reduce((acc, curr, j) => {
                      return (
                        acc +
                        curr.subjects.reduce((acc, curr) => {
                          return (
                            acc +
                            curr.credits *
                              grades[semWiseGrades[j][curr.subCode]]
                          );
                        }, 0)
                      );
                    }, 0) /
                    course.curriculum.slice(0, i + 1).reduce((acc, curr) => {
                      return (
                        acc +
                        curr.subjects.reduce((acc, curr) => {
                          return acc + curr.credits;
                        }, 0)
                      );
                    }, 0)
                  );
                });
                return (
                  <Box
                    sx={{
                      marginTop: "20px",
                    }}
                  >
                    <Typography variant="body2" sx={{ my: 2 }}>
                      Selected {startYear} Admission Batch of{" "}
                      {course.courseName}.{" "}
                      <a onClick={() => setConfigModal(true)}>Change</a>
                    </Typography>
                    <Typography variant="h4">Grades</Typography>
                    {course.curriculum.map((semester, i) => (
                      <Box key={semester.name} sx={{ marginTop: "20px" }}>
                        <Typography variant="h5">
                          {semester.name} ({getSemName(i + 1)})
                        </Typography>
                        <Box>
                          {/* table */}
                          <TableContainer>
                            <Table size="small">
                              <TableHead>
                                <TableRow>
                                  <TableCell>Subject Type</TableCell>
                                  <TableCell>Subject Code</TableCell>
                                  <TableCell>Subject Name</TableCell>
                                  <TableCell>L-T-P</TableCell>
                                  <TableCell>Credits</TableCell>
                                  <TableCell>Grade</TableCell>
                                </TableRow>
                              </TableHead>
                              <TableBody>
                                {semester.subjects.map((subject) => (
                                  <TableRow key={subject.subCode}>
                                    <TableCell>{subject.subType}</TableCell>
                                    <TableCell>{subject.subCode}</TableCell>
                                    <TableCell sx={{ fontWeight: "500" }}>
                                      {subject.subName}
                                    </TableCell>
                                    <TableCell>
                                      {subject.LTP.join("-")}
                                    </TableCell>
                                    <TableCell>{subject.credits}</TableCell>
                                    <TableCell>
                                      <FormControl
                                        variant="standard"
                                        size="small"
                                      >
                                        <NativeSelect
                                          // labelId="grade"
                                          disabled={subject.credits === 0}
                                          value={
                                            semWiseGrades[i][subject.subCode]
                                          }
                                          onChange={(e) => {
                                            const newGrades = [
                                              ...semWiseGrades,
                                            ];
                                            newGrades[i] = {
                                              ...newGrades[i],
                                              [subject.subCode]: e.target
                                                .value as Grade,
                                            };
                                            setSemWiseGrades(newGrades);
                                          }}
                                        >
                                          {(
                                            Object.keys(
                                              grades
                                            ) as (keyof typeof grades)[]
                                          ).map((grade) => (
                                            <option key={grade} value={grade}>
                                              {grade}
                                            </option>
                                          ))}
                                        </NativeSelect>
                                      </FormControl>
                                    </TableCell>
                                  </TableRow>
                                ))}
                                <TableRow>
                                  <TableCell
                                    sx={{
                                      textAlign: "right",
                                      fontWeight: "bold",
                                    }}
                                    colSpan={5}
                                  >
                                    Semester Grade Point Average (SGPA)
                                  </TableCell>
                                  <TableCell>
                                    {semesterGPA[i].toFixed(2)}
                                  </TableCell>
                                </TableRow>
                                <TableRow>
                                  <TableCell
                                    sx={{
                                      textAlign: "right",
                                      fontWeight: "bold",
                                    }}
                                    colSpan={5}
                                  >
                                    Cumulative Grade Point Average (CGPA)
                                  </TableCell>
                                  <TableCell>
                                    {cumulativeGPA[i].toFixed(2)}
                                  </TableCell>
                                </TableRow>
                              </TableBody>
                            </Table>
                          </TableContainer>
                        </Box>
                      </Box>
                    ))}
                  </Box>
                );
              })()}
          </>
        )}
      </Container>
    </>
  );
}

export default CGPAView;
