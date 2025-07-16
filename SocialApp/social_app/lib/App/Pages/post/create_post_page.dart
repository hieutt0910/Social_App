import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/app/Widgets/Button.dart';
import 'package:social_app/app/utils/assets_manage.dart';
import 'package:social_app/app/widgets/gradient_text.dart';
import 'package:social_app/style/app_color.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _captionController = TextEditingController();
  final _selectedImages = <File>[];
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
  final Set<String> _chosenTags = {};

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => _selectedImages.addAll(images.map((x) => File(x.path))));
    }
  }

  void _removeImage(int i) => setState(() => _selectedImages.removeAt(i));

  List<String> _collectHashtags() {
    return _chosenTags.toList();
  }

  void _submit() {
    final caption = _captionController.text.trim();
    if (caption.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa nhập nội dung hoặc chọn ảnh')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    context.read<PostBloc>().add(
      PostCreateRequested(
        caption: caption,
        images: _selectedImages,
        userId: uid,
        hashtags: _collectHashtags(),
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostSuccess) {
          _captionController.clear();
          _selectedImages.clear();
          _chosenTags.clear();
          context.read<PostBloc>().add(const PostFetchRequested());
          context.pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Đã đăng bài viết')));
        }
        if (state is PostFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tạo bài viết'),
          actions: [
            TextButton(
              onPressed: _submit,
              child: const Text(
                'Đăng',
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
                Row(
                  children: [
                    AssetsManager.showImage(
                      'assets/images/avatar1.jpg',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      isCircle: true,
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Tên người dùng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(
                    hintText: 'Bạn đang nghĩ gì?',
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
                          labelStyle: TextStyle(color: Colors.white),

                          onSelected:
                              (val) => setState(() {
                                val
                                    ? _chosenTags.add(tag)
                                    : _chosenTags.remove(tag);
                              }),
                        );
                      }).toList(),
                ),
                if (_chosenTags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children:
                        _chosenTags
                            .map((t) => GradientText(text: '#$t', fontSize: 16))
                            .toList(),
                  ),
                ],

                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    _selectedImages.length,
                    (index) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
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
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 55,
                  width: 150,
                  child: CustomButton(text: 'Chọn ảnh', onPressed: _pickImages),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
