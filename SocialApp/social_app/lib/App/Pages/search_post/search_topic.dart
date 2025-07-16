import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/widgets/search_bar_with_cancel.dart';
import 'package:social_app/app/widgets/topic_card.dart';

class SearchTopic extends StatelessWidget {
  const SearchTopic({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Column(
          children: [
            SearchBarWithCancel(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: titlesTopic.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap:
                            () => context.push(
                              '/hashtag-posts',
                              extra: titlesTopic[index].toLowerCase(),
                            ),
                        child: TopicCard(
                          imagePath: imageTopicPaths[index],
                          overlayImagePath: "assets/images/card-background.jpg",
                          title: titlesTopic[index],
                          alignLeft: index.isEven,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
