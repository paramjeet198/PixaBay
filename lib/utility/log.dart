import 'package:flutter/foundation.dart';

class Log {
  static void v(dynamic data) {
    if (kDebugMode) {
      print('$data');
    }
  }
}
