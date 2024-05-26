import express from 'express';
import cors from 'cors';
import flashcardRouter from './routes/FlashcardRouter.ts';
import setRouter from './routes/SetRouter.ts';

const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json()); // Parsowanie JSON
app.use(cors()); // Komunikacja między serwerami

app.use('/api/flashcards', flashcardRouter);
app.use('/api/sets', setRouter);


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});