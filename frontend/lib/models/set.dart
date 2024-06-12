class Set {
  final String? id;
  final String title;
  final String? creatorUserId;
  final bool isPublic;

  Set({
    this.id,
    required this.title,
    this.creatorUserId,
    required this.isPublic,
  });

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      id: json['id'],
      title: json['title'],
      creatorUserId: json['creatorUserId'],
      isPublic: json['isPublic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isPublic': isPublic,
    };
  }
}