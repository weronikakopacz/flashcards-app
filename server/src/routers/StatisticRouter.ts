import express, { Request, Response } from "express";
import { StatisticData } from "../models/IStatisticData";
import verifyToken, { DecodedToken } from '../user/VerifyToken.ts';
import { saveStatistic } from "../statistic/StatisticRepository.ts";

const statisticRouter = express.Router();

statisticRouter.post('/add', async (req: Request, res: Response) => {
  try {
    const newStatistic: StatisticData = req.body;
    console.log('New statistic:', newStatistic);

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

    await saveStatistic(newStatistic, userUid);

    res.status(201).json({ message: 'Statistic added successfully' });
  } catch (error) {
    console.error('Error handling POST request:', error);
    res.status(500).send('Internal Server Error');
  }
});

export default statisticRouter;
