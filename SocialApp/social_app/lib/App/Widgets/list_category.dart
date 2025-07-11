import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/utils/assets_manage.dart';

class ListCategory extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> titles;
  final double height;
  final double cardWidth;

  const ListCategory({
    super.key,
    required this.imageUrls,
    required this.titles,
    this.height = 200,
    this.cardWidth = 150,
  }) : assert(
         imageUrls.length == titles.length,
         'Image and title count must match',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.fromLTRB(16, 10, 0, 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push('/search-topic');
            },
            child: SizedBox(
              width: cardWidth,

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AssetsManager.showImage(
                      imageUrls[index],
                      height: height,
                      width: cardWidth,
                    ),
                    Container(color: Colors.black.withOpacity(0.4)),
                    Center(
                      child: Container(
                        child: Text(
                          titles[index],
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
