import { getAuth, createUserWithEmailAndPassword } from 'firebase/auth';
import { getFirestore, setDoc, doc, collection } from 'firebase/firestore';
import { UserData } from '../models/IUserData';

export async function createUser(email: string, password: string, userData: Omit<UserData, 'uid'>): Promise<void> {
  try {
    const auth = getAuth();
    const firestore = getFirestore();

    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    const userDocRef = doc(collection(firestore, 'users'), user.uid);
    const completeUserData: UserData = { ...userData, uid: user.uid };

    await setDoc(userDocRef, completeUserData);
  } catch (error) {
    throw error;
  }
}