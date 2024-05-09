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

  @override
  void initState() {
    super.initState();
    dio = ApiClient().init();
    _fetchImages('');
  }

  Future<void> _fetchImages(String query) async {
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
                decoration: InputDecoration(hintText: "Search Images...")),
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

  Widget _buildWebItem({required Hits item}) {
    hoverNotifier.value = item;

    return MouseRegion(
        // cursor: MouseCursor.defer,
        onHover: (event) {
          hoverNotifier.value?.isHovering = true;
        },
        onExit: (event) {
          hoverNotifier.value?.isHovering = false;
        },
        child: ImageGridItemWidget(item: item));
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
    hoverNotifier.dispose();
    super.dispose();
  }
}
