import { StatisticData } from "../models/IStatisticData";
import { db } from "../database/FirebaseConfig.ts";
import { doc, getDoc, updateDoc, setDoc } from "firebase/firestore";
import { UserStats } from "../models/IUserStat";
import { SetStats } from "../models/ISetStats";

async function saveStatistic(data: StatisticData, uid: string) {
  try {
    const { setId, correct, incorrect, repeatUnknown } = data;
    const repeatUnknownValue = repeatUnknown;

    await updateGeneralStatistics(uid, correct, incorrect, repeatUnknownValue);
    await updateSetStatistics(uid, setId, correct, incorrect, repeatUnknownValue);
  } catch (error) {
    console.error('Error saving statistic:', error);
    throw new Error('Failed to save statistic.');
  }
}

async function updateGeneralStatistics(uid: string, correct: number, incorrect: number, repeatUnknown: number) {
  try {
    const userRef = doc(db, 'userStats', uid);
    const userDoc = await getDoc(userRef);

    if (userDoc.exists()) {
      const userData = userDoc.data() as { generalStatistics?: UserStats };

      let generalStatistics: UserStats = userData.generalStatistics || {
        totalSetsCompleted: 0,
        averageAccuracy: 0,
        averageRepeatUnknown: 0,
      };

      const totalAttempts = correct + incorrect;
      const newAccuracy = totalAttempts > 0 ? correct / totalAttempts : 0;

      generalStatistics.totalSetsCompleted++;
      generalStatistics.averageAccuracy = calculateAverageAccuracy(generalStatistics.totalSetsCompleted, userData.generalStatistics?.averageAccuracy || 0, newAccuracy);
      generalStatistics.averageRepeatUnknown = calculateAverageRepeatUnknown(generalStatistics.totalSetsCompleted, userData.generalStatistics?.averageRepeatUnknown || 0, repeatUnknown);

      await updateDoc(userRef, {
        generalStatistics
      });
    } else {
      console.log('User document does not exist, initializing...');
      await setDoc(userRef, {
        generalStatistics: {
          totalSetsCompleted: 1,
          averageAccuracy: correct > 0 ? correct / (correct + incorrect) : 0,
          averageRepeatUnknown: repeatUnknown
        }
      });
    }
  } catch (error) {
    console.error('Error updating general statistics:', error);
    throw new Error('Failed to update general statistics.');
  }
}

async function updateSetStatistics(userId: string, setId: string, correct: number, incorrect: number, repeatUnknown: number) {
  try {
    const userStatsRef = doc(db, `setStats/${setId}/userStatsForSet/${userId}`);
    const userStatsDoc = await getDoc(userStatsRef);

    if (userStatsDoc.exists()) {
      const userData = userStatsDoc.data() as SetStats;
      const totalAttempts = userData.totalAttempts + 1;
      const newCorrect = userData.totalCorrect + correct;
      const newIncorrect = userData.totalIncorrect + incorrect;
      const newRepeatUnknown = userData.totalRepeatUnknown + repeatUnknown;
      const newAverageAccuracy = newCorrect / (newCorrect + newIncorrect);

      await updateDoc(userStatsRef, {
        totalAttempts: totalAttempts,
        totalCorrect: newCorrect,
        totalIncorrect: newIncorrect,
        totalRepeatUnknown: newRepeatUnknown,
        averageAccuracy: newAverageAccuracy
      });
    } else {
      const initialStatistics = {
        averageAccuracy: correct / (correct + incorrect),
        totalAttempts: 1,
        totalCorrect: correct,
        totalIncorrect: incorrect,
        totalRepeatUnknown: repeatUnknown
      };

      await setDoc(userStatsRef, initialStatistics);
    }
  } catch (error) {
    console.error('Error updating set statistics:', error);
    throw new Error('Failed to update set statistics.');
  }
}

function calculateAverageAccuracy(totalAttempts: number, currentAverage: number, newAccuracy: number): number {
  return ((currentAverage * (totalAttempts - 1)) + newAccuracy) / totalAttempts;
}

function calculateAverageRepeatUnknown(totalSetsCompleted: number, currentAverage: number, newRepeatUnknown: number): number {
  return ((currentAverage * (totalSetsCompleted - 1)) + newRepeatUnknown) / totalSetsCompleted;
}

async function getUserStatistics(uid: string): Promise<UserStats | null> {
  try {
    const userRef = doc(db, 'userStats', uid);
    const userDoc = await getDoc(userRef);

    if (userDoc.exists()) {
      return userDoc.data() as UserStats;
    } else {
      console.log('User document does not exist.');
      return null;
    }
  } catch (error) {
    console.error('Error fetching user statistics:', error);
    throw new Error('Failed to fetch user statistics.');
  }
}

async function getSetStatistics(userId: string, setId: string): Promise<SetStats | null> {
  try {
    const userStatsRef = doc(db, `setStats/${setId}/userStatsForSet/${userId}`);
    const userStatsDoc = await getDoc(userStatsRef);

    if (userStatsDoc.exists()) {
      const userData = userStatsDoc.data() as SetStats;
      return userData;
    } else {
      console.log('User does not have access to set statistics.');
      return null;
    }
  } catch (error) {
    console.error('Error fetching set statistics:', error);
    throw new Error('Failed to fetch set statistics.');
  }
}

export { saveStatistic, getUserStatistics, getSetStatistics };