class Profile {
  final String id;
  final String code;

  Profile({required this.id, required this.code});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(id: json['id'], code: json['code']);
  }
}
