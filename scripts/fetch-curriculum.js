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
      const url = $(tr).find("a").first().attr("href");
      currDep.courses.push({
        courseName: course,
        url: url,
        code: new URL(baseURL + url).searchParams.get("splCode"),
      });
    }
  });

  return departments;
}

async function getCurriculum(course) {
  const url = baseURL + course.url;
  const html = await fetch(url).then((res) => res.text());
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
      const subCode = $(tr).find("td").eq(2).text().trim();
      const subName = $(tr).find("td").eq(3).text().trim();
      const LTP = $(tr).find("td").eq(4).text().trim();
      const credits = $(tr).find("td").eq(5).text().trim();
      if ($(tr).find("td").eq(2).find("a").length == 0) {
        currSem.subjects.push({
          subType,
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
        subCode,
        subName,
        LTP: LTP.split("-").map((x) => +x),
        credits: +credits,
        syllabus: {
          url: baseURL + "commonFileDownloader.jsp",
          postBody,
        },
      });
    }
  });

  course.curriculum = semesters;
  delete course.url;

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
  } else {
    console.log(`${sub.subCode} not available`);
    delete sub.syllabus;
  }
}

// getCourses().then((res) => {
//   res.forEach((dep) => {
//     dep.courses.forEach((course) => {
//       getCurriculum(course).then((res) => {
//         res.forEach((sem) => {
//           sem.subjects.forEach((sub) => {
//             if (sub.syllabus) {
//               downloadSyllabus(sub);
//             }
//           });
//         });
//       });
//     });
//   });
// });

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
