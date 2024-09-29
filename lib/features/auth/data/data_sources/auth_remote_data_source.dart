// lib/features/auth/data/data_sources/auth_remote_data_source_impl.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../core/network/http_client.dart';
import '../errors/AuthException.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(
      String firstName, String lastName, String email, String password);

  Future<void> confirmAccount(String code);

  Future<void> submitProfile(UserModel userProfile);

  Future<UserModel> getUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<void> signUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final response = await httpClient.post(
        'api/v1/users/signup/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        },
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        throw AuthException('Failed to sign up');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> confirmAccount(String code) async {
    try {
      final response = await httpClient.post(
        'api/v1/users/activate/',
        data: {'code': code},
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        throw AuthException('Confirmation failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> submitProfile(UserModel userProfile) async {
    try {
      final response = await httpClient.post(
        '/auth/submit-profile',
        data: userProfile.toJson(),
      );

      if (response.statusCode != 200) {
        throw AuthException('Failed to submit profile');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw AuthException(
            'Profile submission failed: ${e.response?.data['message']}');
      } else {
        throw AuthException('Profile submission failed: ${e.message}');
      }
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      final response = await httpClient.get('/auth/user');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw AuthException('Failed to load user data');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw AuthException(
            'Failed to get user data: ${e.response?.data['message']}');
      } else {
        throw AuthException('Failed to get user data: ${e.message}');
      }
    }
  }

  bool _isSuccessStatusCode(int? statusCode) {
    return statusCode != null && (statusCode >= 200 && statusCode < 300);
  }

  Exception _handleError(DioError e) {
    if (e.response != null && e.response?.data is Map<String, dynamic>) {
      print('Hello');
      // Server error with a response and proper structure
      final Map<String, dynamic> errorData = e.response!.data;

      final String firstKey = errorData.keys.first;

      final dynamic firstErrorMessages = errorData[firstKey];
      if (firstErrorMessages is String) {
        return AuthException('${firstKey}: ${firstErrorMessages}');
      } else if (firstErrorMessages is List<dynamic>) {
        return AuthException('${firstKey}: ${firstErrorMessages.first}');
      }
      return AuthException(e.response?.data);
    } else {
      // Network or other types of Dio errors
      return AuthException('Signup failed: ${e.message}');
    }
  }
}
