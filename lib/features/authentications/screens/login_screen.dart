import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/screens/login_form_screen.dart';
import 'package:tiktok/features/authentications/view_models/social_auth_view_model.dart';
import 'package:tiktok/features/authentications/widgets/auth_button.dart';
import 'package:tiktok/utils/utils.dart';

class LoginScreen extends ConsumerWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Log in to TikTok',
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "Manage your account, check notifications, comment on videos, and more.",
                  style: TextStyle(fontSize: Sizes.size16),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              _buildAuthButton(
                icon: FontAwesomeIcons.user,
                text: 'Use email & password',
                onTap: () => navPush(context, const LoginFormScreen()),
              ),
              Gaps.v16,
              _buildAuthButton(
                icon: FontAwesomeIcons.github,
                text: "Continue with Github",
                onTap: () =>
                    ref.read(socialAuthProvider.notifier).githubSignIn(context),
              ),
              Gaps.v16,
              _buildAuthButton(
                icon: FontAwesomeIcons.google,
                text: 'Continue with Google',
                onTap: () =>
                    ref.read(socialAuthProvider.notifier).googleSignIn(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, ref),
    );
  }

  Widget _buildAuthButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AuthButton(icon: FaIcon(icon), text: text),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref) {
    return Container(
      color: isDarkMode(context, ref)
          ? Theme.of(context).appBarTheme.backgroundColor
          : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.size32,
          bottom: Sizes.size64,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            Gaps.h5,
            GestureDetector(
              onTap: () => navPop(context),
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
