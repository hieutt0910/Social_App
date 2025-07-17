import 'package:flutter/material.dart';
import 'package:social_app/app/utils/assets_manage.dart';
import 'package:social_app/style/app_color.dart';
import 'package:social_app/style/app_text_style.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetsManager.showImage(
            'assets/images/avatar.jpg',
            height: 30,
            width: 30,
            fit: BoxFit.cover,
            isCircle: true,
          ),

          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Trần Trọng Hiếu", style: AppTextStyles.bodyTextBlack),
              Text("Trần Trọng Hiếu", style: AppTextStyles.bodyTextMediumBlack),
              SizedBox(height: 10),
              Text("1 phút trước", style: AppTextStyles.bodyTextMediumGrey),
            ],
          ),
        ],
      ),
    );
  }
}
