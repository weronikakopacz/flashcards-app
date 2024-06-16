class Flashcard {
  final String? id;
  final String term;
  final String definition;
  final String? setId;

  Flashcard({
    this.id,
    required this.term,
    required this.definition,
    this.setId,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      term: json['term'],
      definition: json['definition'],
      setId: json['setId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term': term,
      'definition': definition,
    };
  }
}