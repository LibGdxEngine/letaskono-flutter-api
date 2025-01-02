class ProfileChangeEntity {
  final String? aboutMe;
  final String? country;
  final String? state;
  final String? city;
  final String? disabilities;
  final String? le7ya;
  final int? age;
  final int? height;
  final int? weight;
  final String? educationLevel;
  final String? skinColor;
  final String? profession;
  final int? numberOfChildBoys;
  final int? numberOfChildGirls;
  final String? azkar;
  final String? hijab;
  final String? prayerFrequency;
  final int? memorizedQuranParts;
  final String? relationWithFamily;
  final bool? islamicMarriage;
  final String? whoDoYouListenTo;
  final String? doAcquireKnowledge;
  final String? doYouRelateToHizb;
  final bool? fatherAlive;
  final bool? motherAlive;
  final String? fatherOccupation;
  final String? motherOccupation;
  final String? lookingFor;
  final String? preferredAgeRange;
  final String? preferredCountry;
  final String? hobbies;
  final String? languagesSpoken;
  final bool? wantQaima;
  final bool? fatherAcceptMarriageWithoutQaima;

  ProfileChangeEntity({
    this.aboutMe,
    this.country,
    this.state,
    this.city,
    this.le7ya,
    this.age,
    this.disabilities,
    this.height,
    this.weight,
    this.educationLevel,
    this.skinColor,
    this.profession,
    this.numberOfChildBoys,
    this.numberOfChildGirls,
    this.azkar,
    this.hijab,
    this.prayerFrequency,
    this.memorizedQuranParts,
    this.relationWithFamily,
    this.islamicMarriage,
    this.whoDoYouListenTo,
    this.doAcquireKnowledge,
    this.doYouRelateToHizb,
    this.fatherAlive,
    this.motherAlive,
    this.fatherOccupation,
    this.motherOccupation,
    this.lookingFor,
    this.preferredAgeRange,
    this.preferredCountry,
    this.hobbies,
    this.languagesSpoken,
    this.wantQaima,
    this.fatherAcceptMarriageWithoutQaima,
  });

  // Factory constructor for parsing JSON to Entity
  factory ProfileChangeEntity.fromJson(Map<String, dynamic> json) {
    return ProfileChangeEntity(
      aboutMe: json['about'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      disabilities: json['disabilities'],
      le7ya: json['le7ya'],
      educationLevel: json['education'],
      age: int.tryParse(json['age'] ?? ''),
      height: int.tryParse(json['height'] ?? ''),
      weight: int.tryParse(json['weight'] ?? ''),
      skinColor: json['skinColor'],
      profession: json['profession'],
      numberOfChildBoys: json['number_of_child_boys'],
      numberOfChildGirls: json['number_of_child_girls'],
      azkar: json['azkar'],
      hijab: json['hijab'],
      prayerFrequency: json['pray'],
      memorizedQuranParts: int.tryParse(json['quran'] ?? ''),
      relationWithFamily: json['relation_with_family'],
      islamicMarriage: json['islamic_marriage'],
      whoDoYouListenTo: json['who_do_you_listen_to'],
      doAcquireKnowledge: json['do_acquire_knowledge'],
      doYouRelateToHizb: json['do_you_relate_to_hizb'],
      fatherAlive: json['father_alive'],
      motherAlive: json['mother_alive'],
      fatherOccupation: json['father_occupation'],
      motherOccupation: json['mother_occupation'],
      lookingFor: json['looking_for'],
      preferredAgeRange: json['preferred_age_range'],
      preferredCountry: json['preferred_country'],
      hobbies: json['hobbies'],
      languagesSpoken: json['languages_spoken'],
      wantQaima: json['want_qaima'],
      fatherAcceptMarriageWithoutQaima: json['father_accept_marriage_without_qaima'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (aboutMe != null) data['about_me'] = aboutMe;
    if (country != null) data['country'] = country;
    if (disabilities != null) data['disabilities'] = disabilities;
    if (state != null) data['state'] = state;
    if (city != null) data['city'] = city;
    if (le7ya != null) data['le7ya'] = le7ya;
    if (age != null) data['age'] = age;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;
    if (educationLevel != null) data['education_level'] = educationLevel;
    if (skinColor != null) data['skin_color'] = skinColor;
    if (profession != null) data['profession'] = profession;
    if (numberOfChildBoys != null) data['number_of_child_boys'] = numberOfChildBoys;
    if (numberOfChildGirls != null) data['number_of_child_girls'] = numberOfChildGirls;
    if (azkar != null) data['azkar'] = azkar;
    if (hijab != null) data['hijab'] = hijab;
    if (prayerFrequency != null) data['prayer_frequency'] = prayerFrequency;
    if (memorizedQuranParts != null) data['memorized_quran_parts'] = memorizedQuranParts;
    if (relationWithFamily != null) data['relation_with_family'] = relationWithFamily;
    if (islamicMarriage != null) data['islamic_marriage'] = islamicMarriage;
    if (whoDoYouListenTo != null) data['who_do_you_listen_to'] = whoDoYouListenTo;
    if (doAcquireKnowledge != null) data['do_acquire_knowledge'] = doAcquireKnowledge;
    if (doYouRelateToHizb != null) data['do_you_relate_to_hizb'] = doYouRelateToHizb;
    if (fatherAlive != null) data['father_alive'] = fatherAlive;
    if (motherAlive != null) data['mother_alive'] = motherAlive;
    if (fatherOccupation != null) data['father_occupation'] = fatherOccupation;
    if (motherOccupation != null) data['mother_occupation'] = motherOccupation;
    if (lookingFor != null) data['looking_for'] = lookingFor;
    if (preferredAgeRange != null) data['preferred_age_range'] = preferredAgeRange;
    if (preferredCountry != null) data['preferred_country'] = preferredCountry;
    if (hobbies != null) data['hobbies'] = hobbies;
    if (languagesSpoken != null) data['languages_spoken'] = languagesSpoken;
    if (wantQaima != null) data['want_qaima'] = wantQaima;
    if (fatherAcceptMarriageWithoutQaima != null) {
      data['father_accept_marriage_without_qaima'] = fatherAcceptMarriageWithoutQaima;
    }

    return data;
  }
}
