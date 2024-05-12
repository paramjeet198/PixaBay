import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixabay/utility/log.dart';
import 'package:pixabay/view/state/value_notifier.dart';
import 'package:pixabay/view/widget/img_grid_item.dart';

import '../core/api_client.dart';
import '../data/data_source.dart';
import '../data/pixa_bay_response.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late final Dio dio;
  List<Hits> dataList = [];

  Timer? _debounce;
  final Duration _debounceDuration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    dio = ApiClient().init();
    _fetchImages('');
  }

  Future<void> _onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(_debounceDuration, () async {
      await _fetchImages(query);
    });
  }

  Future<void> _fetchImages(String query) async {
    Log.v('_fetchImages: $query');

    PixaBayResponse response =
        await PixaBayDataSource(dio: dio).getImages(query: query);
    dataList = response.hits!;
    Log.v('Size: ${dataList.length}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 250),
            child: TextField(
                onChanged: (value) => _onSearchChanged(value),
                decoration: InputDecoration(
                    hintText: "Search for all images on Pixabay",
                    contentPadding: EdgeInsets.zero,
                    alignLabelWithHint: true,
                    hintStyle:
                        const TextStyle(fontSize: 13, color: Colors.grey),
                    prefixIcon:  Padding(
                      padding: const EdgeInsets.only(left: 20,right: 5),
                      child: Image.asset('assets/img/search_icon.png',color: Colors.green,height: 40,width: 20,),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)))),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels == notification.metrics.extentAfter) {
            // _loadMoreImages();
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(30),
          gridDelegate: _layoutDelegate(context),
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final item = dataList[index];
            return ImageGridItemWidget(item: item);
          },
        ),
      ),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _layoutDelegate(
      BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 300).floor(),
        childAspectRatio: 1.5,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
