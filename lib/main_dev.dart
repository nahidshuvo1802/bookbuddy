import 'package:flutter/material.dart';
import 'app.dart';
import 'config/app_initializer.dart';

void main() async {
  await AppInitializer.init(
    baseUrl: 'https://www.googleapis.com/books/v1',
    appName: 'BookBuddy Dev',
    apiKeyEnvVar: 'API_KEY_DEV',
  );

  runApp(const App());
}
