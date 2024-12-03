class UserDetailsEntity {
  final String? id;
  final String? code;
  final String? fcmToken;
  final String? gender;
  final int? age;
  final String? country;
  final String? state;
  final String? city;
  final String? phoneNumber;
  final String? fathersPhone;
  final String? educationLevel;
  final String? profession;
  final String? maritalStatus;
  final bool? children;
  final int? numberOfChildBoys;
  final int? numberOfChildGirls;
  final int? height;
  final int? weight;
  final String? skinColor;
  final String? aboutMe;
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
  final int? numberOfBrothers;
  final int? numberOfSisters;
  final String? lookingFor;
  final String? preferredAgeRange;
  final String? preferredCountry;
  final String? hobbies;
  final String? languagesSpoken;
  final bool? wantQaima;
  final String? fatherAcceptMarriageWithoutQaima;
  final String? fatherKnowAboutThisWebsite;
  final String? requestSendingStatus;
  final bool? isBlocked;
  final DateTime? blockUntil;
  final String? blockingReason;
  final bool? isDisabled;
  final DateTime? scheduledDeletion;
  final bool? isAccountConfirmed;
  final String? accountRejectionReason;
  final bool? isOnline;
  final DateTime? lastSeen;
  bool? isUserInFollowingList;
  final bool? isUserSentMeValidRequest;
  final bool? isUserInBlackList;

  UserDetailsEntity({
    this.id,
    this.code,
    this.fcmToken,
    this.gender,
    this.age,
    this.country,
    this.state,
    this.city,
    this.phoneNumber,
    this.fathersPhone,
    this.educationLevel,
    this.profession,
    this.maritalStatus,
    this.children,
    this.numberOfChildBoys,
    this.numberOfChildGirls,
    this.height,
    this.weight,
    this.skinColor,
    this.aboutMe,
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
    this.numberOfBrothers,
    this.numberOfSisters,
    this.lookingFor,
    this.preferredAgeRange,
    this.preferredCountry,
    this.hobbies,
    this.languagesSpoken,
    this.wantQaima,
    this.fatherAcceptMarriageWithoutQaima,
    this.fatherKnowAboutThisWebsite,
    this.requestSendingStatus,
    this.isBlocked,
    this.blockUntil,
    this.blockingReason,
    this.isDisabled,
    this.scheduledDeletion,
    this.isAccountConfirmed,
    this.accountRejectionReason,
    this.isOnline,
    this.lastSeen,
    this.isUserInFollowingList,
    this.isUserInBlackList,
    this.isUserSentMeValidRequest,
  });

  // Factory constructor to create UserDetailsEntity object from JSON
  factory UserDetailsEntity.fromJson(Map<String, dynamic> json) {
    return UserDetailsEntity(
      id: json['id'],
      code: json['code'],
      fcmToken: json['fcm_token'],
      gender: json['gender'],
      age: json['age'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      phoneNumber: json['phone_number'],
      fathersPhone: json['fathers_phone'],
      educationLevel: json['education_level'],
      profession: json['profession'],
      maritalStatus: json['marital_status'],
      children: json['children'],
      numberOfChildBoys: json['number_of_child_boys'],
      numberOfChildGirls: json['number_of_child_girls'],
      height: json['height'],
      weight: json['weight'],
      skinColor: json['skin_color'],
      aboutMe: json['about_me'],
      azkar: json['azkar'],
      hijab: json['hijab'],
      prayerFrequency: json['prayer_frequency'],
      memorizedQuranParts: json['memorized_quran_parts'],
      relationWithFamily: json['relation_with_family'],
      islamicMarriage: json['islamic_marriage'],
      whoDoYouListenTo: json['who_do_you_listen_to'],
      doAcquireKnowledge: json['do_acquire_knowledge'],
      doYouRelateToHizb: json['do_you_relate_to_hizb'],
      fatherAlive: json['father_alive'],
      motherAlive: json['mother_alive'],
      fatherOccupation: json['father_occupation'],
      motherOccupation: json['mother_occupation'],
      numberOfBrothers: json['number_of_brothers'],
      numberOfSisters: json['number_of_sisters'],
      lookingFor: json['looking_for'],
      preferredAgeRange: json['preferred_age_range'],
      preferredCountry: json['preferred_country'],
      hobbies: json['hobbies'],
      languagesSpoken: json['languages_spoken'],
      wantQaima: json['want_qaima'],
      fatherAcceptMarriageWithoutQaima:
          json['father_accept_marriage_without_qaima'],
      fatherKnowAboutThisWebsite: json['father_know_about_this_website'],
      requestSendingStatus: json['request_sending_status'],
      isBlocked: json['is_blocked'],
      blockUntil: DateTime.parse(json['block_until']),
      blockingReason: json['blocking_reason'],
      isDisabled: json['is_disabled'],
      scheduledDeletion: DateTime.parse(json['scheduled_deletion']),
      isAccountConfirmed: json['is_account_confirmed'],
      accountRejectionReason: json['account_rejection_reason'],
      isOnline: json['is_online'],
      lastSeen: DateTime.parse(json['last_seen']),
      isUserSentMeValidRequest: json['is_user_sent_me_valid_request'],
      isUserInBlackList: json['is_user_in_black_list'],
      isUserInFollowingList: json['is_user_in_following_list'],
    );
  }

  // Convert UserDetailsEntity object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'fcm_token': fcmToken,
      'gender': gender,
      'age': age,
      'country': country,
      'state': state,
      'city': city,
      'phone_number': phoneNumber,
      'fathers_phone': fathersPhone,
      'education_level': educationLevel,
      'profession': profession,
      'marital_status': maritalStatus,
      'children': children,
      'number_of_child_boys': numberOfChildBoys,
      'number_of_child_girls': numberOfChildGirls,
      'height': height,
      'weight': weight,
      'skin_color': skinColor,
      'about_me': aboutMe,
      'azkar': azkar,
      'hijab': hijab,
      'prayer_frequency': prayerFrequency,
      'memorized_quran_parts': memorizedQuranParts,
      'relation_with_family': relationWithFamily,
      'islamic_marriage': islamicMarriage,
      'who_do_you_listen_to': whoDoYouListenTo,
      'do_acquire_knowledge': doAcquireKnowledge,
      'do_you_relate_to_hizb': doYouRelateToHizb,
      'father_alive': fatherAlive,
      'mother_alive': motherAlive,
      'father_occupation': fatherOccupation,
      'mother_occupation': motherOccupation,
      'number_of_brothers': numberOfBrothers,
      'number_of_sisters': numberOfSisters,
      'looking_for': lookingFor,
      'preferred_age_range': preferredAgeRange,
      'preferred_country': preferredCountry,
      'hobbies': hobbies,
      'languages_spoken': languagesSpoken,
      'want_qaima': wantQaima,
      'father_accept_marriage_without_qaima': fatherAcceptMarriageWithoutQaima,
      'father_know_about_this_website': fatherKnowAboutThisWebsite,
      'request_sending_status': requestSendingStatus,
      'is_blocked': isBlocked,
      'block_until': blockUntil?.toIso8601String(),
      'blocking_reason': blockingReason,
      'is_disabled': isDisabled,
      'scheduled_deletion': scheduledDeletion?.toIso8601String(),
      'is_account_confirmed': isAccountConfirmed,
      'account_rejection_reason': accountRejectionReason,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
      'is_user_sent_me_valid_request': isUserSentMeValidRequest,
      'is_user_in_black_list': isUserInBlackList,
      'is_user_in_following_list': isUserInFollowingList,
    };
  }
}