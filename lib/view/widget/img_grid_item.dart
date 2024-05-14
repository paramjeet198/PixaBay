import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/pixa_bay_response.dart';

class ImageGridItemWidget extends StatefulWidget {
  final Hits item;
  static const double borderRadius = 10;

  const ImageGridItemWidget({required this.item, super.key});

  @override
  State<ImageGridItemWidget> createState() => _ImageGridItemWidgetState();
}

class _ImageGridItemWidgetState extends State<ImageGridItemWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: Tooltip(
        message: '${widget.item.tags}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ImageGridItemWidget.borderRadius),
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                _buildImage(item: widget.item),
                _buildHoverEffect(isHover: isHover),
                _buildMetaDataView(item: widget.item),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage({required final Hits item}) {
    return CachedNetworkImage(
        imageUrl: item.largeImageURL!,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Container(color: Colors.amberAccent,);
        },
        placeholderFadeInDuration: const Duration(milliseconds: 0),
        fadeOutDuration: const Duration(milliseconds: 0),
        height: double.infinity,
        width: double.infinity);
  }

  Widget _buildMetaDataView({required final Hits item}) {
    return Positioned(
        bottom: 8.0,
        left: 8.0,
        child: Row(
          children: [
            const Icon(Icons.favorite, size: 16.0, color: Colors.red),
            const SizedBox(width: 4),
            Text(item.likes.toString(),
                style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 15),
            const Icon(
              Icons.remove_red_eye,
              size: 16.0,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(item.views.toString(),
                style: const TextStyle(color: Colors.white)),
          ],
        ));
  }

  Widget _buildHoverEffect({required bool isHover}) {
    return kIsWeb
        ? Container(
            decoration: BoxDecoration(
              color: isHover
                  ? Colors.black.withOpacity(0.8)
                  : Colors.black.withOpacity(0.3),
              borderRadius:
                  BorderRadius.circular(ImageGridItemWidget.borderRadius),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius:
                  BorderRadius.circular(ImageGridItemWidget.borderRadius),
            ),
          );
  }
}
