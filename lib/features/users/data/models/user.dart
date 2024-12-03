class User {
  final String id;
  final String code;
  final int age;
  final int height;
  final int weight;
  final String country;
  final String maritalStatus;
  final String gender;
  final String profession;
  final String educationLevel;
  final DateTime lastSeen;
  final DateTime dateJoined;


  User({
    required this.id,
    required this.code,
    required this.age,
    required this.height,
    required this.weight,
    required this.country,
    required this.profession,
    required this.educationLevel,
    required this.maritalStatus,
    required this.gender,
    required this.lastSeen,
    required this.dateJoined,

  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      code: json['code'] as String,
      profession: json['profession'] as String,
      educationLevel: json['education_level'] as String,
      maritalStatus: json['marital_status'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      height: json['height'] as int,
      weight: json['weight'] as int,
      country: json['country'] ?? '',
      lastSeen: DateTime.parse(json['last_seen']),
      dateJoined: DateTime.parse(json['date_joined']),

    );
  }

  @override
  String toString() {
    return 'User(code: $code, gender: $gender, country: $country)';
  }
}
