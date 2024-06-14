class Set {
  final String? id;
  final String title;
  final String? creatorUserId;
  final bool isPublic;
  final CreatorEmail? creatorEmail;

  Set({
    this.id,
    required this.title,
    this.creatorUserId,
    required this.isPublic,
    this.creatorEmail,
  });

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      creatorUserId: json['creatorUserId'] ?? '',
      isPublic: json['isPublic'] ?? false,
      creatorEmail: json.containsKey('creatorEmail') && json['creatorEmail'] != null
          ? CreatorEmail.fromJson(json['creatorEmail'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isPublic': isPublic,
      'creatorEmail': creatorEmail?.toJson(),
    };
  }
}

class CreatorEmail {
  final String email;
  final String uid;

  CreatorEmail({
    required this.email,
    required this.uid,
  });

  factory CreatorEmail.fromJson(Map<String, dynamic> json) {
    return CreatorEmail(
      email: json['email'] ?? '',
      uid: json['uid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
    };
  }
}