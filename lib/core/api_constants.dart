import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String baseUrl = 'https://pixabay.com/api/';
  static const String apiKey = '13599619-ffa1903916db893185fc12824';

  static const String imgType = 'all';
  static const int perPage = 4;
  static const bool isPretty = kDebugMode ? true : false;
}
