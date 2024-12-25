import 'package:letaskono_flutter/features/users/data/data_sources/user_remote_data_source.dart';
import 'package:letaskono_flutter/features/users/domain/entities/search_entity.dart';
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
  Future<List<UserEntity>> fetchUsers(
      {int page = 1, SearchEntity? query}) async {
    // Fetch users from the remote data source
    final List<User> users =
        await remoteDataSource.fetchUsers(page: page, query: query);

    // Map User models to UserEntity
    return users.map((user) => _mapUserToEntity(user)).toList();
  }

  @override
  Future<List<UserEntity>> fetchFavourites({int page = 1}) async {
    // Fetch users from the remote data source
    final List<User> users = await remoteDataSource.fetchFavourites(page: page);

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

  @override
  Future<String> addToBlacklist(String userCode) async {
    return await remoteDataSource.addToBlacklist(userCode);
  }

  @override
  Future<String> removeFromBlacklist(String userCode) async {
    return await remoteDataSource.removeFromBlacklist(userCode);
  }

  @override
  Future<String> acceptRequest(int requestId) async {
    return await remoteDataSource.acceptRequest(requestId);
  }

  @override
  Future<String> rejectRequest(int requestId) async {
    return await remoteDataSource.rejectRequest(requestId);
  }

  UserDetailsEntity _mapUserDetailToEntity(UserDetails user) {
    return UserDetailsEntity(
      id: user.id,
      pkid: user.pkid,
      preferredCountry: user.profile.preferredCountry,
      azkar: user.profile.azkar,
      le7ya: user.profile.le7ya,
      nationality: user.profile.nationality,
      lookingFor: user.profile.lookingFor,
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
      languagesSpoken: user.profile.languagesSpoken,
      islamicMarriage: user.profile.islamicMarriage,
      fatherAlive: user.profile.fatherAlive,
      fatherOccupation: user.profile.fatherOccupation,
      motherAlive: user.profile.motherAlive,
      motherOccupation: user.profile.motherOccupation,
      numberOfBrothers: user.profile.numberOfBrothers,
      numberOfSisters: user.profile.numberOfSisters,
      wantQaima: user.profile.wantQaima,
      requestSendingStatus: user.profile.requestSendingStatus,
      isBlocked: user.profile.isBlocked,
      relationWithFamily: user.profile.relationWithFamily,
      isDisabled: user.profile.isDisabled,
      hijab: user.profile.hijab,
      isAccountConfirmed: user.profile.isAccountConfirmed,
      fcmToken: user.profile.fcmToken,
      country: user.profile.country,
      memorizedQuranParts: user.profile.memorizedQuranParts,
      isOnline: user.profile.isOnline,
      isUserInBlackList: user.isUserInBlackList,
      isUserInFollowingList: user.isUserInFollowingList,
      validRequest: user.validRequest,
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
      maritalStatus: user.maritalStatus,
      lastSeen: user.lastSeen,
      profession: user.profession,
      educationLevel: user.educationLevel,
      age: user.age,
      gender: user.gender,
      state: user.state,
      nationality: user.nationality,
      hijab: user.hijab,
      le7ya: user.le7ya,
    );
  }

  @override
  Future<String> setOffline() async {
    return await remoteDataSource.setOffline();
  }

  @override
  Future<String> setOnline() async {
    return await remoteDataSource.setOnline();
  }
}
