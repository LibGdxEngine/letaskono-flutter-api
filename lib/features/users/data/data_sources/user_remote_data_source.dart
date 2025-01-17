import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:letaskono_flutter/core/utils/CustomException.dart';
import 'package:letaskono_flutter/features/users/domain/entities/search_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/http_client.dart';
import '../../domain/entities/UserModifyEntity.dart';
import '../models/user.dart';
import '../models/user_details.dart';

abstract class UserRemoteDataSource {
  Future<UserDetails> fetchCurrentUser();

  Future<List<User>> fetchUsers({int page, SearchEntity? query});

  Future<List<User>> fetchFavourites({required int page});

  Future<UserDetails> fetchUserDetails(String userCode);

  Future<UserDetails> modifyUser(ProfileChangeEntity pce);

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

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final HttpClient httpClient;
  final SharedPreferences prefs;

  UserRemoteDataSourceImpl({required this.httpClient, required this.prefs});

  @override
  Future<List<User>> fetchUsers({int page = 1, query}) async {
    String? token = prefs.getString('auth_token');

    try {
      final response = await httpClient.get(
        'api/v1/users/account/?page=$page${query != null ? "${query.toString()}" : ""}',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      List<dynamic> responseList;
      if (response.data.containsKey("results")) {
        responseList = response.data['results'];
      } else {
        responseList = response.data;
      }
      var users = responseList.map((data) => User.fromJson(data)).toList();
      return users;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(e);
    }
  }

  @override
  Future<UserDetails> fetchUserDetails(String userCode) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.get(
        'api/v1/users/account/$userCode/retrieve_user/',
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );
      return UserDetails.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> sendRequest(String receiverId) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/requests/acceptance_requests/send_request/',
        data: {'receiver_id': receiverId},
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      if (response.data is Map<String, dynamic>) {
        return "تم إرسال طلب القبول بنجاح";
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode != null && e.response?.statusCode == 403) {
        throw Customexception("حسابك غير مفعل بعد, انتظر تفعيله من الإدارة");
      }
      throw Customexception((e.response?.data['error'].toString())!);
    }
  }

  @override
  Future<String> addToFavourites(String userCode) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/users/account/${userCode}/follow/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return response.data['status'];
    } on DioException catch (e) {
      throw Customexception((e.response?.data['error'].toString())!);
    }
  }

  @override
  Future<String> removeFromFavourites(String userCode) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/users/account/${userCode}/unfollow/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return response.data['status'];
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<String> addToBlacklist(String userCode) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/users/account/${userCode}/blacklist/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return response.data['status'];
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<String> removeFromBlacklist(String userCode) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/users/account/${userCode}/unblacklist/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return response.data['status'];
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<List<User>> fetchFavourites({int page = 1}) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.get(
        'api/v1/users/account/following/?page=$page',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      // Decode the JSON response
      List<dynamic> responseList =
          response.data['results']; // Dio directly gives JSON-decoded response
      var users = responseList.map((data) => User.fromJson(data)).toList();

      // Map the response to User objects
      return users;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(e);
    }
  }

  @override
  Future<String> acceptRequest(int requestId) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/requests/acceptance_requests/$requestId/accept_request/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      if (response.data is Map<String, dynamic>) {
        return "تم قبول الطلب";
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode != null && e.response?.statusCode == 403) {
        throw Customexception("حسابك غير مفعل بعد, انتظر تفعيله من الإدارة");
      }
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<String> rejectRequest(int requestId) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/requests/acceptance_requests/$requestId/reject_request/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      return response.data['status'];
    } on DioException catch (e) {
      if (e.response?.statusCode != null && e.response?.statusCode == 403) {
        throw Customexception("حسابك غير مفعل بعد, انتظر تفعيله من الإدارة");
      }
      throw Exception(e.response?.data.toString());
    }
  }

  @override
  Future<String> setOnline() async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/profiles/set-online/',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      if (response.data is Map<String, dynamic>) {
        return "أنت متصل";
      }
      return response.data;
    } on DioException catch (e) {
      throw Customexception((e.response?.data['error'].toString()) ?? '...');
    }
  }

  @override
  Future<String> setOffline() async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/profiles/set-offline/',
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );
      if (response.data is Map<String, dynamic>) {
        return "أنت غير متصل";
      }
      return response.data;
    } on DioException catch (e) {
      throw Customexception((e.response?.data['error'].toString()) ?? '...');
    }
  }

  @override
  Future<UserDetails> fetchCurrentUser() async {
    String? token = prefs.getString('auth_token');

    try {
      final response = await httpClient.get(
        'api/v1/users/account/me/',
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );

      return UserDetails.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserDetails> modifyUser(ProfileChangeEntity pce) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.put(
        'api/v1/users/account/modify/',
        data: pce.toJson(),
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );
      // print(response.data);
      return UserDetails.fromJson(response.data);
    } on DioException catch (e) {
      throw Customexception(
          e.response?.data.values.first[0].toString() ?? 'حصل خطأ');
    }
  }
}
