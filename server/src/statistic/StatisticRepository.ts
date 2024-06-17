import { StatisticData } from "../models/IStatisticData";
import { db } from "../database/FirebaseConfig.ts";
import { doc, getDoc, updateDoc, setDoc } from "firebase/firestore";
import { UserStats } from "../models/IUserStat";
import { SetStats } from "../models/ISetStats";

async function saveStatistic(data: StatisticData, uid: string) {
  try {
    const { setId, correct, incorrect, repeat_unknown } = data;

    await updateGeneralStatistics(uid, correct, incorrect);
    await updateSetStatistics(uid, setId, correct, incorrect, repeat_unknown || 0);
  } catch (error) {
    console.error('Error saving statistic:', error);
    throw new Error('Failed to save statistic.');
  }
}

async function updateGeneralStatistics(uid: string, correct: number, incorrect: number) {
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
      generalStatistics.averageRepeatUnknown = calculateAverageRepeatUnknown(generalStatistics.totalSetsCompleted, userData.generalStatistics?.averageRepeatUnknown || 0, 0);

      await updateDoc(userRef, {
        generalStatistics
      });
    } else {
      console.log('User document does not exist, initializing...');
      await setDoc(userRef, {
        generalStatistics: {
          totalSetsCompleted: 1,
          averageAccuracy: correct > 0 ? correct / (correct + incorrect) : 0,
          averageRepeatUnknown: 0
        }
      });
    }
  } catch (error) {
    console.error('Error updating general statistics:', error);
    throw new Error('Failed to update general statistics.');
  }
}

async function updateSetStatistics(uid: string, setId: string, correct: number, incorrect: number, repeat_unknown: number) {
  try {
    const setRef = doc(db, 'setStats', setId);
    const setDocRef = await getDoc(setRef);

    if (setDocRef.exists()) {
      const setData = setDocRef.data() as { statistics?: SetStats };

      let setStatistics: SetStats = setData.statistics || {
        uid: uid,
        totalAttempts: 0,
        totalCorrect: 0,
        totalIncorrect: 0,
        totalRepeatUnknown: 0,
        averageAccuracy: 0
      };

      const totalAttempts = correct + incorrect;
      const newAccuracy = totalAttempts > 0 ? correct / totalAttempts : 0;

      setStatistics.totalAttempts++;
      setStatistics.totalCorrect += correct;
      setStatistics.totalIncorrect += incorrect;
      setStatistics.totalRepeatUnknown += repeat_unknown;
      setStatistics.averageAccuracy = calculateAverageAccuracy(setStatistics.totalAttempts, setData.statistics?.averageAccuracy || 0, newAccuracy);

      await updateDoc(setRef, {
        statistics: setStatistics
      });
    } else {
      console.log('Set document does not exist, initializing...');
      await setDoc(setRef, {
        statistics: {
          uid: uid,
          totalAttempts: 1,
          totalCorrect: correct,
          totalIncorrect: incorrect,
          totalRepeatUnknown: repeat_unknown,
          averageAccuracy: correct > 0 ? correct / (correct + incorrect) : 0
        }
      });
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

export { saveStatistic };