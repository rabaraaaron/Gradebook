// const functions = require("firebase-functions");
// // const console = {log: debug};
// const admin = require("firebase-admin");
// // const db = admin.firestore();
// admin.initializeApp();


// // exports.helloWorld = functions.https.onRequest((request, response) => {
// //   // const uid = "mzZ40OB63chEAAvZ3EIqk8AF5FF2";
// //   // const termID = "cun6kNEzYR1EQ32Iu7QV";
// //   // const courseID = "e3WwgtNfjFxpLCCRQCTD";
// //   // fetchAllCategories(uid, termID, courseID);
// //   response.send("Hello from Firebase!");
// // });

// // exports.testFunction22 = functions.firestore
// //     .document("users/{userId}/terms/{termsId}/courses/{coursesId}/" +
// //     "{categories/{categoriesId}/assessments/{assessmentsId}")
// //     .onCreate((snap, context) => {
// //       console.log("New Assessment is added");
// //     });

// // exports.onCategoryDelete = functions.firestore
// //     .document("users/{userId}/terms/{termId}/courses/{courseId}" +
// //     "/categories/{categoryId}")
// //     .onDelete( async (change, context) => {
// //       console.log("Write on category collection");
// //       const par = context.params;
// //       // const courseID = par.courseId;
// //       // console.log(courseID);
// //       const catWeight = change.before.data().totalPoints;
// //       const coureseReff = admin.firestore().doc(
// //           "users/" + par.userId +
// //           "/terms/" + par.termId +
// //           "/courses/" + par.courseId);
// //       const courseSnap = await coureseReff.get();
// //       //fetchAllCategories(par.userId, par.termId, par.courseId);
// //       //fetchAllAssessments(par.userId, par.termId,
// // par.courseId, par.categoryId);

// //       console.log("courseSnap before: " + JSON.stringify(courseSnap));
// //       coureseReff.update({"gradePercent": parseFloat(tp)});

// //       const courseSnap2 = await coureseReff.get();
// //       console.log("courseSnap after: " + JSON.stringify(courseSnap2));
// //       console.log("total points:" + snap.data().totalPoints);
// //     });

// // exports.onCategoryCreate = functions.firestore
// //     .document("users/{userId}/terms/{termId}/courses/{courseId}" +
// //     "/categories/{categoryId}")
// //     .onCreate( async (change, context) => {
// //       console.log("Write on category collection");
// //       const par = context.params;
// //       // const courseID = par.courseId;
// //       // console.log(courseID);
// //       const catWeight = change.before.data().totalPoints;
// //       const coureseReff = admin.firestore().doc(
// //           "users/" + par.userId +
// //           "/terms/" + par.termId +
// //           "/courses/" + par.courseId);
// //       const courseSnap = await coureseReff.get();
// //       //fetchAllCategories(par.userId, par.termId, par.courseId);
// //       //fetchAllAssessments(par.userId,
// // par.termId, par.courseId, par.categoryId);

// //       console.log("courseSnap before: " + JSON.stringify(courseSnap));
// //       coureseReff.update({"gradePercent": parseFloat(tp)});

// //       const courseSnap2 = await coureseReff.get();
// //       console.log("courseSnap after: " + JSON.stringify(courseSnap2));
// //       console.log("total points:" + snap.data().totalPoints);
// //     });

// exports.onAssessmentCreate = functions.firestore
//     .document("users/{userId}/terms/{termId}/courses/{courseId}" +
//     "/categories/{categoryId}/assessments/{assessmentId}")
//     .onCreate( async (snap, context) => {
//       console.log("New Assessment is added");
//       const par = context.params;
//       const assessmentTP = await snap.data().totalPoints;
//       const assessmentYP = await snap.data().yourPoints;
//       console.log("Snapshot Data: " + snap.data());
//       const catReff = admin.firestore().doc(
//           "users/" + par.userId +
//           "/terms/" + par.termId +
//           "/courses/" + par.courseId +
//           "/categories/" + par.categoryId);
//       const catSnap = await catReff.get();
//       const catTotal = await catSnap.data().total;
//       const catEarend = await catSnap.data().earned;
//       // console.log("-++-------->>"+ catEarend);
//       fetchAllCategories(par.userId, par.termId, par.courseId);
//       // fetchAllAssessments(par.userId, par.termId,
//       //  par.courseId, par.categoryId);
//       const newTotal = parseFloat(catTotal) + parseFloat(assessmentTP);
//       const newEarend = parseFloat(catEarend) + parseFloat(assessmentYP);

