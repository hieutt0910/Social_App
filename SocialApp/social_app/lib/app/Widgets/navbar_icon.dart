import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarIcon extends StatelessWidget {
  final String assetPathSelected;
  final String assetPathUnSelected;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarIcon({
    super.key,
    required this.assetPathSelected,
    required this.assetPathUnSelected,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget icon = SvgPicture.asset(
      isSelected ? assetPathSelected : assetPathUnSelected,
      width: 28,
      height: 28,
    );

    return IconButton(onPressed: onTap, icon: icon);
  }
}
