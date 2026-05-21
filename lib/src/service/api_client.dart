import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiClient {
  final _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<http.Response> get(String path) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    debugPrint('DEBUG: GET $url');
    return await _client.get(
      url,
      headers: ApiConfig.headers(token),
    );
  }

  Future<http.Response> post(String path, {dynamic body}) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    debugPrint('DEBUG: POST $url');
    debugPrint('DEBUG: Body: ${jsonEncode(body)}');
    return await _client.post(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, {dynamic body}) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    debugPrint('DEBUG: PUT $url');
    return await _client.put(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String path, {dynamic body}) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    debugPrint('DEBUG: PATCH $url');
    return await _client.patch(
      url,
      headers: ApiConfig.headers(token),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    debugPrint('DEBUG: DELETE $url');
    return await _client.delete(
      url,
      headers: ApiConfig.headers(token),
    );
  }
}
