
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/app/bloc/user_profile/user_profile_bloc.dart';
import 'package:social_app/app/bloc/user_profile/user_profile_event.dart';
import 'package:social_app/app/bloc/user_profile/user_profile_state.dart';
import 'package:social_app/data/model/collection.dart';
import 'package:social_app/data/model/user.dart';
import '../../utils/image_base64.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int selectedTab = 0;
  final List<String> tabs = ["Shots", "Collections"];
  final List<String> socialIcons = [
    'assets/images/img_15.png',
    'assets/images/img_16.png',
    'assets/images/img_17.png',
  ];

  @override
  void initState() {
    super.initState();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Gửi sự kiện để tải dữ liệu user và collections
      context.read<UserProfileBloc>().add(UserProfileDataRequested(firebaseUser.uid));
      // Gửi sự kiện để tải các bài post (shots)
      context.read<PostBloc>().add(PostByUserIdRequested(firebaseUser.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userState) {
          if (userState is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userState is UserProfileLoadFailure) {
            return Center(child: Text('Error: ${userState.error}'));
          }
          if (userState is UserProfileLoadSuccess) {
            // Khi có dữ liệu, xây dựng UI chính
            return _buildProfileUI(context, userState.user, userState.collections);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileUI(BuildContext context, AppUser user, List<Collection> collections) {
    return Column(
      children: [
        // Header
        Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              'assets/images/img_2.png',
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 35,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '@${user.email.split('@')[0]}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 30,
              right: 16,
              child: const Icon(Icons.settings, color: Colors.white),
            ),
            Positioned(
              bottom: -55,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: ImageUtils.getImageProvider(user.imageUrl),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        // Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  '${user.name ?? 'Unknown'} ${user.lastName ?? ''}'.trim(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  (user.location ?? 'Unknown Location').trim(),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 20),
                // Followers/Following
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${user.followers}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 4),
                      const Text("Followers", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(width: 48),
                      Text("${user.following}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 4),
                      const Text("Following", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Social Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(socialIcons.length * 2 - 1, (index) {
                    if (index.isEven) {
                      return Image.asset(socialIcons[index ~/ 2], width: 24, height: 24);
                    }
                    return Container(
                      width: 6, height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF888BF4), Color(0xFF5151C6)])),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                // Tab Bar
                _buildTabBar(context, collections),
                const SizedBox(height: 30),
                // Content Grid
                selectedTab == 0
                    ? _buildPostGridOrEmpty()
                    : _buildCollectionsGrid(collections),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, List<Collection> collections) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          // Shots Tab - vẫn dùng PostBloc
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, postState) {
                final count = postState is PostListLoaded ? postState.posts.length : 0;
                final isSelected = selectedTab == 0;
                return GestureDetector(
                  onTap: () => setState(() => selectedTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF1F1FE) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "$count ${tabs[0]}",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? const Color(0xFF6A6BF4) : const Color(0xFFB8B8B8)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Collections Tab - dùng dữ liệu từ UserProfileBloc
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedTab == 1 ? const Color(0xFFF1F1FE) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "${collections.length} ${tabs[1]}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: selectedTab == 1 ? const Color(0xFF6A6BF4) : const Color(0xFFB8B8B8)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostGridOrEmpty() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostListLoaded) {
          if (state.posts.isEmpty) {
            return Center(child: Image.asset('assets/images/img_18.png', width: 200, height: 200));
          }
          return MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/img_18.png', fit: BoxFit.cover),
                ),
              );
            },
          );
        }
        if (state is PostFailure) {
          return Center(child: Text('Error loading posts: ${state.error}'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCollectionsGrid(List<Collection> collections) {
    if (collections.isEmpty) {
      return Center(child: Image.asset('assets/images/img_18.png', width: 200, height: 200));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: collections.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final collection = collections[index];
        return GestureDetector(
          onTap: () => context.push('/collection-detail', extra: {'collection': collection}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(

                alignment: Alignment.center,

                children: [

                  ClipRRect(

                    borderRadius: BorderRadius.circular(12),

                    child: Image.network(

                      collection.coverImage,

                      fit: BoxFit.cover,

                      width: double.infinity,

                      height: 166,

                      errorBuilder: (context, error, stackTrace) => Image.asset(

                        'assets/images/img_18.png',

                        fit: BoxFit.cover,

                      ),

                    ),

                  ),

                  Positioned.fill(

                    child: Container(

                      alignment: Alignment.center,

                      decoration: BoxDecoration(

                        color: Colors.black.withOpacity(0.3),

                        borderRadius: BorderRadius.circular(12),

                      ),

                      child: Text(

                        collection.title ?? 'No Title',

                        textAlign: TextAlign.center,

                        style: const TextStyle(

                          color: Colors.white,

                          fontSize: 20,

                          fontWeight: FontWeight.bold,

                          shadows: [

                            Shadow(

                              color: Colors.black54,

                              blurRadius: 4,

                              offset: Offset(1, 1),

                            ),

                          ],

                        ),

                      ),

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 8),

              Text(

                '${collection.imageIds.length} shots',

                style: const TextStyle(

                  color: Color(0xFF8E8E93),

                  fontSize: 14,

                  fontWeight: FontWeight.w500,

                ),

              ),
            ],
          ),
        );
      },
    );
  }
}