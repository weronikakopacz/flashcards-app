import express from 'express';
import cors from 'cors';
import flashcardRouter from './routers/FlashcardRouter.ts';
import setRouter from './routers/SetRouter.ts';
import userRouter from './routers/UserRouter.ts';

const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json()); // Parsowanie JSON
app.use(cors()); // Komunikacja między serwerami

app.use('/api/flashcards', flashcardRouter);
app.use('/api/sets', setRouter);
app.use('/api/user', userRouter);


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});