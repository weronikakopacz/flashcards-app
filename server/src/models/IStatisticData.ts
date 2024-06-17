interface StatisticData {
    uid?: string;
    setId: string;
    correct: number;
    incorrect: number;
    repeat_unknown?: number;
}

export { StatisticData };