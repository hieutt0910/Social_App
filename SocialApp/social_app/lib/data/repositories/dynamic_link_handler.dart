import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLinksHandler {

  static Future<void> initDynamicLinks(GoRouter router) async {
    // Lắng nghe khi app đang mở
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;
      if (deepLink != null) {
        await _handleDynamicLink(router, deepLink);
      }
    });

    // Xử lý link ban đầu khi app được mở từ trạng thái terminated
    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri? deepLink = initialLink.link;
      if (deepLink != null) {
        await _handleDynamicLink(router, deepLink);
      }
    }
  }

  static Future<void> _handleDynamicLink(GoRouter router, Uri deepLink) async {
    print('Handling deep link: $deepLink');
    final prefs = await SharedPreferences.getInstance();
    final email = deepLink.queryParameters['email'] ?? prefs.getString('pending_email') ?? '';
    final otp = deepLink.queryParameters['otp'];
    final fromRoute = deepLink.queryParameters['fromRoute'] ?? 'sign_in';

    print('Email from link or prefs: $email');
    print('OTP from link: $otp');
    print('Route retrieved from SharedPreferences: $fromRoute');

    if (otp != null) {
      await prefs.setString('pending_otp', otp);
      print('OTP saved to SharedPreferences: $otp');
    }

    if (email.isNotEmpty) {
      router.go('/verify', extra: {'email': email, 'fromRoute': fromRoute});
    } else {
      print('No valid email found in link or SharedPreferences');
    }
  }

  static Future<void> sendSignInLink(String email, {String? fromRoute}) async {
    try {
      String otp = (100000 + Random().nextInt(900000)).toString();
      String url = 'https://socialapp678.page.link/verify?otp=$otp&email=$email&fromRoute=$fromRoute';
      print('Sending link with URL: $url');

      var actionCodeSettings = ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
        androidPackageName: 'com.example.social_app',
        androidInstallApp: true,
        androidMinimumVersion: '12',
        dynamicLinkDomain: 'socialapp678.page.link',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', email);
      await prefs.setString('pending_otp', otp);
      if (fromRoute != null) {
        await prefs.setString('from_route', fromRoute);
      }
      print('Saved pending email: $email');
      print('Saved pending OTP: $otp');
      print('Saved fromRoute: $fromRoute');

      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      print('Sent verification link to: $email');
    } catch (e) {
      print('Error sending link: $e');
    }
  }

}