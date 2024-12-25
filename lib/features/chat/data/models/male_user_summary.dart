class MaleUserSummary {
  final String id;
  final String firstName;
  final String lastName;

  MaleUserSummary({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory MaleUserSummary.fromJson(Map<String, dynamic> json) {

    return MaleUserSummary(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
