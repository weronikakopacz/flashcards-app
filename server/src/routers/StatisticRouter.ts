import express, { Request, Response } from "express";
import { StatisticData } from "../models/IStatisticData";
import verifyToken, { DecodedToken } from '../user/VerifyToken.ts';
import { getUserStatistics, saveStatistic } from "../statistic/StatisticRepository.ts";

const statisticRouter = express.Router();

statisticRouter.post('/add', async (req: Request, res: Response) => {
  try {
    const newStatistic: StatisticData = req.body;

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

// statisticRouter.get('/:setId', async (req: Request, res: Response) => {
//   try {
//     const setId = req.params.setId;

//     const accessToken = req.header('Authorization')?.split(' ')[1];
//     if (!accessToken) {
//       return res.status(401).json({ error: 'Unauthorized' });
//     }

//     const decodedToken: DecodedToken | null = await verifyToken(accessToken);
//     if (!decodedToken) {
//       return res.status(401).json({ error: 'Unauthorized' });
//     }

//     const userId: string | undefined = decodedToken.userId;
//     if (!userId) {
//       return res.status(401).json({ error: 'Unauthorized' });
//     }

//     const setStats = await getSetStatistics(userId, setId);

//     if (setStats) {
//       res.status(200).json(setStats);
//     } else {
//       res.status(404).json({ message: 'Set statistics not found' });
//     }
//   } catch (error) {
//     console.error('Error fetching set statistics:', error);
//     res.status(500).json({ error: 'Failed to fetch set statistics' });
//   }
// });

statisticRouter.get('/user', async (req: Request, res: Response) => {
  try {
    const accessToken = req.header('Authorization')?.split(' ')[1];
    if (!accessToken) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const decodedToken: DecodedToken | null = await verifyToken(accessToken);
    if (!decodedToken) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const userId: string | undefined = decodedToken.userId;
    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const userStats = await getUserStatistics(userId);

    if (userStats) {
      res.status(200).json(userStats);
    } else {
      res.status(404).json({ message: 'User statistics not found' });
    }
  } catch (error) {
    console.error('Error fetching user statistics:', error);
    res.status(500).json({ error: 'Failed to fetch user statistics' });
  }
});

export default statisticRouter;
