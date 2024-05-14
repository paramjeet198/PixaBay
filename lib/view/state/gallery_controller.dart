import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pixabay/utility/de_bouncer.dart';
import 'package:pixabay/utility/log.dart';

import '../../core/api_client.dart';
import '../../data/data_source.dart';
import '../../data/pixa_bay_response.dart';

class GalleryController extends ChangeNotifier {

  final Dio _dio = ApiClient().init();
  final List<Hits> _dataList = [];
  int _page = 1;
  bool _isLoading = false;

  List<Hits> get dataList => _dataList;

  bool get isLoading => _isLoading;

  Future<void> loadImages(String query) async {
    _page++;
    _isLoading = true;
    notifyListeners();

    try {
      PixaBayResponse response = await PixaBayDataSource(dio: _dio)
          .getImages(query: query, page: _page);
      _dataList.addAll(response.hits!);
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onSearchChanged(String query) async {
    EasyDebounce.debounce(
        tag: 'onSearchChanged',
        duration: const Duration(seconds: 1),
        callBack: () async {
          PixaBayResponse response = await PixaBayDataSource(dio: _dio)
              .getImages(query: query, page: 1);
          _dataList.clear();
          _dataList.addAll(response.hits!);
          notifyListeners();
        });

    Log.v(EasyDebounce().toString());
  }
}
