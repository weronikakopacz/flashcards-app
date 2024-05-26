import admin from 'firebase-admin';
import { initializeApp, FirebaseApp } from 'firebase/app';
import { getFirestore, Firestore } from 'firebase/firestore';
import serviceAccount from './serviceAccountKey.json' assert { type: "json" };

const firebaseConfig = {
    apiKey: "AIzaSyCkfCyjYN4Z1o2JR93sfswyvAeBhucXk30",
    authDomain: "flashcards-app-32cb2.firebaseapp.com",
    projectId: "flashcards-app-32cb2",
    storageBucket: "flashcards-app-32cb2.appspot.com",
    messagingSenderId: "722636708040",
    appId: "1:722636708040:web:29a367447e9aeec5cb6dfd",
    measurementId: "G-6CKE29C65R"
  };

const firebaseApp: FirebaseApp = initializeApp(firebaseConfig);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount as admin.ServiceAccount)
});

const db: Firestore = getFirestore(firebaseApp);

export { db };