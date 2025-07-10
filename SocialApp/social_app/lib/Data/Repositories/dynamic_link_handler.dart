import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLinksHandler {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final StreamController<void> _linkHandledStream = StreamController<void>.broadcast();

  static Stream<void> get onLinkHandled => _linkHandledStream.stream;

  static Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      print('Received deep link: $deepLink');
      if (deepLink != null) {
        await _handleDynamicLink(deepLink);
        _linkHandledStream.add(null);
      }
    });

    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri? deepLink = initialLink.link;
      print('Received initial link: $deepLink');
      if (deepLink != null) {
        await _handleDynamicLink(deepLink);
        _linkHandledStream.add(null);
      }
    }
  }

  static Future<void> _handleDynamicLink(Uri deepLink) async {
    print('Handling deep link: $deepLink');
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('pending_email') ?? '';
    print('Pending email: $email');

    String? otp = deepLink.queryParameters['otp'];
    print('OTP from link: $otp');
    if (otp != null) {
      await prefs.setString('pending_otp', otp);
      print('OTP saved to SharedPreferences: $otp');
    }

    if (email.isNotEmpty) {
      navigatorKey.currentState?.pushReplacementNamed('/verify', arguments: email);
    }
  }

  static Future<void> sendSignInLink(String email, {Map<String, String>? customParams}) async {
    try {
      String otp = (100000 + Random().nextInt(900000)).toString();
      String url = 'https://socialapp678.page.link?otp=$otp&email=$email';
      print('Gửi link với URL: $url');

      var actionCodeSettings = ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
        androidPackageName: 'com.example.final_project',
        androidInstallApp: true,
        androidMinimumVersion: '12',
        dynamicLinkDomain: 'socialapp678.page.link',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_email', email);
      await prefs.setString('pending_otp', otp);
      print('Đã lưu email đang chờ: $email');
      print('Đã lưu OTP đang chờ: $otp');

      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
      print('Đã gửi link xác thực tới: $email');
    } catch (e) {
      print('Lỗi khi gửi link: $e');
    }
  }

  static void dispose() {
    _linkHandledStream.close();
  }
}