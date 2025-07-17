import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/app/widgets/search_bar_widget.dart';
import 'package:social_app/app/widgets/category_type.dart';
import 'package:social_app/app/widgets/list_category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    final imageTopicPaths = [
      'assets/images/topic_photography.png',
      'assets/images/topic_uidesign.png',
      'assets/images/topic_illustration.png',
      'assets/images/topic_travel.png',
    ];
    final List<String> imageCollectionPaths = [
      'assets/images/collection_background.png',
      'assets/images/collection_background.png',
      'assets/images/collection_background.png',
      'assets/images/collection_background.png',
    ];
    final titlesTopic = ['PHOTOGRAPHY', 'UI DESIGN', 'ILLUSTRATION', 'TRAVEL'];
    final titlesCollection = [
      'PORTRAIT PHOTOGRAPHY',
      'MUSIC VIDEO',
      'FASHION EDITORIAL',
      'SHORT FILM',
    ];
    final titlesCommunity = [
      'STREET STYLE',
      'DAILY LIFE',
      'FOOD & COFFEE',
      'EVENT & FESTIVAL',
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBarWidget(
                      controller: searchController,
                      hintText: 'Search',
                      onChanged: (v) => debugPrint('Search input: $v'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => debugPrint('Send button pressed!'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F5F7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/send.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            CategoryType(nameCategory: 'Topic'),
            ListCategory(
              imageUrls: imageTopicPaths,
              titles: titlesTopic,
              height: 100,
              cardWidth: 150,
            ),

            CategoryType(nameCategory: 'Community'),
            ListCategory(
              imageUrls: imageCollectionPaths,
              titles: titlesCommunity,
              height: 158,
              cardWidth: 158,
            ),
            CategoryType(nameCategory: 'Collection'),
            ListCategory(
              imageUrls: imageCollectionPaths,
              titles: titlesCollection,
              height: 158,
              cardWidth: 158,
              isCollection: true,
            ),
          ],
        ),
      ),
    );
  }
}
