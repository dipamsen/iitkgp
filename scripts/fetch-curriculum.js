import fs from "fs";
import * as cheerio from "cheerio";

const baseURL = "https://erp.iitkgp.ac.in/ERPWebServices/curricula/";

const courseURLs = {
  v1: "/specialisationList.jsp?stuType=UG",
  v2: "/specialisationList_new_curr.jsp?stuType=UG",
  v3: "/specialisationList_new_currver2.jsp?stuType=UG",
};

const getVersion = (year) => {
  if (year <= 2019) {
    return "v1";
  } else if (year <= 2023) {
    return "v2";
  } else {
    return "v3";
  }
};

async function getCourses() {
  const version = getVersion(2024);
  const courseURL = courseURLs[version];
  const html = await fetch(baseURL + courseURL).then((res) => res.text());

  const $ = cheerio.load(html);
  const table = $("table");
  const departments = [];
  let currDep = {};
  table.find("tr").each((i, tr) => {
    if (tr.children.length == 1) {
      currDep = {
        name: $(tr).text().trim(),
        courses: [],
      };
      departments.push(currDep);
    } else {
      const course = $(tr).find("a").first().text().trim();
      const onClick = $(tr).find("a").first().attr("onclick"); // of the form "getDet('stuType','splCode','currType')"
      const [, stuType,, splCode,, currType] = onClick.split("'");
      currDep.courses.push({
        courseName: course,
        code: splCode,
        postBody: new URLSearchParams({
          stuType,
          splCode,
          curr_type: currType,
        }),
      });
    }
  });

  return departments;
}

async function getCurriculum(course) {
  const url = `https://erp.iitkgp.ac.in/ERPWebServices/curricula/CurriculaSubjectsList.jsp`
  const html = await fetch(url, {
    method: "POST",
    body: course.postBody,
  }).then((res) => res.text());
  const $ = cheerio.load(html);
  const table = $("table");
  const semesters = [];
  let currSem = {};
  let ignoreNext = false;
  table.find("tr").each((i, tr) => {
    if (tr.children.filter((x) => x.type == "tag").length == 1) {
      currSem = {
        name: $(tr).text().trim(),
        subjects: [],
      };
      semesters.push(currSem);
      ignoreNext = true;
    } else {
      if (ignoreNext) {
        ignoreNext = false;
        return;
      }
      // tr has 6 tds, <blank>, subType, subCode, subName, LTP, credits
      // optionally, the subCode td can have an anchor tag with onclick property which opens the syllabus
      const subType = $(tr).find("td").eq(1).text().trim();

      if (subType.toLowerCase().includes("core")) {
        const subCode = $(tr).find("td").eq(2).text().trim();
        const subName = $(tr).find("td").eq(3).text().trim();
        const LTP = $(tr).find("td").eq(4).text().trim();
        const credits = $(tr).find("td").eq(5).text().trim();
        if ($(tr).find("td").eq(2).find("a").length == 0) {
          currSem.subjects.push({
            subType,
            elective: false,
            subCode,
            subName,
            LTP: LTP.split("-").map((x) => +x),
            credits: +credits,
          });
          return;
        }
        const callFile = (...args) => args;
        const [pageno, fileFullPath, docId] = eval(
          $(tr).find("td").eq(2).find("a").attr("onclick")
        );
        const postBody = new URLSearchParams({
          pageno,
          rollno: "",
          fileFullPath,
          docId,
        });

        currSem.subjects.push({
          subType,
          elective: false,
          subCode,
          subName,
          LTP: LTP.split("-").map((x) => +x),
          credits: +credits,
          syllabus: {
            url: baseURL + "commonFileDownloader.jsp",
            postBody,
          },
        });
      } else {
        // elective course
        // all other fields are empty (choice of student).
        // optionally, in case of depth elective, the subType td can have an anchor to a list of choices
        currSem.subjects.push({
          subType,
          elective: true,
        });
      }
    }
  });

  course.curriculum = semesters;
  delete course.postBody;

  return semesters;
}

const syllabiCache = {};

async function downloadSyllabus(sub) {
  if (syllabiCache[sub.subCode]) {
    if (
      syllabiCache[sub.subCode].postBody.toString() ==
      sub.syllabus.postBody.toString()
    ) {
      sub.syllabus = `syllabus/${sub.subCode}.pdf`;
      return;
    }
    console.log("Found different syllabus for", sub.subCode);
    console.log(syllabiCache[sub.subCode].postBody.toString());
    console.log(sub.syllabus.postBody.toString());
    return;
  }
  if (fs.existsSync(`./syllabus/${sub.subCode}.pdf`)) {
    sub.syllabus = `syllabus/${sub.subCode}.pdf`;
    return;
  }
  const res = await fetch(sub.syllabus.url, {
    method: "POST",
    body: sub.syllabus.postBody,
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "*/*",
    },
  });
  if (res.ok && res.headers.get("content-type").includes("pdf")) {
    const buffer = await res.arrayBuffer();
    fs.writeFileSync(
      `./syllabus/${sub.subCode}.pdf`,
      Buffer.from(buffer),
      "binary"
    );
    syllabiCache[sub.subCode] = sub.syllabus;
    sub.syllabus = `syllabus/${sub.subCode}.pdf`;
    delete sub.syllabus.postBody;
  } else {
    console.log(`${sub.subCode} not available`);
    delete sub.syllabus;
  }
}

async function main() {
  if (!fs.existsSync("./syllabus")) {
    fs.mkdirSync("./syllabus");
  }

  const courses = await getCourses();
  for (const dep of courses) {
    for (const course of dep.courses) {
      await getCurriculum(course);
      for (const sem of course.curriculum) {
        for (const sub of sem.subjects) {
          if (sub.syllabus) {
            await downloadSyllabus(sub);
          }
        }
      }
    }
  }

  fs.writeFileSync("./curriculum.json", JSON.stringify(courses, null, 2));
}

main();
