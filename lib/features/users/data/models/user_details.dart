import 'package:letaskono_flutter/features/users/data/models/AcceptanceRequest.dart';

import 'Profile.dart';

class UserDetails {
  final String id;
  final String pkid;
  final String? email;
  final String? firstName;
  final String? lastName;
  final Profile profile;
  final bool isActive;
  final bool emailConfirmed;
  final bool isUserInFollowingList;
  final bool isUserInBlackList;
  final AcceptanceRequest? validRequest;

  UserDetails({
    required this.id,
    required this.pkid,
    this.email,
    this.firstName,
    this.lastName,
    required this.profile,
    required this.isActive,
    required this.emailConfirmed,
    required this.isUserInFollowingList,
    required this.isUserInBlackList,
    this.validRequest,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      pkid: json['pkid'].toString(),
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profile: Profile.fromJson(json['profile']),
      isActive: json['is_active'],
      emailConfirmed: json['email_confirmed'],
      isUserInBlackList: json['is_user_in_black_list'],
      isUserInFollowingList: json['is_user_in_following_list'],
      validRequest: json['valid_request'] != null
          ? AcceptanceRequest.fromJson(json['valid_request'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pkid': pkid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile': profile.toJson(),
      'is_active': isActive,
      'email_confirmed': emailConfirmed,
      'is_user_in_black_list': isUserInBlackList,
      'is_user_in_following_list': isUserInFollowingList,
      'valid_request': validRequest,
    };
  }
}
