import 'package:flutter/material.dart';
import '../../Widgets/Button.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  int? _selectedIndex;

  final List<String> roleImages = [
    "assets/images/img_3.png",
    "assets/images/img_4.png",
    "assets/images/img_7.png",
    "assets/images/img_8.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top image with curve
          ClipPath(
            child: Image.asset(
              'assets/images/img_2.png',
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Expanded content with padding and scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Who are you?",
                    style: TextStyle(
                      fontSize: 20  ,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF242424),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Grid images
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: roleImages.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedIndex == index
                                  ? const Color(0xFF5151C6)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              roleImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [Color(0xFF888BF4), Color(0xFF5151C6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                    },
                    child: const Text(
                      "SHARE - INSPIRE - CONNECT",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Bắt buộc dùng trắng để gradient hiển thị đúng
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Reusable Button
                  CustomButton(
                    text: 'EXPLORE NOW',
                    onPressed: () {
                      Navigator.pushNamed(context, '/widget_tree');
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}