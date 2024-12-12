class SearchEntity {
  final String? ageMin;
  final String? ageMax;
  final String? maritalStatus;
  final String? country;
  final List<String>? selectedStates;
  final String? gender;
  final String? ordering;

  const SearchEntity({
    this.ageMin = '18', // Default to 18
    this.ageMax = '100', // Default to 100
    this.maritalStatus = 'any', // Default to 'any'
    this.country = 'unknown', // Default to 'unknown'
    this.selectedStates = const [], // Default to an empty list
    this.gender = '', // Default to 'any'
    this.ordering = 'asc', // Default to ascending order
  });

  @override
  String toString() {
    // &marital_status=$maritalStatus&country=$country&state=$selectedStates&gender=$gender
    String? gender = this.gender!.isNotEmpty ? "&gender=${this.gender}" : "";
    String? ordering = this.ordering!.isNotEmpty ? "&ordering=${this.ordering}" : "";
    return 'age_min=$ageMin&age_max=$ageMax$gender$ordering';
  }
}
