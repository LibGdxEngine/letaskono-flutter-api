class SearchEntity {
  final String? ageMin;
  final String? ageMax;
  final List<String>? maritalStatus;
  final List<String>? countries;
  final List<String>? hijabs;
  final List<String>? le7yas;
  final List<String>? nationalities;
  final List<String>? states;
  final String? gender;
  final String? ordering;

  const SearchEntity({
    this.ageMin = '18', // Default to 18
    this.ageMax = '100', // Default to 100
    this.maritalStatus = const [],
    this.countries = const [],
    this.hijabs = const [],
    this.le7yas = const [],
    this.nationalities = const [],
    this.states = const [],
    this.gender = 'F',
    this.ordering = 'age', // Default to ascending order
  });

  @override
  String toString() {
    String le7yasQuery = le7yas != null && le7yas!.isNotEmpty
        ? le7yas!.map((le7ya) => '&le7yas=$le7ya').join('')
        : '';
    String hijabsQuery = hijabs != null && hijabs!.isNotEmpty
        ? hijabs!.map((hijab) => '&hijabs=$hijab').join('')
        : '';
    String nationalitiesQuery =
        nationalities != null && nationalities!.isNotEmpty
            ? nationalities!
                .map((nationality) => '&nationalities=$nationality')
                .join('')
            : '';
    String countriesQuery = countries != null && countries!.isNotEmpty
        ? countries!.map((country) => '&countries=$country').join('')
        : '';
    String statesQuery = states != null && states!.isNotEmpty
        ? states!.map((state) => '&states=$state').join('')
        : '';
    String maritalStatusQuery =
        maritalStatus != null && maritalStatus!.isNotEmpty
            ? maritalStatus!.map((status) => '&marital_status=$status').join('')
            : '';
    String gender = '&gender=${this.gender}';
    String ageMin =
        '&age_min=${double.tryParse(this.ageMin!)?.round().toString()}';
    String ageMax =
        '&ageMax=${double.tryParse(this.ageMax!)?.round().toString()}';
    final query =
        '$gender$ageMin$ageMax$maritalStatusQuery$countriesQuery$statesQuery$nationalitiesQuery$hijabsQuery$le7yasQuery';
    return query;
  }
}
