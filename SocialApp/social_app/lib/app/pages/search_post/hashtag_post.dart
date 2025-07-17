import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/app/widgets/post_widget.dart';
import '../../../Data/model/user.dart';
import '../../utils/image_base64.dart';

class HashtagPostsPage extends StatefulWidget {
  final String hashtag;
  const HashtagPostsPage({super.key, required this.hashtag});

  @override
  State<HashtagPostsPage> createState() => _HashtagPostsPageState();
}

class _HashtagPostsPageState extends State<HashtagPostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostByHashtagRequested(widget.hashtag));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('#${widget.hashtag}')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (_, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostFailure) {
            return Center(child: Text(state.message));
          }
          if (state is PostListLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return const Center(child: Text('Không có bài viết'));
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: posts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final post = posts[i];
                return FutureBuilder<AppUser?>(
                  future: AppUser.getFromFirestore(post.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Đang tải...'),
                      );
                    }
                    if (snapshot.hasError) {
                      return ListTile(
                        title: Text('Lỗi: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const ListTile(
                        title: Text('Không tìm thấy người dùng'),
                      );
                    }
                    final user = snapshot.data!;
                    return PostWidget(
                      post: post,
                      onLike: () {},
                      onComment: () {},
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}