import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:letaskono_flutter/core/utils/CustomException.dart';
import 'package:letaskono_flutter/features/requests/data/models/AcceptanceRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/http_client.dart';
import '../models/request_type.dart';

abstract class RequestsRemoteDataSource {
  Future<List<AcceptanceRequest>> fetchRequests({required int page});
}

class RequestsRemoteDataSourceImpl extends RequestsRemoteDataSource {
  final HttpClient httpClient;
  final SharedPreferences prefs;

  RequestsRemoteDataSourceImpl({required this.httpClient, required this.prefs});

  @override
  Future<List<AcceptanceRequest>> fetchRequests({int page = 1}) async {
    String? token = prefs.getString('auth_token');

    try {
      // Make two simultaneous requests with individual error handling
      final responses = await Future.wait(
        [
          _fetchRequests(
            'api/v1/requests/acceptance_requests/sent_requests/?page=$page',
            token,
            RequestType.sent,
          ),
          _fetchRequests(
            'api/v1/requests/acceptance_requests/received_requests/?page=$page',
            token,
            RequestType.received,
          ),
        ],
        eagerError: false, // Ensure that all futures complete even if one fails
      );

      // Combine and return the results
      return responses.expand((list) => list).toList();
    } on DioException catch (e) {
      if(e.response?.statusCode != null && e.response?.statusCode == 403){
        throw Customexception("حسابك غير مفعل بعد, انتظر تفعيله من الإدارة");
      }
      throw Exception(e);
    }
  }

  // Helper function to handle individual requests
  Future<List<AcceptanceRequest>> _fetchRequests(
    String url,
    String? token,
    RequestType requestType,
  ) async {
    try {
      final response = await httpClient.get(
        url,
        headers: {
          "Authorization": "Token $token",
          "Content-Type": "application/json",
        },
      );

      final List<dynamic> results = response.data['results'];
      return results
          .map((data) => AcceptanceRequest.fromJson(data, requestType))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Return an empty list if the response is 404
        return [];
      }
      rethrow; // Re-throw other exceptions
    }
  }
}
