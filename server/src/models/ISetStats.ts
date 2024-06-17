interface SetStats {
    uid: string;
    totalAttempts: number;
    totalCorrect: number;
    totalIncorrect: number;
    totalRepeatUnknown: number;
    averageAccuracy: number;
}

export { SetStats };