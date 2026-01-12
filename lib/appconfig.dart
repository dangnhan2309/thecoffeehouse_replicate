class AppConfig {
  static const bool isDev = false;
  static const String devBaseUrl = 'http://10.0.2.2:8000';
  static const String prodBaseUrl = 'http://localhost:8000';

  static String get baseUrl => isDev ? devBaseUrl : prodBaseUrl;
}
