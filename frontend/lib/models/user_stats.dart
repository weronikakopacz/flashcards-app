class UserStats {
  final int totalSetsCompleted;
  final double averageAccuracy;
  final double averageRepeatUnknown;

  UserStats({
    required this.totalSetsCompleted,
    required this.averageAccuracy,
    required this.averageRepeatUnknown,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    final generalStatistics = json['generalStatistics'];
    return UserStats(
      totalSetsCompleted: generalStatistics['totalSetsCompleted'],
      averageAccuracy: generalStatistics['averageAccuracy'],
      averageRepeatUnknown: generalStatistics['averageRepeatUnknown'],
    );
  }
}