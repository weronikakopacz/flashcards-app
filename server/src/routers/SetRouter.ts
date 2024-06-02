import express from 'express';
import { Set } from '../models/ISet.ts';
import { addSet, deleteSet, editSet, getPublicSets, getUserSets } from '../set/SetRepository.ts';
import verifyToken, { DecodedToken } from '../user/VerifyToken.ts';

const setRouter = express.Router();

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
    await addSet(userUid, newSet);

    res.status(201).send('Set added successfully');
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
    const publicSets = await getPublicSets();
    res.status(200).json({ sets: publicSets });
  } catch (error) {
    console.error('Error getting public sets:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.get('/getUserSets/:userUid', async (req, res) => {
  try {
    const userUid = req.params.userUid;
    const userSets = await getUserSets(userUid);
    res.status(200).json({ sets: userSets });
  } catch (error) {
    console.error('Error getting user sets:', error);
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