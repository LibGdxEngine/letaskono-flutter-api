class FemaleUserSummary {
  final String id;
  final String firstName;
  final String lastName;
  final String fatherRelatedInfo;

  FemaleUserSummary({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fatherRelatedInfo,
  });

  factory FemaleUserSummary.fromJson(Map<String, dynamic> json) {
    return FemaleUserSummary(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fatherRelatedInfo: json['father_related_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'father_related_info': fatherRelatedInfo,
    };
  }
}