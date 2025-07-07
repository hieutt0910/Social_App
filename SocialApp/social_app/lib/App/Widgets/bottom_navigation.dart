import 'package:flutter/material.dart';
import 'package:social_app/App/Widgets/navbar_icon.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: BottomAppBar(
        height: 75,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarIcon(
              assetPathSelected: 'assets/icons/home_selected.svg',
              assetPathUnSelected: 'assets/icons/home_unselected.svg',
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            NavBarIcon(
              assetPathSelected: 'assets/icons/category_selected.svg',
              assetPathUnSelected: 'assets/icons/category_unselected.svg',
              isSelected: selectedIndex == 1,
              onTap: () => onItemTapped(1),
            ),
            const SizedBox(width: 48),
            NavBarIcon(
              assetPathSelected: 'assets/icons/notification_selected.svg',
              assetPathUnSelected: 'assets/icons/notification_unselected.svg',
              isSelected: selectedIndex == 2,
              onTap: () => onItemTapped(2),
            ),
            NavBarIcon(
              assetPathSelected: 'assets/icons/profile_selected.svg',
              assetPathUnSelected: 'assets/icons/profile_unselected.svg',
              isSelected: selectedIndex == 3,
              onTap: () => onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
