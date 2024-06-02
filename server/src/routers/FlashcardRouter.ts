import express, { Request, Response } from "express";
import { Flashcard } from "../models/IFlashcard.ts";
import { addFlashcard, deleteFlashcard, editFlashcard, getFlashcards } from "../flashcard/FlashcardRepository.ts";
import verifyToken, { DecodedToken } from "../user/VerifyToken.ts";

const flashcardRouter = express.Router();

flashcardRouter.post('/add/:setId', async (req: Request, res: Response) => {
  try {
    const setId = req.params.setId;
    const newFlashcard: Flashcard = req.body;

    const accessToken = req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const decodedToken: DecodedToken | null = await verifyToken(accessToken);
    if (!decodedToken) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const userUid: string | undefined = decodedToken.userId;
    if (!userUid) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    await addFlashcard(setId, userUid, newFlashcard);

    res.status(201).send('Flashcard added successfully');
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'Set not found') {
        return res.status(404).send('Set not found');
      } else if (error.message === 'Unauthorized') {
        return res.status(403).send('Unauthorized');
      }
    }
    console.error('Error handling POST request:', error);
    res.status(500).send('Internal Server Error');
  }
});

flashcardRouter.delete('/delete/:flashcardId', async (req, res) => {
  try {
    const flashcardId = req.params.flashcardId;
    await deleteFlashcard(flashcardId);
    res.status(200).send('Flashcard deleted successfully');
  } catch (error) {
    console.error('Error handling DELETE request:', error);
    res.status(500).send('Internal Server Error');
  }
});

flashcardRouter.put('/edit/:flashcardId', async (req, res) => {
  try {
    const flashcardId = req.params.flashcardId;
    const updatedFields = req.body;

    if ('definition' in updatedFields && updatedFields.definition.trim() === '') {
      return res.status(400).send('Definition cannot be empty');
    }
    if ('term' in updatedFields && updatedFields.term.trim() === '') {
      return res.status(400).send('Term cannot be empty');
    }

    const accessToken = req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const decodedToken: DecodedToken | null = await verifyToken(accessToken);
    if (!decodedToken) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const userUid: string | undefined = decodedToken.userId;
    if (!userUid) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    await editFlashcard(flashcardId, userUid, updatedFields);

    res.status(204).send();
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'Flashcard not found') {
        return res.status(404).send('Flashcard not found');
      } else if (error.message === 'Unauthorized') {
        return res.status(403).send('Unauthorized');
      }
    }
    console.error('Error editing flashcard:', error);
    res.status(500).send('Internal Server Error');
  }
});

flashcardRouter.get('/getFlashcards/:setId', async (req, res) => {
  try {
    const setId = req.params.setId;
    const { flashcards: Flashcards } = await getFlashcards(setId);

    res.status(200).json({ flashcards: Flashcards });
  } catch (error) {
    console.error('Error getting flashcards by id:', error);
    res.status(500).send('Internal Server Error');
  }
});

export default flashcardRouter;