import {
  Box,
  Container,
  FormControl,
  InputLabel,
  Link,
  MenuItem,
  Select,
  Tooltip,
  Typography,
  useColorScheme,
} from "@mui/material";
import ArticleIcon from "@mui/icons-material/Article";
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

function App() {
  const [data, setData] = useState<Department[]>([]);
  const [selectedDept, setSelectedDept] = useState<number | "">("");
  const [selectedCourse, setSelectedCourse] = useState<string>("");

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

  const colors = (subject: Subject) => {
    if (subject.credits <= 1) return "#CAC2C9";
    if (subject.subType.toLowerCase().includes("core")) {
      if (subject.LTP[0] == 0 && subject.LTP[1] == 0) return "#5BC0BE";
      if (subject.credits === 2) return "#EEDEBF";
      if (subject.credits === 3) return "#DDCA7D";
      if (subject.credits === 4) return "#FE5F55";
    }
    return "green";
  };

  const course = selectedDept
    ? data[selectedDept - 1]?.courses.find((c) => c.code === selectedCourse)
    : undefined;

  return (
    <Container maxWidth="lg" sx={{ marginTop: "20px" }}>
      <Typography variant="h3">IIT KGP - Curriculum Explorer</Typography>

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
            <FormControl fullWidth>
              <InputLabel id="department">Department</InputLabel>
              <Select
                labelId="department"
                label="Department"
                value={selectedDept}
                onChange={(e) => {
                  setSelectedDept(e.target.value as number);
                  if (data[(e.target.value as number) - 1].courses.length === 1)
                    setSelectedCourse(
                      data[(e.target.value as number) - 1].courses[0].code
                    );
                  else setSelectedCourse("");
                }}
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
                label="Course"
                value={selectedCourse}
                onChange={(e) => setSelectedCourse(e.target.value as string)}
              >
                {selectedDept &&
                  data[selectedDept - 1].courses.map((course) => (
                    <MenuItem key={course.code} value={course.code}>
                      {course.courseName}
                    </MenuItem>
                  ))}
              </Select>
            </FormControl>
          </Box>
          {course && (
            <Box
              sx={{
                marginTop: "20px",
              }}
            >
              <Typography variant="h4">
                [{course.code}] {course.courseName}
              </Typography>
              {course.curriculum.map((semester) => (
                <Box key={semester.name} sx={{ marginTop: "20px" }}>
                  <Typography variant="h5">{semester.name}</Typography>
                  <Box
                    sx={{
                      display: "flex",
                      flexDirection: "column",
                      gap: "10px",
                      marginTop: "10px",
                    }}
                  >
                    {semester.subjects.map((subject) => (
                      <Box
                        key={subject.subCode}
                        sx={{
                          display: "flex",
                          alignItems: "center",
                          borderRadius: "5px",
                          backgroundColor: colors(subject),
                          // color: "#fff",
                          paddingX: "10px",
                          paddingY: "5px",
                          gap: "10px",
                          color: "#000",
                        }}
                      >
                        <Typography
                          variant="body1"
                          sx={{
                            fontWeight: "800",
                            overflow: "hidden",
                            whiteSpace: "nowrap",
                            textOverflow: "ellipsis",
                            fontSize: "0.8rem",
                            width: "65px",
                            // alignSelf: "flex-start",
                          }}
                        >
                          {subject.subCode}
                        </Typography>
                        <Typography
                          variant="body1"
                          sx={{
                            fontWeight: "500",
                            fontSize: "1.5rem",
                            overflow: "hidden",
                            whiteSpace: "nowrap",
                            textOverflow: "ellipsis",
                            flex: 1,
                          }}
                        >
                          {subject.subName}
                        </Typography>
                        <Typography variant="body1" sx={{ textAlign: "right" }}>
                          {subject.LTP.join("-")}
                          <br />
                          {subject.credits} Credits
                        </Typography>
                        <Box>
                          <Link
                            href={
                              subject.syllabus
                                ? `https://dipamsen.github.io/iitkgp/` +
                                  subject.syllabus
                                : undefined
                            }
                            target="_blank"
                            aria-disabled={!subject.syllabus}
                          >
                            <Tooltip
                              title={
                                subject.syllabus ? "Syllabus" : "Not Available"
                              }
                            >
                              <ArticleIcon
                                htmlColor={subject.syllabus ? "black" : "grey"}
                              />
                            </Tooltip>
                          </Link>
                        </Box>
                      </Box>
                    ))}
                  </Box>
                </Box>
              ))}
            </Box>
          )}
        </>
      )}
      <Box component="footer" sx={{ mt: "auto", py: 2 }}>
        <Container maxWidth="sm" sx={{ textAlign: "center" }}>
          <Typography variant="body2" color="textSecondary">
            created by
            <Link
              href="https://github.com/dipamsen"
              target="_blank"
              rel="noreferrer"
              sx={{ ml: 1 }}
            >
              dipamsen
            </Link>
          </Typography>
        </Container>
      </Box>
    </Container>
  );
}

export default App;
