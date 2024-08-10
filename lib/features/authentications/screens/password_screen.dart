import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/common/widgets/cst_text_field.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/screens/birthday_screen.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';
import 'package:tiktok/features/authentications/view_models/signup_view_model.dart';
import 'package:tiktok/features/authentications/widgets/suffix_icons.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  PasswordScreenState createState() => PasswordScreenState();
}

class PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _password = '';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePassword);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePassword);
    _passwordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    setState(() {
      _password = _passwordController.text;
    });
  }

  bool _isPasswordLengthValid() =>
      _password.isNotEmpty && _password.length >= 8 && _password.length <= 20;

  bool _isPasswordValid() {
    final regExp = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,20}$');
    return regExp.hasMatch(_password);
  }

  void _onSubmit() {
    if (!_isPasswordValid()) return;
    ref
        .read(signUpForm.notifier)
        .update((state) => {...state, "password": _password});
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const BirthdayScreen()));
  }

  void _toggleObscureText() => setState(() => _obscureText = !_obscureText);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                'Password?',
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v28,
              CstTextField(
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                obscureText: _obscureText,
                autocorrect: false,
                onEditingComplete: _onSubmit,
                hintText: 'Make it strong!',
                suffix: SuffixIcons(
                  obscureText: _obscureText,
                  onClearTap: () => _passwordController.clear(),
                  toggleObscureText: _toggleObscureText,
                ),
              ),
              Gaps.v10,
              const Text(
                'Your password must have:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Gaps.v10,
              _buildPasswordRequirement(
                _isPasswordLengthValid(),
                '8 to 20 characters',
              ),
              Gaps.v5,
              _buildPasswordRequirement(
                _isPasswordValid(),
                'Letters, numbers, and special characters',
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmit,
                child: FormButton(disabled: !_isPasswordValid()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(bool isValid, String text) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.circleCheck,
          size: Sizes.size20,
          color: isValid ? Colors.green : Theme.of(context).disabledColor,
        ),
        Gaps.h5,
        Text(text),
      ],
    );
  }
}
