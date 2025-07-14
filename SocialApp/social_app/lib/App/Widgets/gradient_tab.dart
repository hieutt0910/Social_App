import 'package:flutter/material.dart';
import 'package:social_app/app/widgets/gradient_text.dart';
import 'package:social_app/style/app_color.dart';

class GradientTab extends StatefulWidget {
  final String text;
  final TabController tabController;
  final int index;

  const GradientTab({
    super.key,
    required this.text,
    required this.tabController,
    required this.index,
  });

  @override
  State<GradientTab> createState() => _GradientTabState();
}

class _GradientTabState extends State<GradientTab> {
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
              ? GradientText(text: widget.text, fontSize: 16)
              : Text(
                widget.text,
                style: const TextStyle(
                  color: AppColors.customGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
    );
  }
}
