import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/common/widgets/cst_text_field.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/screens/email_screen.dart';
import 'package:tiktok/features/authentications/view_models/signup_view_model.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';
import 'package:tiktok/utils/utils.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({Key? key}) : super(key: key);

  @override
  UsernameScreenState createState() => UsernameScreenState();
}

class UsernameScreenState extends ConsumerState<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateUsername);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_updateUsername);
    _usernameController.dispose();
    super.dispose();
  }

  void _updateUsername() {
    setState(() {
      _username = _usernameController.text;
    });
  }

  void _onNextTap() {
    if (_username.isEmpty) return;
    ref.read(signUpForm.notifier).state = {"username": _username};
    navPush(context, EmailScreen(username: _username));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusout(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Sign up'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,
              const Text(
                'Create username',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              const Text(
                'You can always change this later.',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black54,
                ),
              ),
              Gaps.v28,
              CstTextField(
                controller: _usernameController,
                hintText: 'Username',
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onNextTap,
                child: FormButton(disabled: _username.isEmpty),
              )
            ],
          ),
        ),
      ),
    );
  }
}
