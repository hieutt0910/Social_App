import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../Data/model/user.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/Text.dart';
import '../../Widgets/Textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _termsController = TextEditingController();
  bool _isLoading = false;
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
          _nameController.text = appUser.name;
          _lastNameController.text = appUser.lastName;
          _emailController.text = appUser.email;
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_isLoading || _user == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _user!.updateInFirestore(
          name: _nameController.text.trim(),
          lastName: _lastNameController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _websiteController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                top: MediaQuery.of(context).padding.top + 30,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 40,
                left: 0,
                right: 0,
                child: const Center(
                  child: Text(
                    "Edit profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -55,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _user?.imageUrl != null
                            ? NetworkImage(_user!.imageUrl!)
                            : const AssetImage('assets/images/img_10.png') as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/images/img_14.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    FormLabel(text: 'Name'),
                    CustomInputField(
                      hintText: "Name",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Last Name'),
                    CustomInputField(
                        hintText: "Last Name",
                        controller: _lastNameController,
                    ),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Email'),
                    CustomInputField(
                      hintText: "Email",
                      controller: _emailController,
                      enabled: false,
                    ),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Instagram'),
                    CustomInputField(
                      hintText: "@username",
                      controller: _instagramController,
                    ),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Twitter'),
                    CustomInputField(
                      hintText: "@username",
                      controller: _twitterController,
                    ),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Website'),
                    CustomInputField(
                      hintText: "Website URL",
                      controller: _websiteController,
                    ),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Terms & Privacy'),
                    CustomInputField(
                      hintText: "Terms URL",
                      controller: _termsController,
                    ),
                    const SizedBox(height: 280),
                    CustomButton(
                      text: 'SAVE CHANGES',
                      onPressed: _saveChanges,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}