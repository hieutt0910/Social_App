
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Data/model/user.dart';
import '../../utils/image_base64.dart';

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
                            backgroundImage: ImageUtils.getImageProvider(_user?.imageUrl),
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
                      _buildItem(context: context, label: "Email", routeName: '/email'),
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
                  padding: const EdgeInsets.only(left: 16, bottom: 30),
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
            onTap: () async {
              String? url;
              switch (label) {
                case "Email":
                  String? encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((MapEntry<String, String> e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&');
                  }
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: _user?.email ?? '',
                    query: encodeQueryParameters({
                      'subject': 'Contact me',
                      'body': 'Hello, This is Social App',
                    }),
                  );
                  if(await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch email app')),
                    );
                  }
                  break;
                case "Paypal":
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paypal has not been set up')),
                  );
                  break;
                case "About i.click":
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Social App - Connect and share with your community')),
                  );
                  break;
                case "Instagram":
                  if (_user?.instagram != null && _user!.instagram!.isNotEmpty) {
                    String igHandle = _user!.instagram!.startsWith('@')
                        ? _user!.instagram!.substring(1)
                        : _user!.instagram!;
                    url = 'https://www.instagram.com/$igHandle';
                    String deepLink = 'instagram://user?username=$igHandle';
                    if (await canLaunchUrl(Uri.parse(deepLink))) {
                      await launchUrl(Uri.parse(deepLink), mode: LaunchMode.externalApplication);
                    } else {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                    }
                  }
                  break;
                case "Twitter":
                  if (_user?.twitter != null && _user!.twitter!.isNotEmpty) {
                    String twitterHandle = _user!.twitter!.startsWith('@')
                        ? _user!.twitter!.substring(1)
                        : _user!.twitter!;
                    url = 'https://x.com/$twitterHandle';
                    String deepLink = 'twitter://user?screen_name=$twitterHandle';
                    if (await canLaunchUrl(Uri.parse(deepLink))) {
                      await launchUrl(Uri.parse(deepLink), mode: LaunchMode.externalApplication);
                    } else {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                    }
                  }
                  break;
                case "Website":
                  if (_user?.website != null && _user!.website!.isNotEmpty) {
                    url = _user!.website!;
                    await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                  }
                  break;
                case "Terms & privacy":
                  if (_user?.terms != null && _user!.terms!.isNotEmpty) {
                    url = _user!.terms!;
                    await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                  }
                  break;
                default:
                  context.push(routeName);
                  return;
              }
            },
          ),
        ),
      ),
    );
  }
}