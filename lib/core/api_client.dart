import 'package:dio/dio.dart';
import 'package:pixabay/core/api_constants.dart';

class ApiClient {
  final Dio _dio = Dio();

  Dio init() {
    configureDio();
    return _dio;
  }

  void configureDio() {
    final options = BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        // connectTimeout: const Duration(seconds: 5),
        // receiveTimeout: const Duration(seconds: 3),
        queryParameters: {
          'key': ApiConstants.apiKey,
          'pretty': ApiConstants.isPretty,
          'per_page': ApiConstants.perPage
        });

    _dio.interceptors.add(LogInterceptor(request: true, error: true));
    _dio.options = options;
  }
}
