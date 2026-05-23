import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static final _client = http.Client();

  static Future<Map<String, dynamic>> get(String url) async {
    const maxRetries = 3;
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await _client
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          return json.decode(response.body);
        }

        if (response.statusCode == 429 && attempt < maxRetries) {
          await Future.delayed(Duration(seconds: (attempt + 1) * 2));
          continue;
        }

        throw ApiException('Server error: ${response.statusCode}');
      } on SocketException {
        throw ApiException('No internet connection');
      } on FormatException {
        throw ApiException('Bad response format');
      } catch (e) {
        if (e is ApiException) rethrow;
        if (attempt == maxRetries) {
          throw ApiException('Request timeout. Please try again.');
        }
      }
    }
    throw ApiException('Request failed after retries.');
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
