
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


var notificationKey = 'epRuMDLnF5Q:APA91bHtKtfnPh35vDkhSqzof-RNkxk1k173fzG3usqhizF5JWZvkEm_uMcVGHZi21yc3EeZ4W_pUcb30efOKf4vc7faYvxfO2m4_AA1PbXFNNxSrBmfz9bRehJOcb42rC4832LfgbCJ';



// See the "Defining the message payload" section below for details
// on how to define a message payload.
var payload = {
  data: {
    score: '850',
    time: '2:45'
  }
};


//var serviceAccount = require('path/to/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://notification-12682.firebaseio.com'
});

var registrationToken = 'epRuMDLnF5Q:APA91bHtKtfnPh35vDkhSqzof-RNkxk1k173fzG3usqhizF5JWZvkEm_uMcVGHZi21yc3EeZ4W_pUcb30efOKf4vc7faYvxfO2m4_AA1PbXFNNxSrBmfz9bRehJOcb42rC4832LfgbCJ';
var message = {
  data: {
    score: '850',
    time: '2:45'
  },
  token: registrationToken
};

admin.messaging().send(message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
    return 0;
  })
  .catch((error) => {
    console.log('Error sending message:', error);
    throw new Error("Profile doesn't exist")

  });

// Send a message to the device group corresponding to the provided
// notification key.
// admin.messaging().sendToDeviceGroup(notificationKey, payload)
//   .then(function(response) {
//     // See the MessagingDeviceGroupResponse reference documentation for
//     // the contents of response.
//     console.log('Successfully sent message:', response);
//     return 0 
//   })
//   .catch(function(error) {
//     console.log('Error sending message:', error);
//     throw new Error("Profile doesn't exist")

//   });



