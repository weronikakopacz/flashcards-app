class StatisticData {
  final String? uid;
  final String setId;
  final int correct;
  final int incorrect;
  final int? repeatUnknown;

  StatisticData({
    this.uid,
    required this.setId,
    required this.correct,
    required this.incorrect,
    this.repeatUnknown,
  });

  Map<String, dynamic> toJson() {
    return {
      'setId': setId,
      'correct': correct,
      'incorrect': incorrect,
      'repeatUnknown': repeatUnknown?? 0,
    };
  }
}