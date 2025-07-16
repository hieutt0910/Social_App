import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Data/model/user.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AppUser? _user;

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
    // Nếu là URL (như từ Google), dùng NetworkImage
    return NetworkImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img_9.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push('/user-profile');
                          },
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: _getImageProvider(_user?.imageUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_user?.name ?? 'Unknown'} ${_user?.lastName ?? ''}'.trim(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _user?.email ?? 'No email',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              context.push('/edit-profile');
                            },
                            child: Image.asset(
                              'assets/images/img_11.png',
                              width: 30,
                              height: 30,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 0),
                    children: [
                      _buildItem(context: context, label: "Email", routeName: '/other-profile'),
                      _buildItem(context: context, label: "Instagram", routeName: '/instagram'),
                      _buildItem(context: context, label: "Twitter", routeName: '/twitter'),
                      _buildItem(context: context, label: "Website", routeName: '/website'),
                      _buildItem(context: context, label: "Paypal", routeName: '/paypal'),
                      _buildItem(context: context, label: "Change password", routeName: '/change-password'),
                      _buildItem(context: context, label: "About i.click", routeName: '/about'),
                      _buildItem(context: context, label: "Terms & privacy", routeName: '/terms'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 36, bottom: 80),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        context.go('/sign-in');
                      },
                      icon: const Icon(Icons.logout, color: Colors.black, size: 24),
                      label: const Text(
                        "Log out",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String label,
    required String routeName,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.7,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 16, right: 8),
            title: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: Image.asset(
              'assets/images/img_13.png',
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            onTap: () {
              context.push(routeName);
            },
          ),
        ),
      ),
    );
  }
}