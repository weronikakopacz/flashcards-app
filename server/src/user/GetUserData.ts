import { DocumentSnapshot, collection, doc, getDoc, getFirestore } from "@firebase/firestore";
import { UserData } from "../models/IUserData";

const getUserData = async (userId: string): Promise<UserData | null> => {
  const firestore = getFirestore();
  const userDocRef = doc(collection(firestore, 'users'), userId);

  try {
    const userDocSnapshot: DocumentSnapshot = await getDoc(userDocRef);

    if (userDocSnapshot.exists()) {
      const userData: UserData = userDocSnapshot.data() as UserData;
      return userData;
    }

    return null;
  } catch (error) {
    console.error('Error getting user data:', error);
    throw error;
  }
};

export { getUserData }