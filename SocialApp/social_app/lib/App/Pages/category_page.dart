import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/App/Widgets/search_bar_widget.dart';
import 'package:social_app/app/widgets/category_type.dart';
import 'package:social_app/app/widgets/list_category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final List<String> imageTopicPaths = [
      'assets/images/topic_photography.png',
      'assets/images/topic_uidesign.png',
      'assets/images/topic_illustration.png',
      'assets/images/topic_travel.png',
    ];
    final List<String> titlesTopic = [
      'PHOTOGRAPHY',
      'UI DESIGN',
      'ILLUSTRATION',
      'TRAVEL',
    ];
    final List<String> titlesCollection = [
      'PORTRAIT PHOTOGRAPHY',
      'MUSIC VIDEO',
      'FASHION EDITORIAL',
      'SHORT FILM',
    ];
    final List<String> titlesCommunity = [
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SearchBarWidget(
                    controller: searchController,
                    hintText: 'Search',
                    onChanged: (value) {
                      print('Search input: $value');
                    },
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    print('Send button pressed!');
                  },
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
          Column(
            children: [
              CategoryType(nameCategory: 'Topic'),
              ListCategory(
                imageUrls: imageTopicPaths,
                titles: titlesTopic,
                height: 100,
                cardWidth: 150,
              ),
              CategoryType(nameCategory: 'Collection'),
              ListCategory(
                imageUrls: imageTopicPaths,
                titles: titlesCollection,
                height: 158,
                cardWidth: 158,
              ),
              CategoryType(nameCategory: 'Community'),
              ListCategory(
                imageUrls: imageTopicPaths,
                titles: titlesCommunity,
                height: 158,
                cardWidth: 158,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
