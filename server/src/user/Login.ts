import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();
const publicKey = process.env.JWT_PUBLIC_KEY || 'fallbackPublicKey';

export async function loginUser(email: string, password: string): Promise<string> {
  try {
    const auth = getAuth();
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    const accessToken = jwt.sign({ userId: user.uid }, publicKey);

    return accessToken;
  } catch (error) {
    throw error;
  }
}