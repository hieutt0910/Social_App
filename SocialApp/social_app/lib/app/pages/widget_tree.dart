import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/App/pages/category_page.dart';
import 'package:social_app/App/pages/home_page.dart';
import 'package:social_app/App/pages/profile/profile_screen.dart';
import 'package:social_app/App/Widgets/bottom_navigation.dart';
import 'package:social_app/App/Widgets/navbar_icon.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int _pageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CategoryPage(),
    Center(child: Text('Trang 3')),
    AccountPage(),
  ];
  @override
  void initState() {
    _pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: _pageIndex, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF888BF4), Color(0xFF5151C6)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: NavBarIcon(
          assetPathSelected: "assets/icons/add.svg",
          assetPathUnSelected: "assets/icons/add.svg",
          isSelected: true,
          onTap: () {
            context.push('/create-post');
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _pageIndex,
        onItemTapped: (index) {
          setState(() {
            _pageIndex = index;
          });
          if (index == 0) {
            context.read<PostBloc>().add(PostFetchRequested());
          }
        },
      ),
      extendBody: true,
    );
  }
}
