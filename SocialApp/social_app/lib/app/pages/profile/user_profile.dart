import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import BLoC
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/bloc/post/post_bloc.dart'; // Import BLoC
import 'package:social_app/app/bloc/post/post_event.dart'; // Import BLoC
import 'package:social_app/app/bloc/post/post_state.dart'; // Import BLoC
import '../../../Data/model/collection.dart';
import '../../../Data/model/user.dart';
import '../../utils/image_base64.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int selectedTab = 0;
  AppUser? _user;
  // `shots` list is no longer the primary source for the grid, but can be kept for initial count
  List<Collection> collections = [];

  final List<String> tabs = ["Shots", "Collections"];
  final List<String> socialIcons = [
    'assets/images/img_15.png',
    'assets/images/img_16.png',
    'assets/images/img_17.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Dispatch event to fetch posts via Bloc
      context.read<PostBloc>().add(PostByUserIdRequested(firebaseUser.uid));

      // Load user and collections data
      final appUser = await AppUser.getFromFirestore(firebaseUser.uid);
      final userCollections = await Collection.getUserCollections(firebaseUser.uid);
      if (mounted) {
        setState(() {
          _user = appUser;
          collections = userCollections;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header (không thay đổi)
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
                    '@${_user?.email.split('@')[0] ?? 'user'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
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
                    backgroundImage: ImageUtils.getImageProvider(_user?.imageUrl),
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
                    '${_user?.name ?? 'Unknown'} ${_user?.lastName ?? ''}'.trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (_user?.location ?? 'Unknown Location').trim(),
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Followers and Following (không thay đổi)
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
                          "${_user?.followers ?? 0}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Text("Followers",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        const SizedBox(width: 48),
                        Text(
                          "${_user?.following ?? 0}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Text("Following",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(socialIcons.length * 2 - 1, (index) {
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

                  // *** START: UPDATED TAB BAR ***
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        // Shots Tab with BlocBuilder
                        Expanded(
                          child: BlocBuilder<PostBloc, PostState>(
                            builder: (context, state) {
                              final count = state is PostListLoaded ? state.posts.length : 0;
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isSelected ? const Color(0xFF6A6BF4) : const Color(0xFFB8B8B8),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Collections Tab
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: selectedTab == 1 ? const Color(0xFF6A6BF4) : const Color(0xFFB8B8B8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // *** END: UPDATED TAB BAR ***

                  const SizedBox(height: 30),

                  // *** START: UPDATED CONTENT DISPLAY ***
                  selectedTab == 0
                      ? _buildPostGridOrEmpty() // Use new Bloc-based grid
                      : _buildCollections(),
                  // *** END: UPDATED CONTENT DISPLAY ***

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // *** START: NEW BLOC-BASED WIDGET FOR POSTS ***
  Widget _buildPostGridOrEmpty() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostListLoaded) {
          if (state.posts.isEmpty) {
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
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/img_18.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        } else if (state is PostFailure) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return const SizedBox.shrink(); // Return empty for initial state
      },
    );
  }
  // *** END: NEW BLOC-BASED WIDGET FOR POSTS ***

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
            context.push('/collection-detail', extra: {'collection': collection});
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