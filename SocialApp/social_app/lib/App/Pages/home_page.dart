import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/App/Widgets/search_bar_widget.dart';
import 'package:social_app/app/widgets/feed_tab.dart';
import 'package:social_app/app/widgets/gradient_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final List<String> tabTitles = ['Popular', 'Trending', 'Following'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SearchBarWidget(
                      controller: _searchController,
                      hintText: 'Search',
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {},
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFFF1F1FE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelColor: Colors.black,
                  unselectedLabelColor: const Color(0xFFBDBDBD),
                  dividerColor: Colors.transparent,
                  tabs:
                      tabTitles.map((title) {
                        return Tab(
                          child: GradientTab(
                            text: title,
                            tabController: _tabController,
                            index: tabTitles.indexOf(title),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FeedTab(), // Popular
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
