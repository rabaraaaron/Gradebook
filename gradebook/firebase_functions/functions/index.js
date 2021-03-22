const functions = require("firebase-functions");

exports.myTestFunction = functions.firestore
    .document("users/{userId}/terms/{termsId}")
    .onCreate((snap, context) => {
      const value = snap.data();
      const name = value.name;
      const year = value.year;
      console.log("New term added " + name.toString() + " " + year.toString() +
       snap.toString());
    });
