class Set {
  final String? id;
  final String title;
  final CreatorEmail? creatorEmail;
  final bool isPublic;

  Set({
    this.id,
    required this.title,
    this.creatorEmail,
    required this.isPublic,
  });

  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      id: json['id'],
      title: json['title'],
      creatorEmail: json['creatorEmail'] != null ? CreatorEmail.fromJson(json['creatorEmail']) : null,
      isPublic: json['isPublic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      email: json['email'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
    };
  }
}
