import express from 'express';
import { Set } from '../models/ISet.ts';
import { addSet, deleteSet, editSet, getPublicSets } from '../set/SetRepository.ts';

const setRouter = express.Router();

setRouter.post('/add', async (req, res) => {
  try {
    const newSet: Set = req.body;
    await addSet(newSet);

    res.status(201).send('Set added successfully');
  } catch (error) {
    console.error('Error handling POST request:', error);
    res.status(500).send('Internal Server Error');
  }
});

setRouter.delete('/delete/:setId', async (req, res) => {
  try {
    const setId = req.params.setId;
    await deleteSet(setId);
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

setRouter.put('/edit/:setId', async (req, res) => {
  try {
    const setId = req.params.setId;
    const updatedFields = req.body;

    if ('title' in updatedFields && updatedFields.title.trim() === '') {
      return res.status(400).send('Title cannot be empty');
    }

    await editSet(setId, updatedFields);
    res.status(204).send();
  } catch (error) {
    console.error('Error editing set:', error);
    res.status(500).send('Internal Server Error');
  }
});

export default setRouter;