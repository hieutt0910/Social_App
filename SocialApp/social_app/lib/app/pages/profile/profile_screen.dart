import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/app/bloc/account/account_bloc.dart';
import 'package:social_app/app/bloc/account/account_event.dart';
import 'package:social_app/app/bloc/account/account_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/model/user.dart';

import '../../utils/image_base64.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    // Gửi sự kiện yêu cầu tải dữ liệu ngay khi trang được tạo
    context.read<AccountBloc>().add(AccountDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountSignOutSuccess) {
            context.go('/sign-in');
          }
          if (state is AccountLoadFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (state is AccountLoadSuccess) {
            return _buildSuccessUI(context, state.user);
          }
          if (state is AccountLoadFailure) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          // Trạng thái mặc định (trống)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Widget xây dựng giao diện chính khi có dữ liệu người dùng
  Widget _buildSuccessUI(BuildContext context, AppUser user) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/img_9.png', fit: BoxFit.cover),
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // User Info Header
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
                        onTap: () => context.push('/user-profile'),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundImage: ImageUtils.getImageProvider(user.imageUrl),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${user.name ?? 'Unknown'} ${user.lastName ?? ''}'.trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email ?? 'No email',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () => context.push('/edit-profile'),
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
              // Menu List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildItem(context: context, label: "Email", user: user),
                    _buildItem(context: context, label: "Instagram", user: user),
                    _buildItem(context: context, label: "Twitter", user: user),
                    _buildItem(context: context, label: "Website", user: user),
                    _buildItem(context: context, label: "Paypal", user: user),
                    _buildItem(context: context, label: "Change password", user: user, routeName: '/change-password'),
                    _buildItem(context: context, label: "About i.click", user: user),
                    _buildItem(context: context, label: "Terms & privacy", user: user, routeName: '/terms'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Logout Button
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Gửi sự kiện đăng xuất đến BLoC, logic sẽ do BLoC xử lý
                      context.read<AccountBloc>().add(AccountSignedOut());
                    },
                    icon: const Icon(Icons.logout, color: Colors.black, size: 24),
                    label: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget xây dựng từng mục trong menu
  // Không cần thay đổi nhiều, chỉ đảm bảo nó nhận `user` từ `_buildSuccessUI`
  Widget _buildItem({
    required BuildContext context,
    required String label,
    required AppUser user,
    String? routeName,
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
                    path: user.email ?? '',
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
                  if (user.instagram != null && user.instagram!.isNotEmpty) {
                    String igHandle = user.instagram!.startsWith('@')
                        ? user.instagram!.substring(1)
                        : user.instagram!;
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
                  if (user.twitter != null && user.twitter!.isNotEmpty) {
                    String twitterHandle = user.twitter!.startsWith('@')
                        ? user.twitter!.substring(1)
                        : user.twitter!;
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
                  if (user.website != null && user.website!.isNotEmpty) {
                    url = user.website!;
                    await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                  }
                  break;
                case "Terms & privacy":
                  if (user.terms != null && user.terms!.isNotEmpty) {
                    url = user.terms!;
                    await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                  }
                  break;
                default:
                  if(routeName != null) {
                    context.push(routeName);
                  }
                  return;
              }
            },
          ),
        ),
      ),
    );
  }
}