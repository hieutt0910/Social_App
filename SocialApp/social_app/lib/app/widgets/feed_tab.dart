import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/app/widgets/post_widget.dart';
import 'package:social_app/style/app_text_style.dart';

class FeedTab extends StatefulWidget {
  const FeedTab({super.key});

  @override
  State<FeedTab> createState() => FeedTabState();
}

class FeedTabState extends State<FeedTab> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(const PostFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<PostBloc>(),
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostFailure) {
          return Center(child: Text(state.message));
        }
        if (state is PostListLoaded) {
          final posts = state.posts;
          if (posts.isEmpty) {
            return Center(
              child: Text(
                'Chưa có bài viết',
                style: AppTextStyles.bodyTextMediumGrey,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: posts.length,
                  itemBuilder: (_, i) {
                    return PostWidget(
                      post: posts[i],
                      onLike: () {},
                      onComment: () {},
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                ),
              ),
              SizedBox(height: 80),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
