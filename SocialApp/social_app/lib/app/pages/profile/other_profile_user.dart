import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/Data/model/collection.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart';
import 'package:social_app/app/bloc/post/post_event.dart';
import 'package:social_app/app/bloc/post/post_state.dart';
import 'package:social_app/data/model/shot.dart';
import 'package:social_app/data/model/user.dart';
import '../../utils/image_base64.dart';

class OtherUserProfilePage extends StatefulWidget {
  final AppUser user;

  const OtherUserProfilePage({super.key, required this.user});

  @override
  State<OtherUserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<OtherUserProfilePage> {
  int selectedTab = 0;
  List<Shot> shots = [];
  List<Collection> collections = [];
  bool isFollowing = false;
  bool isLoading = false;

  final List<String> tabs = ["Shots", "Collections"];
  final List<String> socialIcons = [
    'assets/images/img_15.png',
    'assets/images/img_16.png',
    'assets/images/img_17.png',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkFollowingStatus();
    context.read<PostBloc>().add(PostByUserIdRequested(widget.user.uid));
  }

  Future<void> _loadUserData() async {
    final userShots = await Shot.getUserShots(widget.user.uid);
    final userCollections = await Collection.getUserCollections(
      widget.user.uid,
    );
    setState(() {
      shots = userShots;
      collections = userCollections;
    });
  }

  Future<void> _checkFollowingStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final appUser = await AppUser.getFromFirestore(currentUser.uid);
      if (appUser != null) {
        final following = await appUser.isFollowing(widget.user.uid);
        setState(() {
          isFollowing = following;
        });
      }
    }
  }

  Future<void> _toggleFollow() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      isLoading = true;
    });

    final appUser = await AppUser.getFromFirestore(currentUser.uid);
    if (appUser != null) {
      try {
        if (isFollowing) {
          await appUser.unfollowUser(widget.user.uid);
          setState(() {
            isFollowing = false;
            widget.user.followers--;
          });
        } else {
          await appUser.followUser(widget.user.uid);
          setState(() {
            isFollowing = true;
            widget.user.followers++;
          });
        }
      } catch (e) {
        print('Error toggling follow: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                child: Image.asset(
                  'assets/images/img_2.png',
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Back icon
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 35,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '@${widget.user.email.split('@')[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 28,
                right: 16,
                child: GestureDetector(
                  onTap: isLoading ? null : _toggleFollow,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isFollowing ? Colors.grey.shade300 : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        color:
                            isFollowing
                                ? Colors.black54
                                : const Color(0xFF6A6BF4),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -55,
                left: 0,
                right: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        widget.user.imageUrl != null
                            ? ImageUtils.getImageProvider(widget.user.imageUrl)
                            : const AssetImage('assets/images/avatar1.jpg'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    '${widget.user.name ?? 'Unknown'} ${widget.user.lastName ?? ''}'
                        .trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (widget.user.location ?? 'Unknown Location').trim(),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Followers
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F7F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.user.followers}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Followers",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(width: 48),
                        Text(
                          "${widget.user.following}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Following",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Social Icons + Dot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(socialIcons.length * 2 - 1, (
                      index,
                    ) {
                      if (index.isEven) {
                        final iconIndex = index ~/ 2;
                        return Image.asset(
                          socialIcons[iconIndex],
                          width: 24,
                          height: 24,
                        );
                      } else {
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF888BF4), Color(0xFF5151C6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 30),
                  // Tab Bar with actual count
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = selectedTab == index;
                        final count =
                            index == 0 ? shots.length : collections.length;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFF1F1FE)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "$count ${tabs[index]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        isSelected
                                            ? const Color(0xFF6A6BF4)
                                            : const Color(0xFFB8B8B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Content Grid or Empty
                  selectedTab == 0
                      ? _buildPostGridOrEmpty()
                      : _buildCollections(),
                  const SizedBox(height: 40),
                ],
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
        } else if (state is PostListLoaded) {
          final userPosts = state.posts; 
          if (userPosts.isEmpty) {
            return Center(
              child: Image.asset(
                'assets/images/img_18.png',
                width: 200,
                height: 200,
              ),
            );
          }
          return MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: userPosts.length,
            itemBuilder: (context, index) {
              final post = userPosts[index];
              final imageUrl = post.imageUrls.first;

              return GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Image.asset(
                          'assets/images/img_18.png',
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
              );
            },
          );
        } else if (state is PostFailure) {
          return Center(child: Text('Error loading posts: ${state.error}'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCollections() {
    if (collections.isEmpty) {
      return Center(
        child: Image.asset('assets/images/img_18.png', width: 200, height: 200),
      );
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
          onTap: () {
            context.push(
              '/collection-detail',
              extra: {'collection': collection},
            );
          },
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
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
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
