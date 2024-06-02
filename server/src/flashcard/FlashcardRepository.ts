import { db } from '../database/FirebaseConfig.js';
import { addDoc, collection, deleteDoc, doc, getDoc, getDocs, orderBy, query, updateDoc, where } from 'firebase/firestore';
import { Flashcard } from '../models/IFlashcard.js';

async function checkUserPermission(userId: string, setId: string): Promise<void> {
  const setsCollection = collection(db, 'sets');
  const setRef = doc(setsCollection, setId);
  const setSnapshot = await getDoc(setRef);

  if (!setSnapshot.exists() || setSnapshot.data()?.creatorUserId !== userId) {
    throw new Error('Unauthorized');
  }
}

async function getFlashcards(flashcardRef: string): Promise<{ flashcards: Flashcard[] }> {
  try {
    const flashcardsCollection = collection(db, 'flashcards');

    let q = query(
      flashcardsCollection,
      where('setId', '==', flashcardRef),
      orderBy('term')
    );

    const querySnapshot = await getDocs(q);
    
    const flashcards: Flashcard[] = querySnapshot.docs.map((doc) => {
        const data = doc.data() as Flashcard;
        return {
          id: doc.id,
          ...data
        };
    });
    
    return { flashcards };
  } catch (error) {
    console.error('Error getting flashcards from the database:', error);
    throw error;
  }
}

async function addFlashcard(flashcardRef: string, userId: string, newFlashcard: Omit<Flashcard, 'id' | 'setId'>): Promise<void> {
  try {
    if (!newFlashcard.term || !newFlashcard.definition) {
      throw new Error('Term and definition are required fields');
    }

    const setsCollection = collection(db, 'sets');
    const setRef = doc(setsCollection, flashcardRef);
    const setSnapshot = await getDoc(setRef);

    if (!setSnapshot.exists()) {
      throw new Error('Set not found');
    }

    const setData = setSnapshot.data();
    if (setData?.creatorUserId !== userId) {
      throw new Error('Unauthorized');
    }
    

    const flashcardToAdd: Flashcard = {
      ...newFlashcard,
      setId: flashcardRef
    };

    const flashcardsCollection = collection(db, 'flashcards');
    const docRef = await addDoc(flashcardsCollection, flashcardToAdd);

    flashcardToAdd.id = docRef.id;
  } catch (error) {
    console.error('Error adding flashcard to the database:', error);
    throw error;
  }
}

async function deleteFlashcard(flashcardId: string) {
    try {
      const flashcardsCollection = collection(db, 'flashcards');
      const flashcardRef = doc(flashcardsCollection, flashcardId);
  
      await deleteDoc(flashcardRef);
      console.log('Flashcard successfully deleted from the database');
    } catch (error) {
      console.error('Error deleting flashcard from the database:', error);
      throw error;
    }
}

async function editFlashcard(flashcardId: string, userId: string, updatedFields: Pick<Flashcard, 'term' | 'definition'>) {
  try {
    const flashcardsCollection = collection(db, 'flashcards');
    const flashcardRef = doc(flashcardsCollection, flashcardId);
    const flashcardSnapshot = await getDoc(flashcardRef);

    if (!flashcardSnapshot.exists()) {
      throw new Error('Flashcard not found');
    }

    const flashcardData = flashcardSnapshot.data();
    const setId = flashcardData?.setId;

    await checkUserPermission(userId, setId);

    await updateDoc(flashcardRef, updatedFields);
  } catch (error) {
    console.error('Error editing flashcard in the database:', error);
    throw error;
  }
}

export { getFlashcards, addFlashcard, deleteFlashcard, editFlashcard };