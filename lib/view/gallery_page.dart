import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixabay/utility/log.dart';
import 'package:pixabay/view/state/gallery_controller.dart';
import 'package:pixabay/view/widget/img_grid_item.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  var _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GalleryController>(context, listen: false).loadImages('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PixaBay Gallery'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLargeScreen = constraints.maxWidth > 600;
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isLargeScreen ? 250 : 20, vertical: 20),
                child: _buildSearchBar(),
              );
            },
          ),
        ),
      ),
      body: Consumer<GalleryController>(
        builder: (context, model, child) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                // page++;
                // _loadImages('', page);
                model.loadImages(_searchController.text.toString().trim());
              }
              return true;
            },
            child: Column(
              children: [
                Expanded(
                  child: model.dataList.isEmpty
                      ? const Center(child: Text('No Data Found'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: _layoutDelegate(context),
                          itemCount: model.dataList.length,
                          itemBuilder: (context, index) {
                            final item = model.dataList[index];
                            return ImageGridItemWidget(item: item);
                          },
                        ),
                ),
                if (model.isLoading) _buildLoaderView(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoaderView() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SpinKitThreeBounce(color: Colors.blue, size: 25),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
        controller: _searchController,
        onChanged: (value) =>
            Provider.of<GalleryController>(context, listen: false)
                .onSearchChanged(value),
        decoration: InputDecoration(
            hintText: "Search for all images on Pixabay",
            contentPadding: EdgeInsets.zero,
            alignLabelWithHint: true,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: Image.asset('assets/img/search_icon.png',
                    color: Colors.green, height: 40, width: 20)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50))));
  }

  _layoutDelegate(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount =
        (isLandscape ? (screenWidth / 300) : (screenWidth / 200)).floor();

    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10);
  }

  @override
  void dispose() {
    // _debounce?.cancel();
    super.dispose();
  }
}
