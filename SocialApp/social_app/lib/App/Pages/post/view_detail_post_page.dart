import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/app/utils/assets_manage.dart';
import 'package:social_app/app/widgets/Button.dart';
import 'package:social_app/app/widgets/comment_card.dart';
import 'package:social_app/app/widgets/gradient_text.dart';
import 'package:social_app/app/widgets/post_image_view.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/style/app_text_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewDetailPostPage extends StatefulWidget {
  final String postId;                       // 🔄 nhận id
  const ViewDetailPostPage({super.key, required this.postId});

  @override
  State<ViewDetailPostPage> createState() => _ViewDetailPostPageState();
}

class _ViewDetailPostPageState extends State<ViewDetailPostPage> {
  late final TextEditingController _commentController;
  bool _isTexting = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController()
      ..addListener(() => setState(
          () => _isTexting = _commentController.text.isNotEmpty));
    // ✅ tăng view ngay khi mở trang
    context.read<PostBloc>().add(PostViewIncreaseRequested(widget.postId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocSelector<PostBloc, PostState, PostEntity?>(
        selector: (state) {
          if (state is! PostListLoaded) return null;
          return state.posts
              .where((p) => p.id == widget.postId)
              .cast<PostEntity?>()
              .firstOrNull;
        },
        builder: (context, post) {
          if (post == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildBody(context, post);
        },
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: AssetsManager.showImage('assets/icons/like-black.svg'),
            onPressed: () {}, // tuỳ bạn thêm
          ),
          IconButton(
            icon: AssetsManager.showImage('assets/icons/plus-circle-black.svg'),
            onPressed: () {},
          ),
          IconButton(
            icon: AssetsManager.showImage('assets/icons/save-collection.svg'),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      );

  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, PostEntity post) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final createdText =
        timeago.format(post.createdAt, locale: 'en_short');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header (avatar, tên, time) ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      AssetsManager.showImage('assets/images/avatar.jpg',
                          height: 40, width: 40, fit: BoxFit.cover, isCircle: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.userId,
                                style: GoogleFonts.manrope(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(createdText,
                                style: GoogleFonts.manrope(
                                    fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // ── Images ──
                if (post.imageUrls.isNotEmpty)
                  PostImagesViewer(imageUrls: post.imageUrls),
                // ── Caption ──
                if (post.caption.isNotEmpty)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    child: Text(post.caption,
                        style: AppTextStyles.bodyTextGrey),
                  ),
                // ── Hashtag ──
                if (post.hashtags.isNotEmpty)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                    child: GradientText(
                      text: post.hashtags.map((t) => '#$t').join(' '),
                      style: AppTextStyles.bodyTextGrey,
                      fontSize: 15,
                    ),
                  ),
                // ── Stats row ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(
                          count: post.viewsCount,
                          icon: 'assets/icons/eye.svg'),
                      _statItem(
                          count: post.commentsCount,
                          icon: 'assets/icons/comment.svg'),
                      Row(
                        children: [
                          Text('${post.likesCount}',
                              style: AppTextStyles.bodyTextGrey),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              context.read<PostBloc>().add(
                                  PostToggleLikeRequested(post, currentUid!));
                            },
                            child: post.isLikedBy(currentUid ?? '')
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
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Comments list (mock) ──
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: const Column(
                    children: [
                      CommentCard(),
                      SizedBox(height: 10),
                      CommentCard(),
                      SizedBox(height: 10),
                      CommentCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ── Comment input ──
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 12,
            right: 12,
            top: 20,
          ),
          child: Row(
            children: [
              AssetsManager.showImage('assets/images/avatar.jpg',
                  height: 40, width: 40, fit: BoxFit.cover, isCircle: true),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.manrope(color: Colors.grey[600]),
                  ),
                  style: AppTextStyles.bodyTextMediumBlack,
                  maxLines: null,
                  minLines: 1,
                ),
              ),
              if (_isTexting) ...[
                const SizedBox(width: 10),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: CustomButton(
                    text: 'Post',
                    onPressed: () {
                      // handle comment
                      _commentController.clear();
                    },
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _statItem({required int count, required String icon}) => Row(
        children: [
          Text('$count', style: AppTextStyles.bodyTextGrey),
          const SizedBox(width: 4),
          AssetsManager.showImage(icon),
        ],
      );
}
