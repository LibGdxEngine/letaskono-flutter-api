import 'package:letaskono_flutter/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

import '../../domain/entities/UserDetailsEntity.dart';
import '../models/user.dart';
import '../models/user_details.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource remoteDataSource;

  // Constructor with initializer list
  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> fetchUsers() async {
    // Fetch users from the remote data source
    final List<User> users = await remoteDataSource.fetchUsers();

    // Map User models to UserEntity
    return users.map((user) => _mapUserToEntity(user)).toList();
  }

  @override
  Future<UserDetailsEntity> fetchUserDetails(String userCode) async {
    final UserDetails user = await remoteDataSource.fetchUserDetails(userCode);
    return _mapUserDetailToEntity(user);
  }

  @override
  Future<String> sendRequest(String receiverId) async {
    return await remoteDataSource.sendRequest(receiverId);
  }

  @override
  Future<String> addToFavourites(String userCode) async {
    return await remoteDataSource.addToFavourites(userCode);
  }

  @override
  Future<String> removeFromFavourites(String userCode) async {
    return await remoteDataSource.removeFromFavourites(userCode);
  }

  UserDetailsEntity _mapUserDetailToEntity(UserDetails user) {
    return UserDetailsEntity(
      id: user.id,
      preferredCountry: user.profile.preferredCountry,
      azkar: user.profile.azkar,
      prayerFrequency: user.profile.prayerFrequency,
      code: user.profile.code,
      gender: user.profile.gender,
      age: user.profile.age,
      state: user.profile.state,
      city: user.profile.city,
      phoneNumber: user.profile.phoneNumber,
      educationLevel: user.profile.educationLevel,
      profession: user.profile.profession,
      maritalStatus: user.profile.maritalStatus,
      children: user.profile.children,
      numberOfChildBoys: user.profile.numberOfChildBoys ?? 0,
      numberOfChildGirls: user.profile.numberOfChildGirls ?? 0,
      height: user.profile.height,
      weight: user.profile.weight,
      skinColor: user.profile.skinColor,
      aboutMe: user.profile.aboutMe,
      islamicMarriage: user.profile.islamicMarriage,
      fatherAlive: user.profile.fatherAlive,
      motherAlive: user.profile.motherAlive,
      numberOfBrothers: user.profile.numberOfBrothers,
      numberOfSisters: user.profile.numberOfSisters,
      wantQaima: user.profile.wantQaima,
      requestSendingStatus: user.profile.requestSendingStatus,
      isBlocked: user.profile.isBlocked,
      isDisabled: user.profile.isDisabled,
      isAccountConfirmed: user.profile.isAccountConfirmed,
      fcmToken: user.profile.fcmToken,
      country: user.profile.country,
      memorizedQuranParts: user.profile.memorizedQuranParts,
      isOnline: user.profile.isOnline,
      isUserInBlackList: user.isUserInBlackList,
      isUserSentMeValidRequest: user.isUserSentMeValidRequest,
      isUserInFollowingList: user.isUserInFollowingList,
    );
  }

  // Helper function to map User to UserEntity
  UserEntity _mapUserToEntity(User user) {
    return UserEntity(
      code: user.code,
      country: user.country,
      dateJoined: user.dateJoined,
      weight: user.weight,
      height: user.height,
      id: user.id,
      name: user.code,
      maritalStatus: user.maritalStatus,
      lastSeen: user.lastSeen,
      profession: user.profession,
      educationLevel: user.educationLevel,
      age: user.age,
      gender: user.gender,
    );
  }
}
