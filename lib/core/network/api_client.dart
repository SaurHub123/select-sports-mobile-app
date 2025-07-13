import 'package:dio/dio.dart';
import 'package:select_sports/core/constants/shared_preferences_keys.dart';
import './shared_preferences_helper.dart';

class ApiClient {
  final String _baseUrl;
  final Dio _dio;

  ApiClient({required String baseUrl})
      : _baseUrl = baseUrl,
        _dio = Dio(BaseOptions(
          validateStatus: (status) {
            return status! <
                500; // Allow handling status codes less than 500, including 402
          },
        )) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }

  Future<Response> post(String endpoint, dynamic data) async {
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> patch(String endpoint, dynamic data) async {
    return await _dio.patch(endpoint, data: data);
  }

  Future<Response> authorizedGet(String endpoint) async {
    return await _dio.get(
      endpoint,
      options: Options(headers: await _buildHeaders(authorized: true)),
    );
  }

  Future<Response> authorizedPost(String endpoint, dynamic data) async {
    print(endpoint);
    return await _dio.post(
      endpoint,
      data: data,
      options: Options(headers: await _buildHeaders(authorized: true)),
    );
  }

  Future<Response> authorizedPatch(String endpoint, dynamic data) async {
    return await _dio.patch(
      endpoint,
      data: data,
      options: Options(headers: await _buildHeaders(authorized: true)),
    );
  }

  Future<Response> authorizedDelete(String endpoint) async {
    return await _dio.delete(
      endpoint,
      options: Options(headers: await _buildHeaders(authorized: true)),
    );
  }

  Future<Map<String, String>> _buildHeaders({bool authorized = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (authorized) {
      final token =
          await SharedPreferencesHelper.get(SharedPreferencesKeys.authToken);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        throw Exception("Authorization token not found");
      }
    }
    return headers;
  }
}
