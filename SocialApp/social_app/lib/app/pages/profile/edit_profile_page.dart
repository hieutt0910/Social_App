
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:social_app/app/bloc/edit_profile/edit_profile_event.dart';
import 'package:social_app/app/bloc/edit_profile/edit_profile_state.dart';
import 'package:social_app/data/model/user.dart';

import '../../utils/image_base64.dart';
import '../../widgets/Button.dart';
import '../../widgets/text.dart';
import '../../widgets/textfield.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _twitterController = TextEditingController();
  final _websiteController = TextEditingController();
  final _termsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EditProfileBloc>().add(EditProfileDataRequested());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _websiteController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final data = {
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'location': _locationController.text,
      'instagram': _instagramController.text,
      'twitter': _twitterController.text,
      'website': _websiteController.text,
      'terms': _termsController.text,
    };
    context.read<EditProfileBloc>().add(EditProfileChangesSaved(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      // Chỉ lắng nghe khi trạng thái submit thay đổi
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.pop();
        }
        if (state.status == EditProfileStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: BlocBuilder<EditProfileBloc, EditProfileState>(
          // Chỉ build lại UI khi user hoặc ảnh thay đổi
          buildWhen: (previous, current) =>
          previous.user != current.user ||
              previous.selectedImage != current.selectedImage,
          builder: (context, state) {
            // Cập nhật text cho controllers khi có dữ liệu user lần đầu
            if (state.user != null && _nameController.text.isEmpty) {
              _nameController.text = state.user!.name;
              _lastNameController.text = state.user!.lastName;
              _locationController.text = state.user!.location;
              _emailController.text = state.user!.email;
              _instagramController.text = state.user!.instagram ?? '';
              _twitterController.text = state.user!.twitter ?? '';
              _websiteController.text = state.user!.website ?? '';
              _termsController.text = state.user!.terms ?? '';
            }

            if (state.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return _buildFormUI(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildFormUI(BuildContext context, EditProfileState state) {
    return Column(
      children: [
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
              top: MediaQuery.of(context).padding.top + 15,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            const Positioned(
              top: 55, left: 0, right: 0,
              child: Center(
                child: Text("Edit profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              bottom: -55, left: 0, right: 0,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => context.read<EditProfileBloc>().add(EditProfileImagePicked()),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: state.selectedImage != null
                            ? FileImage(state.selectedImage!)
                            : ImageUtils.getImageProvider(state.user?.imageUrl),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Image.asset('assets/images/img_14.png', width: 24, height: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 10, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                FormLabel(text: 'Name'),
                CustomInputField(controller: _nameController, hintText: 'Name',),
                const SizedBox(height: 18),
                FormLabel(text: 'Last Name'),
                CustomInputField(controller: _lastNameController, hintText: 'Last Name',),
                const SizedBox(height: 18),
                FormLabel(text: 'Location'),
                CustomInputField(controller: _locationController, hintText: 'Location',),
                const SizedBox(height: 18),
                FormLabel(text: 'Email'),
                CustomInputField(controller: _emailController, enabled: false, hintText: 'Email',),
                const SizedBox(height: 18),
                FormLabel(text: 'Instagram'),
                CustomInputField(hintText: "@username or URL", controller: _instagramController),
                const SizedBox(height: 18),
                FormLabel(text: 'Twitter'),
                CustomInputField(hintText: "@username or URL", controller: _twitterController),
                const SizedBox(height: 18),
                FormLabel(text: 'Website'),
                CustomInputField(hintText: "URL", controller: _websiteController),
                const SizedBox(height: 18),
                FormLabel(text: 'Terms & Privacy'),
                CustomInputField(hintText: "URL", controller: _termsController),
                const SizedBox(height: 40),
                // Lấy trạng thái loading từ BLoC
                BlocBuilder<EditProfileBloc, EditProfileState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    return CustomButton(
                      text: 'SAVE CHANGES',
                      onPressed: _saveChanges,
                      isLoading: state.status == EditProfileStatus.loading,
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}