//       catReff.update({
//         "total": newTotal,
//         "earned": newEarend,
//       });

//       const catSnap2 = await catReff.get();
//       console.log("new total points:" + catSnap2.data().total +
//         "new total earend: " + catSnap2.data().earend);
//     });

// exports.onAssessmentDelete = functions.firestore
//     .document("users/{userId}/terms/{termId}/courses/{courseId}" +
//     "/categories/{categoryId}/assessments/{assessmentId}")
//     .onDelete( async (snap, context) => {
//       // console.log(event);
//       const par = context.params;
//       const deletedDoc = snap.data();
//       console.log("-context ----- ->>" + JSON.stringify(context));
//       const catReff = admin.firestore().doc(
//           "users/" + par.userId +
//           "/terms/" + par.termId +
//           "/courses/" + par.courseId +
//           "/categories/" + par.categoryId);
//       const catSnap = await catReff.get();
//       const catTotal = await catSnap.data().total;
//       const catEarend = await catSnap.data().earned;
//       const newTotal = parseFloat(catTotal)-parseFloat(deletedDoc.totalPoints);
//       const newEarend = parseFloat(catEarend)-parseFloat(deletedDoc.yourPoints);

//       catReff.update({
//         "total": newTotal,
//         "earned": newEarend,
//       });
//     });

// // function calculateGrade(userID, termID, courseID){
// // }
// /**
//  * Testing.
//  *
//  * @param {String} uID uid
//  * @param {String} termId termId
//  * @param {String} courseId coursID
//  */
// async function fetchAllCategories(uID, termId, courseId) {
//   // console.log(`fetchall categories uID: ${uID} ` +
//   // `termID:${termId}courseID: ${courseId}`);
//   console.log("==============================================================");
//   const catReference = admin.firestore().collection(
//       "users/"+ uID +
//       "/terms/" + termId +
//       "/courses/" + courseId +
//       "/categories");
//   const catSnapshot = await catReference.get();
//   const results = [];
//   let category;
//   // console.log("---> catSnap test :" + JSON.stringify(catSnapshot));
//   catSnapshot.forEach(async (doc) => {
//     category = await doc.data();
//     results.push(category);
//   });
//   const cat = category.get();
//   console.log("category ----==>> " + JSON.stringify(cat));
//   const test = await Promise.all(results);
//   return console.log("Here =>" + JSON.stringify(test));
// }


// // /**
// //  * Testing.
// //  *
// //  * @param {String} uID uid
// //  * @param {String} termId termId
// //  * @param {String} courseId coursID
// //  * @param {catID} catID catID
// //  */
// // async function fetchAllAssessments(uID, termId, courseId, catID) {
// //   const path = "users/"+ uID +
// //   "/terms/" + termId +
// //   "/courses/" + courseId +
// //   "/categories/" + catID +
// //   "/assessments";
// //   const assessmentsRef = admin.firestore().collection(path);
// //   const assessmentsSnap = await assessmentsRef.get();
// //   const tpList = [];
// //   const ypList = [];

// //   assessmentsSnap.forEach((doc, index) => {
// //     const assessment = doc.data();
// //     // console.log("====>>> row [" +
// //     index + "]" + JSON.stringify(assessment));
// //     ypList.push(assessment.yourPoints);
// //     tpList.push(assessment.totalPoints);
// //   });
// //   const tpOutput = await Promise.all(tpList);
// //   const ypOutput = await Promise.all(ypList);
// //   console.log("TotalPoints Here =>" + tpOutput);
// //   return console.log("YourPoints Here =>" + ypOutput);
// // }

// // exports.testFunction2 = functions.firestore
// // .document("users/{usersId}/terms/{termsId}/courses/{coursesId}"+
// // "/categories/{categoriesId}/assessments/{assessmentsId}")
// // .onCreate((snap, context) => {
// //   console.log("New Assessment is added");
// //   console.log(JSON.stringify(snap));
// // });

// /**
//  * Triggered by a change to a Firestore document.
//  *
//  * @param {!Object} event Event payload.
//  * @param {!Object} context Metadata for the event.
//  */
// // exports.helloFirestore = (event, context) => {
// //   const resource = context.resource;
// //   // log out the resource string that triggered the function
// //   console.log('Function triggered by change to: ' +  resource);
// //   // now log the full event object
// //   console.log(JSON.stringify(event));
// // }
