class AppConfig {
  static late String baseUrl;
  static late String appName;
  static late String apiKey;

  static void init({
    required String baseUrl,
    required String appName,
    required String apiKey,
  }) {
    AppConfig.baseUrl = baseUrl;
    AppConfig.appName = appName;
    AppConfig.apiKey = apiKey;
  }
}
