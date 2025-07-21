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

import '../../../Data/model/user.dart';
import '../../utils/image_base64.dart';

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
        onPressed: () {
          _showSaveToCollectionBottomSheet(context);
        },
      ),
      IconButton(
        icon: AssetsManager.showImage('assets/icons/save-collection.svg'),
        onPressed: () {

        },
      ),
      const SizedBox(width: 8),
    ],
  );

  void _showSaveToCollectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white, // Đặt nền trắng cho bottom sheet
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)), // Bo góc lớn hơn
      ),
      builder: (BuildContext context) {
        // Sử dụng một StatefulWidget bên trong để quản lý trạng thái chọn
        return SaveToCollectionSheet();
      },
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
                FutureBuilder<AppUser?>(
                  future: AppUser.getFromFirestore(post.userId),
                  builder: (context, snapshot) {
                    // Trong khi đang tải dữ liệu
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 20, backgroundColor: Color(0xFFEFEFEF)),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 5, backgroundColor: Color(0xFFEFEFEF)),
                                SizedBox(height: 8),
                                CircleAvatar(radius: 4, backgroundColor: Color(0xFFEFEFEF)),
                              ],
                            )
                          ],
                        ),
                      );
                    }

                    // Nếu không có dữ liệu hoặc có lỗi
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const ListTile(title: Text("Không tìm thấy người dùng"));
                    }

                    // Khi đã có dữ liệu người dùng (postUser)
                    final postUser = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          // Hiển thị avatar người dùng
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: ImageUtils.getImageProvider(postUser.imageUrl),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hiển thị tên người dùng
                                Text(
                                  '${postUser.name ?? ''} ${postUser.lastName ?? ''}'.trim(),
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
                          // Nút tùy chọn (sửa/xóa)
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
                    );
                  },
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


class SaveToCollectionSheet extends StatefulWidget {
  const SaveToCollectionSheet({super.key});

  @override
  State<SaveToCollectionSheet> createState() => _SaveToCollectionSheetState();
}

class _SaveToCollectionSheetState extends State<SaveToCollectionSheet> {
  final List<Map<String, dynamic>> collections = [
    {
      'title': 'PORTRAIT',
      'isSelected': false,
      'imagePath': 'assets/images/img_19.png'
    },
    {
      'title': 'FASHION',
      'isSelected': false,
      'imagePath': 'assets/images/img_21.png'
    },
    {
      'title': 'ART',
      'isSelected': false,
      'imagePath': 'assets/images/img_22.png'
    },
    {
      'title': 'NATURE',
      'isSelected': false,
      'imagePath': 'assets/images/img_19.png'
    },
  ];

  void _showCreateCollectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CreateCollectionForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Giả sử chiều cao của nút X (tính cả vùng nhấn) là 50px
    const double buttonHeight = 50.0;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // 1. Phần nội dung của Bottom Sheet
        Padding(
          padding: const EdgeInsets.only(top: buttonHeight / 2),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16.0, (buttonHeight / 2) + 16.0, 16.0, 16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
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
                      // Nút "New Collection"
                      ElevatedButton(
                        onPressed: () {
                          _showCreateCollectionSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF888BF4), Color(0xFF5151C6)],
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            child: Text(
                              'New Collection',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sub-header
                  Text(
                    'Your Collections',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Lưới các bộ sưu tập
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        return _buildCollectionItem(
                          title: collections[index]['title'],
                          imagePath: collections[index]['imagePath'],
                          isSelected: collections[index]['isSelected'],
                          onTap: () {
                            setState(() {
                              collections[index]['isSelected'] =
                              !collections[index]['isSelected'];
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. Nút Đóng (X)
        Positioned(
          top: -20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget để xây dựng mỗi ô trong lưới bộ sưu tập
  Widget _buildCollectionItem({
    required String title,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color themeColor = const Color(0xFF6A6BF4);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand, // Đảm bảo các lớp con phủ kín
          children: [
            // Lớp 1: Ảnh nền
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              // Thêm errorBuilder để xử lý nếu ảnh bị lỗi
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),

            // Lớp 2: Lớp phủ gradient màu đen để chữ luôn dễ đọc
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Lớp 3: Lớp phủ gradient màu tím (chỉ hiện khi được chọn)
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF888BF4).withOpacity(0.7),
                      const Color(0xFF5151C6).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

            // Lớp 4: Tiêu đề
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: const [
                    Shadow(blurRadius: 4.0, color: Colors.black54)
                  ],
                ),
              ),
            ),
            // Dấu tích ở góc dưới bên phải khi được chọn
            if (isSelected)
              Positioned(
                bottom: 150,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColor,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CreateCollectionForm extends StatefulWidget {
  @override
  __CreateCollectionFormState createState() => __CreateCollectionFormState();
}

class __CreateCollectionFormState extends State<_CreateCollectionForm> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Padding để đẩy nội dung lên khi bàn phím xuất hiện
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Nội dung form
            Container(
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                // <<< BỎ DÒNG mainAxisSize: MainAxisSize.min Ở ĐÂY >>>
                // Giờ Column sẽ chiếm toàn bộ chiều cao được phép
                children: [
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Type name',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    style: GoogleFonts.manrope(),
                  ),
                  const SizedBox(height: 24),
                  // Nút Create
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final collectionName = _nameController.text;
                        if (collectionName.isNotEmpty) {
                          print('Tạo collection mới: $collectionName');
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        backgroundColor: const Color(0xFF6A6BF4),
                      ),
                      child: Text(
                        'CREATE COLLECTION',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Nút đóng X
            Positioned(
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300)
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}