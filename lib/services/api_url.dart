import '../config/app_config.dart';

class ApiUrl {
  static String get _baseUrl => AppConfig.baseUrl;

  static String volumes(String query, int startIndex, {int maxResults = 20}) {
    final encoded = Uri.encodeComponent(query);
    return '$_baseUrl/volumes?q=$encoded&startIndex=$startIndex&maxResults=$maxResults&key=${AppConfig.apiKey}';
  }
}
