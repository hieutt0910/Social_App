import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_app/App/Widgets/gradient_text.dart';
import 'package:social_app/App/Widgets/post_widget.dart';
import 'package:social_app/App/Widgets/search_bar_widget.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                        child: _GradientTab(
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
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Center(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return PostWidget();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                    ),
                  ),
                  Center(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return PostWidget();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                    ),
                  ),
                  Center(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return PostWidget();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientTab extends StatefulWidget {
  final String text;
  final TabController tabController;
  final int index;

  const _GradientTab({
    required this.text,
    required this.tabController,
    required this.index,
  });

  @override
  State<_GradientTab> createState() => _GradientTabState();
}

class _GradientTabState extends State<_GradientTab> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.tabController.index == widget.index;

    return Center(
      child:
          isSelected
              ? GradientText(text: widget.text,fontSize: 16,)
              : Text(
                widget.text,
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
    );
  }
}
