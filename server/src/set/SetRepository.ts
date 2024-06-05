import { db } from "../database/FirebaseConfig.js";
import { addDoc, collection, deleteDoc, doc, getDoc, getDocs, orderBy, query, updateDoc, where } from 'firebase/firestore';
import { Set } from '../models/ISet.js'
import { deleteFlashcard } from "../flashcard/FlashcardRepository.js";

async function getPublicSets(): Promise<{ publicsets: Set[] }> {
    try {
      const setsCollection = collection(db, 'sets');
  
      let q = query(
        setsCollection,
        where('isPublic', '==', true),
        orderBy('title')
      );
  
      const querySnapshot = await getDocs(q);
      
      const publicsets: Set[] = querySnapshot.docs.map((doc) => {
          const data = doc.data() as Set;
          return {
            id: doc.id,
            ...data
          };
      });
      
      return { publicsets };
    } catch (error) {
      console.error('Error getting sets from the database:', error);
      throw error;
    }
  }

async function getUserSets(userUid: string): Promise<{ userSets: Set[] }> {
  try {
    const setsCollection = collection(db, 'sets');

    let q = query(
      setsCollection,
      where('creatorUserId', '==', userUid),
      orderBy('title')
    );

    const querySnapshot = await getDocs(q);

    const userSets: Set[] = querySnapshot.docs.map((doc) => {
      const data = doc.data() as Set;
      return {
        id: doc.id,
        ...data
      };
    });

    return { userSets };
  } catch (error) {
    console.error('Error getting user sets from the database:', error);
    throw error;
  }
}

async function addSet(userId: string, newSet: Omit<Set, 'id'>) {
  try {
    if (!newSet.title) {
      throw new Error('Title is required field');
    }

    const setToAdd: Set = {
      ...newSet
    };

    const setsCollection = collection(db, 'sets');
    const docRef = await addDoc(setsCollection, setToAdd);
    const setSnapshot = await getDoc(docRef);
    
    if (setSnapshot.data()?.creatorUserId === userId) {
      setToAdd.id = docRef.id;
    } else {
      throw new Error('User is not the creator of the product');
    }
  } catch (error) {
    console.error('Error adding set to the database:', error);
    throw error;
  }
}

async function deleteSet(userId: string, setId: string) {
  try {
    const flashcardsCollection = collection(db, 'flashcards');
    const flashcardsQuery = query(flashcardsCollection, where('setId', '==', setId));
    const querySnapshot = await getDocs(flashcardsQuery);

    const deleteFlashcardsPromises = querySnapshot.docs.map(async (flashcardDoc) => {
      await deleteFlashcard(flashcardDoc.id, userId);
    });
    await Promise.all(deleteFlashcardsPromises);

    const setsCollection = collection(db, 'sets');
    const setRef = doc(setsCollection, setId);
    const setSnapshot = await getDoc(setRef);

    if (setSnapshot.data()?.creatorUserId === userId) {
      await deleteDoc(setRef);
    } else {
      throw new Error('User is not the creator of the product');
    }
  } catch (error) {
    console.error('Error deleting set and associated flashcards from the database:', error);
    throw error;
  }
}

async function editSet(userId: string, setId: string, updatedFields: Pick<Set, 'title'>) {
  try {
    const setsCollection = collection(db, 'sets');
    const setRef = doc(setsCollection, setId);

    const setSnapshot = await getDoc(setRef);

    if (setSnapshot.exists() && setSnapshot.data()?.creatorUserId === userId) {
        await updateDoc(setRef, updatedFields);
    } else {
        throw new Error('Set not found or user is not the creator of the set');
    }
  } catch (error) {
    console.error('Error editing set in the database:', error);
    throw error;
  }
}

export { getPublicSets, getUserSets, addSet, deleteSet, editSet };