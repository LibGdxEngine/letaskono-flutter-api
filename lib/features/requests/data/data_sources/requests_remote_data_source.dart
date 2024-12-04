import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:letaskono_flutter/features/requests/data/models/AcceptanceRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/http_client.dart';
import '../models/request_type.dart';

abstract class RequestsRemoteDataSource {
  Future<List<AcceptanceRequest>> fetchRequests();
}

class RequestsRemoteDataSourceImpl extends RequestsRemoteDataSource {
  final HttpClient httpClient;
  final SharedPreferences prefs;

  RequestsRemoteDataSourceImpl({required this.httpClient, required this.prefs});

  @override
  Future<List<AcceptanceRequest>> fetchRequests() async {
    String? token = prefs.getString('auth_token');

    try {
      // Make two simultaneous requests
      final responses = await Future.wait([
        httpClient.get(
          'api/v1/requests/acceptance_requests/sent_requests/',
          headers: {
            "Authorization": "Token ${token}",
            "Content-Type": "application/json",
          },
        ),
        httpClient.get(
          'api/v1/requests/acceptance_requests/received_requests/',
          headers: {
            "Authorization": "Token ${token}",
            "Content-Type": "application/json",
          },
        ),
      ]);

      // Decode the responses
      final List<dynamic> sentResponse = responses[0].data;
      final List<dynamic> receivedResponse = responses[1].data;

      // Map the JSON responses to AcceptanceRequest objects
      final List<AcceptanceRequest> sentRequests = sentResponse
          .map((data) => AcceptanceRequest.fromJson(data, RequestType.sent))
          .toList();
      final List<AcceptanceRequest> receivedRequests = receivedResponse
          .map((data) => AcceptanceRequest.fromJson(data, RequestType.received))
          .toList();
      // Combine the two lists and return
      return [...sentRequests, ...receivedRequests];
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
