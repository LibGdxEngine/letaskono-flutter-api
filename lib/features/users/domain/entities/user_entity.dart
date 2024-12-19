class UserEntity {
  final String id;
  final String code;
  final int age;
  final int height;
  final int weight;
  final String country;
  final String state;
  final String nationality;
  final String maritalStatus;
  final String hijab;
  final String le7ya;
  final String gender;
  final String profession;
  final String educationLevel;
  final DateTime lastSeen;
  final DateTime dateJoined;

  const UserEntity({
    required this.id,
    required this.code,
    required this.age,
    required this.height,
    required this.weight,
    required this.country,
    required this.state,
    required this.nationality,
    required this.profession,
    required this.educationLevel,
    required this.maritalStatus,
    required this.hijab,
    required this.le7ya,
    required this.gender,
    required this.lastSeen,
    required this.dateJoined,
  });

  // Factory constructor for creating a UserEntity from JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      code: json['code'] as String,
      profession: json['profession'] as String,
      educationLevel: json['education_level'] as String,
      maritalStatus: json['marital_status'] as String,
      hijab: json['hijab'] as String,
      le7ya: json['le7ya'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      height: json['height'] as int,
      weight: json['weight'] as int,
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      nationality: json['nationality'] ?? '',
      lastSeen: DateTime.parse(json['last_seen']),
      dateJoined: DateTime.parse(json['date_joined']),
    );
  }

  // Method for converting a UserEntity instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'education_level': educationLevel,
      'profession': profession,
      'age': age,
      'height': height,
      'weight': weight,
      'country': country,
      'marital_status': maritalStatus,
      'gender': gender,
      'last_seen': lastSeen.toIso8601String(),
      'date_joined': dateJoined.toIso8601String(),
    };
  }
}
