import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_config.dart';
import '../models/book.dart';

class AppInitializer {
  static Future<void> init({
    required String baseUrl,
    required String appName,
    required String apiKeyEnvVar,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    await Hive.initFlutter();
    Hive.registerAdapter(BookAdapter());
    await Hive.openBox<Book>('favorites');

    AppConfig.init(
      baseUrl: baseUrl,
      appName: appName,
      apiKey: dotenv.env[apiKeyEnvVar] ?? '',
    );
  }
}
