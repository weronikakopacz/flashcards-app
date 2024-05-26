import { db } from '../database/FirebaseConfig.js';
import { addDoc, collection, deleteDoc, doc, getDoc, getDocs, orderBy, query, updateDoc, where } from 'firebase/firestore';
import { Flashcard } from '../models/IFlashcard.js';

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

async function addFlashcard(productRef: string, newFlashcard: Omit<Flashcard, 'id' | 'setId'>): Promise<void> {
  try {
    if (!newFlashcard.term || !newFlashcard.definition) {
      throw new Error('Term and definition are a required fields');
    }

    const flashcardToAdd: Flashcard = {
      ...newFlashcard,
      setId: productRef
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

async function editFlashcard(flashcardId: string, updatedFields: Pick<Flashcard, 'term' | 'definition'>) {
  try {
    const flashcardsCollection = collection(db, 'flashcards');
    const flashcardRef = doc(flashcardsCollection, flashcardId);

    const flashcardSnapshot = await getDoc(flashcardRef);

    if (flashcardSnapshot.exists()) {
        await updateDoc(flashcardRef, updatedFields);
    } else {
        throw new Error('Flashcard not found');
    }
  } catch (error) {
    console.error('Error editing flashcard in the database:', error);
    throw error;
  }
}

export { getFlashcards, addFlashcard, deleteFlashcard, editFlashcard };