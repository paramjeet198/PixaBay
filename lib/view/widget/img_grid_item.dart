import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixabay/utility/log.dart';
import 'package:pixabay/view/state/value_notifier.dart';

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
      child: ValueListenableBuilder<Hits?>(
        valueListenable: hoverNotifier,
        builder: (BuildContext context, Hits? value, Widget? child) {
          return ClipRRect(
            borderRadius:
                BorderRadius.circular(ImageGridItemWidget.borderRadius),
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
          );
        },
      ),
    );
  }

  Widget _buildImage({required final Hits item}) {
    return Image.network(
      item.largeImageURL!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
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
                  ? Colors.black.withOpacity(0.7)
                  : Colors.black.withOpacity(0.2),
              borderRadius:
                  BorderRadius.circular(ImageGridItemWidget.borderRadius),
            ),
          )
        : const SizedBox.shrink();
  }
}
