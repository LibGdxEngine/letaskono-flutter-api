import 'dart:convert';

import 'Profile.dart';

class UserDetails {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final Profile profile;
  final bool isActive;
  final bool emailConfirmed;
  final bool isUserInFollowingList;
  final bool isUserSentMeValidRequest;
  final bool isUserInBlackList;

  UserDetails({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profile,
    required this.isActive,
    required this.emailConfirmed,
    required this.isUserInFollowingList,
    required this.isUserInBlackList,
    required this.isUserSentMeValidRequest,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profile: Profile.fromJson(json['profile']),
      isActive: json['is_active'],
      emailConfirmed: json['email_confirmed'],
      isUserSentMeValidRequest: json['is_user_sent_me_valid_request'],
      isUserInBlackList: json['is_user_in_black_list'],
      isUserInFollowingList: json['is_user_in_following_list'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile': profile.toJson(),
      'is_active': isActive,
      'email_confirmed': emailConfirmed,
      'is_user_sent_me_valid_request': isUserSentMeValidRequest,
      'is_user_in_black_list': isUserInBlackList,
      'is_user_in_following_list': isUserInFollowingList,
    };
  }
}
