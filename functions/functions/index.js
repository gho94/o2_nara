const functions = require('firebase-functions');
const admin = require('firebase-admin');

// 서비스 계정 인증 설정
const serviceAccount = require('./o2nara-151fb-firebase-adminsdk.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Firebase Functions v2 import 추가
const { onDocumentCreated, onDocumentUpdated, onDocumentDeleted, onDocumentWritten } = require("firebase-functions/v2/firestore");

exports.createCustomToken = functions.https.onCall(async ({data}, context) => {
  try {
    const uid = `naver:${data.id}`;
    const email = data.email;
    const name = data.name;

    let userRecord;
    try {
      userRecord = await admin.auth().getUser(uid);      
    } catch (error) {
      userRecord = await admin.auth().createUser({
        uid: uid,
        email: email,
        emailVerified: true,
        displayName: name,
        providerData: [{
            providerId: 'naver.com',
            uid: data.id,
            displayName: name,
            email: email
        }]
      });
    }

    const customToken = await admin.auth().createCustomToken(uid);
    
    return { customToken };
  } catch (error) {
    console.error('Error creating custom token:', error);
    throw new functions.https.HttpsError('internal', 'Error creating custom token');
  }
});
