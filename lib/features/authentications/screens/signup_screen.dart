import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/screens/username_screen.dart';
import 'package:tiktok/features/authentications/view_models/social_auth_view_model.dart';
import 'package:tiktok/features/authentications/widgets/auth_button.dart';
import 'package:tiktok/features/authentications/screens/login_screen.dart';
import 'package:tiktok/generated/l10n.dart';
import 'package:tiktok/utils/utils.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeName = "signUp";
  static const routeURL = "/";

  const SignUpScreen({super.key});

  void _onLoginTap(BuildContext context) async {
    context.pushNamed(LoginScreen.routeName);
  }

  void _onEmailTap(BuildContext context) {
    navPush(context, const UsernameScreen());
  }

  Widget _buildAuthButton(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AuthButton(
        icon: FaIcon(icon),
        text: text,
      ),
    );
  }

  List<Widget> _buildAuthButtons(BuildContext context, WidgetRef ref) {
    return [
      _buildAuthButton(
        context,
        ref,
        icon: FontAwesomeIcons.user,
        text: S.of(context).emailPasswordButton,
        onTap: () => _onEmailTap(context),
      ),
      Gaps.v16,
      _buildAuthButton(
        context,
        ref,
        icon: FontAwesomeIcons.github,
        text: "Continue with Github",
        onTap: () =>
            ref.read(socialAuthProvider.notifier).githubSignIn(context),
      ),
      Gaps.v16,
      _buildAuthButton(
        context,
        ref,
        icon: FontAwesomeIcons.google,
        text: 'Continue with Google',
        onTap: () =>
            ref.read(socialAuthProvider.notifier).googleSignIn(context),
      ),
    ];
  }

  Widget _buildOrientationLayout(
      BuildContext context, WidgetRef ref, Orientation orientation) {
    final buttons = _buildAuthButtons(context, ref);
    return orientation == Orientation.portrait
        ? Column(children: buttons)
        : Row(
            children:
                buttons.map((button) => Expanded(child: button)).toList());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gaps.v80,
                  const Text(
                    "Sign up for TikTok",
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity: 0.7,
                    child: Text(
                      S.of(context).signUpSubtitle(13944),
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  _buildOrientationLayout(context, ref, orientation),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, ref),
        );
      },
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
            Text(
              S.of(context).alreadyHaveAnAccount,
              style: const TextStyle(
                fontSize: Sizes.size16,
              ),
            ),
            Gaps.h5,
            GestureDetector(
              onTap: () => _onLoginTap(context),
              child: Text(
                "Log in",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
