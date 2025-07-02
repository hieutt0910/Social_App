import 'package:final_project/Reuse/Text.dart';
import 'package:flutter/material.dart';
import '../Reuse/Button.dart';
import '../Reuse/TextField.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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


              // Back icon
              Positioned(
                top: MediaQuery.of(context).padding.top + 30,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // Title
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

              // Avatar
              Positioned(
                bottom: -55,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/img_10.png'),
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

          // Phần nội dung form
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
                    SizedBox(height: 40,),
                    FormLabel(text: 'Name'),
                    const CustomInputField(hintText: "Email"),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Last Name'),
                    const CustomInputField(hintText: "Name"),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Email'),
                    const CustomInputField(hintText: "brunopham@gmail.com"),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Instagram'),
                    const CustomInputField(hintText: "@brunopham"),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Twitter'),
                    const CustomInputField(hintText: "@brunopham"),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Website'),
                    const CustomInputField(hintText: "www.brunopham.com"),
                    const SizedBox(height: 18),
                    FormLabel(text: 'Terms & Privacy'),
                    const CustomInputField(hintText: "www.brunopham.com/terms"),

                    const SizedBox(height: 280),
                    CustomButton(
                      text: 'SAVE CHANGES',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
