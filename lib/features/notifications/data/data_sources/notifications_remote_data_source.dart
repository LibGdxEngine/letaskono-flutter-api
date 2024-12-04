import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/http_client.dart';
import '../models/notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<Notification>> fetchNotifications({int page = 1});
}

class NotificationRemoteDataSourceImpl extends NotificationRemoteDataSource {
  final HttpClient httpClient;
  final SharedPreferences prefs;

  NotificationRemoteDataSourceImpl(
      {required this.httpClient, required this.prefs});

  @override
  Future<List<Notification>> fetchNotifications({int page = 1}) async {
    String? token = prefs.getString('auth_token');
    try {
      // Append the page parameter to the URL
      final response = await httpClient.get(
        'api/v1/notifications/notifications/?page=$page',
        headers: {
          "Authorization": "Token ${token}",
          "Content-Type": "application/json",
        },
      );

      List<dynamic> responseList = response.data['results'];
      return responseList.map((data) => Notification.fromJson(data)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception(e);
    }
  }
}
