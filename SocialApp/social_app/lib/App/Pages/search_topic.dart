import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/app/widgets/search_bar_widget.dart';

class SearchTopic extends StatelessWidget {
  const SearchTopic({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: SearchBarWidget(
                  controller: searchController,
                  hintText: 'Search',
                  onChanged: (value) {
                    debugPrint('Search input: $value');
                  },
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  debugPrint('Send button pressed!');
                  // Ví dụ nếu dùng go_router:
                  // context.go('/search-result');
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
      ),
    );
  }
}
