import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  final String postId;
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
    timeago.setLocaleMessages('vi', timeago.ViMessages());

    _commentController =
    TextEditingController()..addListener(
          () => setState(() => _isTexting = _commentController.text.isNotEmpty),
    );
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

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      IconButton(
        icon: AssetsManager.showImage('assets/icons/like-black.svg'),
        onPressed: () {},
      ),
      IconButton(
        icon: AssetsManager.showImage('assets/icons/plus-circle-black.svg'),
        onPressed: () {},
      ),
      IconButton(
        icon: AssetsManager.showImage('assets/icons/save-collection.svg'),
        onPressed: () {
          _showSaveToCollectionBottomSheet(context);
        },
      ),
      const SizedBox(width: 8),
    ],
  );

  void _showSaveToCollectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép bottom sheet chiếm toàn bộ chiều cao cần thiết
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return _buildSaveToCollectionBottomSheet();
      },
    );
  }

  Widget _buildSaveToCollectionBottomSheet() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      child: Container(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 16.0), // Padding để điều chỉnh vị trí
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0, // Đặt sát mép trên
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 0.5), // Viền xám
                    ),
                    child: CircleAvatar(
                      radius: 18, // Bán kính của hình tròn bên trong
                      backgroundColor: Colors.white, // Nền trắng
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40.0), // Đẩy nội dung xuống dưới nút đóng
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Save to collection',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Xử lý tạo bộ sưu tập mới
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Loại bỏ màu nền mặc định
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: EdgeInsets.zero, // Loại bỏ padding mặc định
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF888BF4),
                                  Color(0xFF5151C6),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                              child: Text(
                                'New Collection',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Collections',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          _buildCollectionItem('PORTRAIT PHOTOGRAPHY', true),
                          _buildCollectionItem('PORTRAIT PHOTOGRAPHY', false),
                          _buildCollectionItem('PORTRAIT PHOTOGRAPHY', true),
                          _buildCollectionItem('PORTRAIT PHOTOGRAPHY', false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionItem(String title, bool isSelected) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: Colors.blue, size: 16),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, PostEntity post) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final createdText = timeago.format(post.createdAt, locale: 'en');
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      AssetsManager.showImage(
                        'assets/images/avatar.jpg',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        isCircle: true,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.userId,
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              createdText,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (currentUid != null && currentUid == post.userId)
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _showPostOptions(context, post);
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (post.imageUrls.isNotEmpty)
                  PostImagesViewer(imageUrls: post.imageUrls),
                if (post.caption.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 20,
                    ),
                    child: Text(
                      post.caption,
                      style: AppTextStyles.bodyTextGrey,
                    ),
                  ),
                if (post.hashtags.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 20,
                    ),
                    child: GradientText(
                      text: post.hashtags.map((t) => '#$t').join(' '),
                      style: AppTextStyles.bodyTextGrey,
                      fontSize: 15,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(
                        count: post.viewsCount,
                        icon: 'assets/icons/eye.svg',
                      ),
                      _statItem(
                        count: post.commentsCount,
                        icon: 'assets/icons/comment.svg',
                      ),
                      Row(
                        children: [
                          Text(
                            '${post.likesCount}',
                            style: AppTextStyles.bodyTextGrey,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              if (currentUid != null) {
                                // Đảm bảo currentUid không null
                                context.read<PostBloc>().add(
                                  PostToggleLikeRequested(post, currentUid),
                                );
                              }
                            },
                            child:
                            post.isLikedBy(currentUid ?? '')
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
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 20,
                  ),
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
        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 12,
            right: 12,
            top: 20,
          ),
          child: Row(
            children: [
              AssetsManager.showImage(
                'assets/images/avatar.jpg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                isCircle: true,
              ),
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

  void _showPostOptions(BuildContext context, PostEntity post) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Chỉnh sửa bài viết'),
                onTap: () {
                  context.pop();
                  context.push('/edit-post', extra: post);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Xóa bài viết',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);

                  _showDeleteConfirmationDialog(context, post);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, PostEntity post) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa bài viết này không? '),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.pop();

                context.read<PostBloc>().add(PostDeleteRequested(post.id));
                context.pop();
              },
            ),
          ],
        );
      },
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