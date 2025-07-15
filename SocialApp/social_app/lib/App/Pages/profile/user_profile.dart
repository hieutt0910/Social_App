import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../../Data/model/collection.dart';
import '../../../Data/model/user.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int selectedTab = 0;
  AppUser? _user;

  final List<String> tabs = ["shots", "Collections"];

  final List<String> socialIcons = [
    'assets/images/img_15.png',
    'assets/images/img_16.png',
    'assets/images/img_17.png',
  ];

  final List<String> shotImages = [
    'assets/images/img_19.png',
    'assets/images/img_20.png',
    'assets/images/img_21.png',
    'assets/images/img_22.png',
  ];

  final List<Collection> collections = [
    Collection(
      title: 'Your Likes',
      coverImage: 'assets/images/img_23.png',
      images: [
        'assets/images/img_19.png',
        'assets/images/img_20.png',
      ],
    ),
    Collection(
      title: 'Download',
      coverImage: 'assets/images/img_24.png',
      images: [
        'assets/images/img_21.png',
        'assets/images/img_22.png',
      ],
    ),
    Collection(
      title: 'Photography',
      coverImage: 'assets/images/img_25.png',
      images: [
        'assets/images/img_19.png',
        'assets/images/img_20.png',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final appUser = await AppUser.getFromFirestore(firebaseUser.uid);
      if (appUser != null) {
        setState(() {
          _user = appUser;
        });
      }
    }
  }

  // Hàm kiểm tra xem chuỗi có phải là base64 hợp lệ
  bool _isBase64(String? str) {
    if (str == null || str.isEmpty) return false;
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Hàm lấy ImageProvider cho ảnh đại diện
  ImageProvider _getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/images/avatar.jpg');
    }
    if (_isBase64(imageUrl)) {
      return MemoryImage(base64Decode(imageUrl));
    }
    return NetworkImage(imageUrl);
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
                    backgroundImage: _getImageProvider(_user?.imageUrl),
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
                  const Text(
                    "Da Nang, Vietnam",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
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
                      children: const [
                        Text("220", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(width: 4),
                        Text("Followers", style: TextStyle(color: Colors.grey, fontSize: 16)),
                        SizedBox(width: 48),
                        Text("150", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(width: 4),
                        Text("Following", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Social Icons + Dot
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

                  // Tab Bar with actual count
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = selectedTab == index;
                        final count = index == 0 ? shotImages.length : collections.length;

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
                                color: isSelected ? const Color(0xFFF1F1FE) : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "$count ${tabs[index]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isSelected
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
                      ? _buildGridOrEmpty(shotImages)
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

  Widget _buildGridOrEmpty(List<String> images) {
    if (images.isEmpty) {
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
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            images[index],
            fit: BoxFit.cover,
          ),
        );
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
                    child: Image.asset(
                      collection.coverImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 166,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 166,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${collection.images.length} shots',
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