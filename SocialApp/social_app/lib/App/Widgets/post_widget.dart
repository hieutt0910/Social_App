import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/App/utils/assets_manage.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AssetsManager.showImage(
                  'https://avatar.iran.liara.run/public',
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),

                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tên người dùng',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '10 minutes ago',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            child: AssetsManager.showImage(
              "https://picsum.photos/300/200",
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AssetsManager.showImage(
                  "assets/icons/plus-circle.svg",
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
                Row(
                  children: [
                    Text(
                      '20',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 6),
                    AssetsManager.showImage(
                      "assets/icons/comment.svg",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(width: 6),
                    Text(
                      '12',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 12),
                    AssetsManager.showImage(
                      "assets/icons/like.svg",
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
