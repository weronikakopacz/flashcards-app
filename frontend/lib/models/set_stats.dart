class SetStats {
  final int totalAttempts;
  final int totalCorrect;
  final int totalIncorrect;
  final int totalRepeatUnknown;
  final double averageAccuracy;

  SetStats({
    required this.totalAttempts,
    required this.totalCorrect,
    required this.totalIncorrect,
    required this.totalRepeatUnknown,
    required this.averageAccuracy,
  });

  factory SetStats.fromJson(Map<String, dynamic> json) {
    return SetStats(
      totalAttempts: json['totalAttempts'],
      totalCorrect: json['totalCorrect'],
      totalIncorrect: json['totalIncorrect'],
      totalRepeatUnknown: json['totalRepeatUnknown'],
      averageAccuracy: json['averageAccuracy'],
    );
  }
}