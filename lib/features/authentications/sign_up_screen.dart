import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/log_in_screen.dart';
import 'package:tiktok/features/authentications/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void onLoginTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LogInScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              Text(
                'Sign up for TikTok',
                style: TextStyle(
                  fontSize: Sizes.size28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              Text(
                'Create a profile, follow other accounts, make your own videos, and more.',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w200,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v32,
              AuthButton(
                  icon: FaIcon(FontAwesomeIcons.user),
                  text: 'Use phone or email'),
              Gaps.v16,
              AuthButton(
                  icon: FaIcon(FontAwesomeIcons.facebook),
                  text: 'Continue with Facebook'),
              Gaps.v16,
              AuthButton(
                  icon: FaIcon(FontAwesomeIcons.apple),
                  text: 'Continue with Apple'),
              Gaps.v16,
              AuthButton(
                  icon: FaIcon(FontAwesomeIcons.google),
                  text: 'COntinue with Google'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade100,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size16,
          ),
          child: GestureDetector(
            onTap: () => onLoginTap(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.h5,
                Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
