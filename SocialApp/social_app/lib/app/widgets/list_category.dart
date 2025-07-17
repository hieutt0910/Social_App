import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/utils/assets_manage.dart';

class ListCategory extends StatelessWidget {
  final List<String> imageUrls;
  final List<String> titles;
  final double height;
  final double cardWidth;

  final bool isCollection;

  const ListCategory({
    super.key,
    required this.imageUrls,
    required this.titles,
    this.height = 200,
    this.cardWidth = 150,
    this.isCollection = false,
  }) : assert(
         imageUrls.length == titles.length,
         'Image and title count must match',
       );

  @override
  Widget build(BuildContext context) {
    final rnd = Random();

    return Container(
      height: height + (isCollection ? 30 : 0),
      margin: const EdgeInsets.fromLTRB(16, 10, 0, 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final count = 10 + rnd.nextInt(31);

          return GestureDetector(
            onTap:
                () => context.push(
                  '/hashtag-posts',
                  extra: titles[index].toLowerCase(),
                ),
            child: SizedBox(
              width: cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height,
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
                          Container(
                            color: const Color(0x80333333),
                          ), // #33333380
                          Center(
                            child: Text(
                              titles[index],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isCollection) ...[
                    const SizedBox(height: 4),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '$count photos',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF828282),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
