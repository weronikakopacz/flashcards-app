import express from 'express';
import { Set } from '../models/ISet.ts';
import { addSet, deleteSet, editSet, getPublicSets, getSet, getUserSets } from '../set/SetRepository.ts';
import verifyToken, { DecodedToken } from '../user/VerifyToken.ts';

const setRouter = express.Router();
const PAGE_NUMBER = 10;

setRouter.post('/add', async (req, res) => {
  try {
    const newSet: Set = req.body;
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

    const setId = await addSet(userUid, newSet);

    res.status(201).json({ id: setId });
  } catch (error) {
    console.error('Error handling POST request:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.delete('/delete/:setId', async (req, res) => {
  try {
    const setId = req.params.setId;
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
    await deleteSet(userUid, setId);
    res.status(200).send('Product deleted successfully');
  } catch (error) {
    console.error('Error handling DELETE request:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.get('/getPublicSets', async (req, res) => {
  try {
    const currentPage = parseInt(req.query.currentPage as string, 10) || 1;
    const searchQuery = req.query.searchQuery as string | undefined;

    const publicSets = await getPublicSets(PAGE_NUMBER, searchQuery,);

    const startIdx = (currentPage - 1) * PAGE_NUMBER;
    const endIdx = startIdx + PAGE_NUMBER;
    const limitedpublicSets = publicSets.publicsets.slice(startIdx, endIdx);

    const totalPages = publicSets.totalPages;
    res.status(200).json({ sets: limitedpublicSets, totalPages });
  } catch (error) {
    console.error('Error getting public sets:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.get('/getUserSets', async (req, res) => {
  try {
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

    const currentPage = parseInt(req.query.currentPage as string, 10) || 1;
    const searchQuery = req.query.searchQuery as string | undefined;
    
    const userSets = await getUserSets(userUid, PAGE_NUMBER, searchQuery);

    const startIdx = (currentPage - 1) * PAGE_NUMBER;
    const endIdx = startIdx + PAGE_NUMBER;
    const limiteduserSets = userSets.userSets.slice(startIdx, endIdx);

    const totalPages = userSets.totalPages;

    res.status(200).json({ sets: limiteduserSets, totalPages });
  } catch (error) {
    console.error('Error getting user sets:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.get('/getSet/:setId', async (req, res) => {
  try {
    const setId = req.params.setId;
    const set = await getSet(setId);
    res.status(200).json({ set });
  } catch (error) {
    console.error('Error getting set:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.put('/edit/:setId', async (req, res) => {
  try {
    const setId = req.params.setId;
    const updatedFields = req.body;

    if ('title' in updatedFields && updatedFields.title.trim() === '') {
      return res.status(400).send('Title cannot be empty');
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

    await editSet(userUid, setId, updatedFields);
    res.status(204).send();
  } catch (error) {
    console.error('Error editing set:', error);
    res.status(500).send('Internal Server Error');
  }
});

export default setRouter;