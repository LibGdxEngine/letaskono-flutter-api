import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String educationLevel;
  final String profession;
  final int age;
  final int height;
  final int weight;
  final String country;
  final String maritalStatus;
  final String gender;
  final DateTime lastSeen;
  final DateTime dateJoined;

  const UserEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.educationLevel,
    required this.profession,
    required this.age,
    required this.height,
    required this.weight,
    required this.country,
    required this.maritalStatus,
    required this.gender,
    required this.lastSeen,
    required this.dateJoined,
  });

  @override
  List<Object> get props => [
        id,
        name,
        code,
        educationLevel,
        profession,
        age,
        height,
        weight,
        country,
        maritalStatus,
        gender,
        lastSeen,
        dateJoined,
      ];

  // Factory constructor for creating a UserEntity from JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      educationLevel: json['education_level'] as String,
      profession: json['profession'] as String,
      age: json['age'] as int,
      height: json['height'],
      weight: json['weight'],
      country: json['country'] as String,
      maritalStatus: json['marital_status'] as String,
      gender: json['gender'] as String,
      lastSeen: DateTime.parse(json['last_seen'] as String),
      dateJoined: DateTime.parse(json['date_joined'] as String),
    );
  }

  // Method for converting a UserEntity instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
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
