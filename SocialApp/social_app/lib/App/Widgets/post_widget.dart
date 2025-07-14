import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:social_app/app/utils/assets_manage.dart';

class PostWidget extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  const PostWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    final uid = post.userId;
    final createdText = timeago.format(post.createdAt, locale: 'en_short');

    return GestureDetector(
      onTap: () => context.push('/view-post', extra: post),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
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
                children: [
                  AssetsManager.showImage(
                    'https://avatar.iran.liara.run/public',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      uid,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    createdText,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (post.imageUrls.isNotEmpty)
              AssetsManager.showImage(
                post.imageUrls.first,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            if (post.caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Text(post.caption),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: AssetsManager.showImage(
                      'assets/icons/plus-circle.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        '${post.commentsCount}',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: onComment,
                        child: AssetsManager.showImage(
                          'assets/icons/comment.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onLike,
                        child: Icon(
                          post.isLikedBy(uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: post.isLikedBy(uid) ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likesCount}',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
