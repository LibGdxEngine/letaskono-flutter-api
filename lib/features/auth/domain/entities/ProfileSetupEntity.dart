import 'package:equatable/equatable.dart';

class ProfileCompletion extends Equatable {
  final int? height;
  final int? age;
  final int? weight;
  final String? skinColor;
  final String? country;
  final String? state;
  final String? gender;
  final String? city;
  final String? maritalStatus;
  final bool? children;
  final int? numberOfChildBoys;
  final int? numberOfChildGirls;
  final String? educationLevel;
  final String? profession;
  final String? aboutMe;
  final String? phoneNumber;
  final String? lookingFor;
  final int? memorizedQuranParts;
  final String? azkar;
  final String? prayerFrequency;
  final String? relationWithFamily;
  final bool? islamicMarriage;
  final bool? fatherAlive;
  final bool? motherAlive;
  final String? fatherOccupation;
  final String? motherOccupation;
  final int? numberOfBrothers;
  final int? numberOfSisters;
  final bool? wantQaima;
  final String? fatherAcceptMarriageWithoutQaima;
  final String? fatherKnowAboutThisWebsite;
  final String? fathersPhone;
  final String? nationalIdFront;
  final String? nationalIdBack;
  final String? nationalIdHolding;

  ProfileCompletion({
    this.height,
    this.age,
    this.weight,
    this.skinColor,
    this.country,
    this.gender,
    this.state,
    this.city,
    this.maritalStatus,
    this.children,
    this.numberOfChildBoys,
    this.numberOfChildGirls,
    this.educationLevel,
    this.profession,
    this.aboutMe,
    this.phoneNumber,
    this.lookingFor,
    this.memorizedQuranParts,
    this.azkar,
    this.prayerFrequency,
    this.relationWithFamily,
    this.islamicMarriage,
    this.fatherAlive,
    this.motherAlive,
    this.fatherOccupation,
    this.motherOccupation,
    this.numberOfBrothers,
    this.numberOfSisters,
    this.wantQaima,
    this.fatherAcceptMarriageWithoutQaima,
    this.fatherKnowAboutThisWebsite,
    this.fathersPhone,
    this.nationalIdFront,
    this.nationalIdBack,
    this.nationalIdHolding,
  });

  @override
  List<Object?> get props => [
        height,
        age,
        weight,
        skinColor,
        country,
        gender,
        state,
        city,
        maritalStatus,
        children,
        numberOfChildBoys,
        numberOfChildGirls,
        educationLevel,
        profession,
        aboutMe,
        phoneNumber,
        lookingFor,
        memorizedQuranParts,
        azkar,
        prayerFrequency,
        relationWithFamily,
        islamicMarriage,
        fatherAlive,
        motherAlive,
        fatherOccupation,
        motherOccupation,
        numberOfBrothers,
        numberOfSisters,
        wantQaima,
        fatherAcceptMarriageWithoutQaima,
        fatherKnowAboutThisWebsite,
        fathersPhone,
        nationalIdFront,
        nationalIdBack,
        nationalIdHolding,
      ];

  // Retain the toJson method for serialization
  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'age': age,
      'weight': weight,
      'skin_color': skinColor,
      'country': country,
      'gender': gender,
      'state': state,
      'city': city,
      'marital_status': maritalStatus,
      'children': children,
      'number_of_child_boys': numberOfChildBoys,
      'number_of_child_girls': numberOfChildGirls,
      'education_level': educationLevel,
      'profession': profession,
      'about_me': aboutMe,
      'phone_number': phoneNumber,
      'looking_for': lookingFor,
      'memorized_quran_parts': memorizedQuranParts,
      'azkar': azkar,
      'prayer_frequency': prayerFrequency,
      'relation_with_family': relationWithFamily,
      'islamic_marriage': islamicMarriage,
      'father_alive': fatherAlive,
      'mother_alive': motherAlive,
      'father_occupation': fatherOccupation,
      'mother_occupation': motherOccupation,
      'number_of_brothers': numberOfBrothers,
      'number_of_sisters': numberOfSisters,
      'want_qaima': wantQaima,
      'father_accept_marriage_without_qaima': fatherAcceptMarriageWithoutQaima,
      'father_know_about_this_website': fatherKnowAboutThisWebsite,
      'fathers_phone': fathersPhone,
      'national_id_front': nationalIdFront,
      'national_id_back': nationalIdBack,
      'national_id_holding': nationalIdHolding,
    };
  }
}
