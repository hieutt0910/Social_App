import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/style/app_text_style.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    final String? currentUid = user?.uid;
    final uid = post.userId;
    final createdText = timeago.format(post.createdAt, locale: 'en_short');

    return GestureDetector(
      onTap: () {
        context.read<PostBloc>().add(PostViewIncreaseRequested(post.id));
        context.push('/view-post', extra: post.id);
      },
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
                    'assets/images/avatar1.jpg',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                    isCircle: true,
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
                height: 230,
              ),

            if (post.caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Text(
                  post.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: AppTextStyles.bodyTextMediumBlack,
                ),
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
                      Text(
                        '${post.likesCount}',
                        style: AppTextStyles.bodyTextMediumGrey,
                      ),
                      const SizedBox(width: 6),

                      GestureDetector(
                        onTap: () {
                          context.read<PostBloc>().add(
                            PostToggleLikeRequested(post, currentUid),
                          );
                        },
                        child:
                            post.isLikedBy(currentUid!)
                                ? AssetsManager.showImage(
                                  'assets/icons/like-fill.svg',
                                  width: 20,
                                  height: 20,
                                )
                                : AssetsManager.showImage(
                                  'assets/icons/like.svg',
                                  width: 20,
                                  height: 20,
                                ),
                      ),
                      const SizedBox(width: 4),
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
