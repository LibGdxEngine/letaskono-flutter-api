import 'package:dio/dio.dart';
import 'package:letaskono_flutter/core/utils/constants.dart';

class HttpClient {
  final Dio dio;

  HttpClient({required this.dio}) {
    dio.options.baseUrl =
        'http://${Constants.baseUrl}:8000/'; // Set your API base URL
    dio.options.connectTimeout =
        const Duration(seconds: 5); // 5 seconds timeout
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.sendTimeout = const Duration(seconds: 4);

    // Set default headers
    dio.options.headers = {
      'Content-Type': 'application/json', // Set default content type
    };
  }

  // GET request with optional headers
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    return await dio.get(url,
        queryParameters: queryParameters, options: Options(headers: headers));
  }

  // POST request with optional headers
  Future<Response> post(String url,
      {Map<String, dynamic>? data, Map<String, dynamic>? headers}) async {
    return await dio.post(url, data: data, options: Options(headers: headers));
  }

  // PUT request with optional headers
  Future<Response> put(String url,
      {Map<String, dynamic>? data, Map<String, dynamic>? headers}) async {
    return await dio.put(url, data: data, options: Options(headers: headers));
  }

  // DELETE request with optional headers
  Future<Response> delete(String url, {Map<String, dynamic>? headers}) async {
    return await dio.delete(url, options: Options(headers: headers));
  }
}
