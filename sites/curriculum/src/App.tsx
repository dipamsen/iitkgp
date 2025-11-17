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
} from "@mui/material";
import ArticleIcon from "@mui/icons-material/Article";
import { useEffect, useState } from "react";
import { Department, Subject } from "./types";

function App() {
  const [data, setData] = useState<Department[]>([]);
  const [selectedDept, setSelectedDept] = useState<number | "">("");
  const [selectedCourse, setSelectedCourse] = useState<string>("");

  const subkey = (sub: Subject) => (sub.elective ? sub.subType : sub.subCode);

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
    if (subject.elective) return "#CAC2C9";
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
              <FormControl fullWidth>
                <InputLabel id="department">Department</InputLabel>
                <Select
                  labelId="department"
                  label="Department"
                  value={selectedDept}
                  onChange={(e) => {
                    setSelectedDept(e.target.value as number);
                    if (
                      data[(e.target.value as number) - 1].courses.length === 1
                    )
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
                          key={subkey(subject)}
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
                            {!subject.elective && subject.subCode}
                          </Typography>
                          <Typography
                            variant="body1"
                            sx={{
                              fontWeight: "500",
                              fontSize: "1.2rem",
                              overflow: "hidden",
                              whiteSpace: "nowrap",
                              textOverflow: "ellipsis",
                              flex: 1,
                            }}
                          >
                            {subject.elective ? subject.subType : subject.subName}
                          </Typography>
                          <Typography
                            variant="body1"
                            sx={{ textAlign: "right" }}
                          >
                            {!subject.elective && (
                              <>
                                {subject.LTP.join("-")}
                                <br />
                                {subject.credits} Credits
                              </>
                            )}
                          </Typography>
                          <Box>
                            <Link
                              href={
                                !subject.elective && subject.syllabus
                                  ? `https://dipamsen.github.io/iitkgp/` +
                                    subject.syllabus
                                  : undefined
                              }
                              target="_blank"
                              aria-disabled={subject.elective || !subject.syllabus}
                            >
                              <Tooltip
                                title={
                                  !subject.elective && subject.syllabus
                                    ? "Syllabus"
                                    : "Not Available"
                                }
                              >
                                <ArticleIcon
                                  htmlColor={
                                    !subject.elective && subject.syllabus ? "black" : "grey"
                                  }
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
      </Container>
    </>
  );
}

export default App;
