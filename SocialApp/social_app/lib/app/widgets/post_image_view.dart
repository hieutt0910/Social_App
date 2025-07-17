import 'package:flutter/material.dart';
import 'package:social_app/app/utils/assets_manage.dart';

class PostImagesViewer extends StatefulWidget {
  final List<String> imageUrls;
  const PostImagesViewer({super.key, required this.imageUrls});

  @override
  State<PostImagesViewer> createState() => _PostImagesViewerState();
}

class _PostImagesViewerState extends State<PostImagesViewer> {
  late final PageController _pageController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.length == 1) {
      return AssetsManager.showImage(
        widget.imageUrls.first,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder:
                (_, i) => AssetsManager.showImage(
                  widget.imageUrls[i],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
          ),
        ),
        // Dots indicator
        Positioned(
          bottom: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _index ? Colors.white : Colors.white54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
