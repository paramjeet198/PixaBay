import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pixabay/data/pixa_bay_response.dart';
import 'package:pixabay/utility/log.dart';

class PixaBayDataSource {
  final Dio dio;

  PixaBayDataSource({required this.dio});

  Future<PixaBayResponse> getImages(
      {required String query, required int page}) async {

    await Future.delayed(const Duration(seconds: 1));
    Map<String, dynamic> params = {'q': query, 'page': page};

    try {
      final apiResponse = await dio.get('', queryParameters: params);
      if (apiResponse.statusCode! >= 200 && apiResponse.statusCode! < 300) {
        final res = json.decode(apiResponse.toString()) as Map<String, dynamic>;
        return PixaBayResponse.fromJson(res);
      } else {
        throw Exception(
            'API request failed with status code: ${apiResponse.statusCode}');
      }
    } catch (e) {
      Log.v('Error: ${e.toString()}');
      rethrow;
    }
  }
}
