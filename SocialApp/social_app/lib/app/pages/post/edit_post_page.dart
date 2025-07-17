import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/app/Widgets/Button.dart';
import 'package:social_app/app/widgets/gradient_text.dart';
import 'package:social_app/data/servives/cloudinary_service.dart';
import 'package:social_app/domain/entity/post.dart';
import 'package:social_app/style/app_color.dart';

class EditPostPage extends StatefulWidget {
  final PostEntity post;
  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _captionController;
  late Set<String> _chosenTags;
  late List<String> _cloudImages;
  final List<File> _newImages = [];
  final _picker = ImagePicker();

  final _presetTags = [
    'photography',
    'ui design',
    'illustration',
    'travel',
    'street style',
    'daily life',
    'food & coffee',
    'event & festival',
  ];

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption);
    _cloudImages = [...widget.post.imageUrls];
    _chosenTags = {...widget.post.hashtags};
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _newImages.addAll(images.map((x) => File(x.path)));
      });
    }
  }

  void _removeCloudImage(int index) {
    setState(() => _cloudImages.removeAt(index));
  }

  void _removeNewImage(int index) {
    setState(() => _newImages.removeAt(index));
  }

  Future<void> _submit() async {
    final caption = _captionController.text.trim();

    List<String> newUrls = [];
    if (_newImages.isNotEmpty) {
      try {
        final cloudinaryService = CloudinaryService();
        newUrls = await Future.wait(
          _newImages.map((img) => cloudinaryService.uploadImage(img)),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Upload ảnh thất bại: $e')));
        }
        return;
      }
    }

    final allImages = [..._cloudImages, ...newUrls];
    if (caption.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text('Không thể xóa caption')));
      return;
    }

    final updatedPost = widget.post.copyWith(
      caption: caption,
      hashtags: _chosenTags.toList(),
      imageUrls: allImages,
    );

    // ignore: use_build_context_synchronously
    context.read<PostBloc>().add(PostEditRequested(updatedPost));
    // ignore: use_build_context_synchronously
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostSuccess) {
          context.pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đã cập nhật bài viết')));
        } else if (state is PostFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chỉnh sửa bài viết'),
          actions: [
            TextButton(
              onPressed: _submit,
              child: const Text(
                'Lưu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'Nội dung...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children:
                      _presetTags.map((tag) {
                        final selected = _chosenTags.contains(tag);
                        return ChoiceChip(
                          label: Text('#$tag'),
                          selected: selected,
                          selectedColor: AppColors.startGradient,
                          backgroundColor: AppColors.endGradient,
                          labelStyle: const TextStyle(color: Colors.white),
                          onSelected: (val) {
                            setState(() {
                              val
                                  ? _chosenTags.add(tag)
                                  : _chosenTags.remove(tag);
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 10),
                if (_chosenTags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children:
                        _chosenTags
                            .map((t) => GradientText(text: '#$t', fontSize: 16))
                            .toList(),
                  ),
                const SizedBox(height: 10),
                const Text(
                  'Ảnh đã đăng:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Hiển thị ảnh từ Cloudinary (link URL)
                    ...List.generate(
                      _cloudImages.length,
                      (index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _cloudImages[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeCloudImage(index),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hiển thị ảnh mới thêm từ local file
                    ...List.generate(
                      _newImages.length,
                      (index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _newImages[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeNewImage(index),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                SizedBox(
                  height: 55,
                  width: 150,
                  child: CustomButton(text: 'Thêm ảnh', onPressed: _pickImages),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
