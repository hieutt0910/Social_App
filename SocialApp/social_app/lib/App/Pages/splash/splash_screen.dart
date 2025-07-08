import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/boarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SHARE - INSPIRE - CONNECT',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.pushReplacementNamed(context, '/widget_tree');
                    } else {
                      Navigator.pushReplacementNamed(context, '/sign in');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x4DD0D0D0),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'GET STARTED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}