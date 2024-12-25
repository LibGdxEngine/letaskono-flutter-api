import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/search_entity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> fetchUsers({int page, SearchEntity? query});

  Future<List<UserEntity>> fetchFavourites({int page});

  Future<UserDetailsEntity> fetchUserDetails(String userCode);

  Future<String> sendRequest(String receiverId);

  Future<String> addToFavourites(String userCode);

  Future<String> removeFromFavourites(String userCode);

  Future<String> addToBlacklist(String userCode);

  Future<String> removeFromBlacklist(String userCode);

  Future<String> acceptRequest(int requestId);

  Future<String> rejectRequest(int requestId);

  Future<String> setOnline();

  Future<String> setOffline();
}
