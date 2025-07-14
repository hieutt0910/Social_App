import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_app/app/utils/assets_manage.dart';
import 'package:social_app/app/widgets/Button.dart';
import 'package:social_app/app/widgets/comment_card.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/style/app_text_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewDetailPostPage extends StatefulWidget {
  final PostEntity post;
  const ViewDetailPostPage({super.key, required this.post});

  @override
  State<ViewDetailPostPage> createState() => _ViewDetailPostPageState();
}

class _ViewDetailPostPageState extends State<ViewDetailPostPage> {
  late final TextEditingController _commentController;

  bool _isTexting = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentController.addListener(_updateTextingStatus);
  }

  @override
  void dispose() {
    _commentController.removeListener(_updateTextingStatus);
    _commentController.dispose();
    super.dispose();
  }

  void _updateTextingStatus() {
    setState(() {
      _isTexting = _commentController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = widget.post.userId;
    final createdText = timeago.format(
      widget.post.createdAt,
      locale: 'en_short',
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: AssetsManager.showImage('assets/icons/like-black.svg'),
            onPressed: () {
              print('Like icon tapped on detail page');
            },
          ),
          IconButton(
            icon: AssetsManager.showImage('assets/icons/plus-circle-black.svg'),
            onPressed: () {
              print('Plus circle icon tapped on detail page');
            },
          ),
          IconButton(
            icon: AssetsManager.showImage('assets/icons/save-collection.svg'),
            onPressed: () {
              print('Save collection icon tapped on detail page');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          AssetsManager.showImage(
                            'https://avatar.iran.liara.run/public',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  uid,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.post.imageUrls.isNotEmpty) // Dùng widget.post
                      AssetsManager.showImage(
                        widget.post.imageUrls.first, // Dùng widget.post
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.post.likesCount}', // Dùng widget.post
                                style: AppTextStyles.bodyTextGrey,
                              ),
                              const SizedBox(width: 5),
                              AssetsManager.showImage('assets/icons/eye.svg'),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.post.likesCount}', // Dùng widget.post
                                style: AppTextStyles.bodyTextGrey,
                              ),
                              const SizedBox(width: 4),
                              AssetsManager.showImage(
                                'assets/icons/comment.svg',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.post.likesCount}', // Dùng widget.post
                                style: AppTextStyles.bodyTextGrey,
                              ),
                              const SizedBox(width: 4),
                              AssetsManager.showImage('assets/icons/like.svg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.post.caption.isNotEmpty) // Dùng widget.post
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 20,
                        ),
                        width: double.infinity,
                        child: Text(
                          widget.post.caption, // Dùng widget.post
                          style: AppTextStyles.bodyTextGrey,
                        ),
                      ),
                    const SizedBox(height: 40),
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
                          SizedBox(height: 10),
                          CommentCard(),
                          SizedBox(height: 10),
                          CommentCard(),
                          SizedBox(height: 10),
                          CommentCard(),
                          SizedBox(height: 10),
                          CommentCard(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
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
                  'https://avatar.iran.liara.run/public/boy',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
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
                    style: AppTextStyles.bodyTextMediumblack,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
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
                        print('Comment posted: ${_commentController.text}');
                        _commentController.clear();
                      },
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
