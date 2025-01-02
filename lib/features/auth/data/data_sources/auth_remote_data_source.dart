// lib/features/auth/data/data_sources/auth_remote_data_source_impl.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:letaskono_flutter/core/utils/CustomException.dart';
import 'package:letaskono_flutter/features/auth/data/errors/SignUpException.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../../core/network/http_client.dart';
import '../errors/AuthException.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(
      String firstName, String lastName, String email, String password);

  Future<String> signIn(String email, String password);

  Future<void> passwordReset(String email);

  Future<void> passwordVerify(String code, String newPassword);

  Future<void> confirmAccount(String code);

  Future<void> completeProfile(Map<String, dynamic> profileCompletionAsJson);

  Future<UserModel> getUserData();

  Future<String> resendActivationCode(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient httpClient;
  final SharedPreferences prefs;

  AuthRemoteDataSourceImpl({required this.httpClient, required this.prefs});

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
        throw AuthException('فشل تسجيل الحساب');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> confirmAccount(String code) async {
    try {
      final response = await httpClient.get(
        'api/v1/users/account-activate/?code=$code',
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        throw AuthException('Confirmation failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> completeProfile(
      Map<String, dynamic> profileCompletionAsJson) async {
    try {
      String? token = prefs.getString("auth_token");
      final response = await httpClient.post(
        'api/v1/users/complete-profile/',
        data: profileCompletionAsJson,
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode != 200) {
        throw AuthException('Failed to submit profile');
      }
    } on DioException catch (e) {
      throw _handleError(e);
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
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    try {
      final response = await httpClient.post(
        'api/v1/users/login/',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (!_isSuccessStatusCode(response.statusCode)) {
        throw AuthException('Login failed');
      }
      Map<String, dynamic> responseMap = jsonDecode(response.toString());

      return responseMap['token'];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  bool _isSuccessStatusCode(int? statusCode) {
    return statusCode != null && (statusCode >= 200 && statusCode < 300);
  }

  Exception _handleError(DioException e) {
    if (e.response != null && e.response?.data is Map<String, dynamic>) {
      // Server error with a response and proper structure
      final Map<String, dynamic> errorData = e.response!.data;

      final String firstKey = errorData.keys.first;
      final dynamic firstErrorMessages = errorData[firstKey];

      if (firstErrorMessages is String) {
        return AuthException(firstErrorMessages);
      } else if (firstErrorMessages is List<dynamic>) {
        if (firstErrorMessages.first.toString().contains("Enter a valid")) {
          return AuthException('هذا البريد غير صحيح');
        }
        if (firstErrorMessages.first.toString().contains("The phone number")) {
          return AuthException(
              'رقم الهاتف الذي أدخلته غير صالح, أدخل رقما صحيحا');
        }
        return AuthException('${firstErrorMessages.first}');
      } else if (firstErrorMessages is Map<String, dynamic>) {
        if (firstErrorMessages.values.first[0]
            .toString()
            .contains("user with this email address already exists")) {
          return AuthException('هذا الحساب مسجل بالفعل, جرب تسجيل الدخول');
        }
        if (firstErrorMessages.keys.contains("password")) {
          return AuthException(
              'كلمة السر سهلة التخمين للغاية, اختر كلمة سر أقوى');
        }
        return SignupException('${firstErrorMessages.values.first[0]}',
            errorData['is_email_confirmed']);
      }

      return AuthException(e.response!.data);
    } else {
      // Network or other types of Dio errors
      return AuthException('Failed: ${e.message}');
    }
  }

  @override
  Future<void> passwordReset(String email) async {
    try {
      final response = await httpClient.post(
        'api/v1/users/password-reset/',
        data: {
          'email': email,
        },
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        throw AuthException('Request failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> passwordVerify(String code, String newPassword) async {
    try {
      final response = await httpClient.post(
        'api/v1/users/password-reset-verify/',
        data: {
          'code': code,
          'new_password': newPassword,
        },
      );

      if (!_isSuccessStatusCode(response.statusCode)) {
        throw AuthException('Request failed');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<String> resendActivationCode(String email) async {
    String? token = prefs.getString('auth_token');
    try {
      final response = await httpClient.post(
        'api/v1/users/resend-activation-code/',
        data: {"email": email},
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );
      return response.data['detail'];
    } on DioException catch (e) {
      final firstKey = e.response?.data.keys.first;
      throw Customexception((e.response?.data[firstKey][0].toString()) ?? '...');
    }
  }
}
