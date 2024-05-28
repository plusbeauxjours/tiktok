import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';
import 'package:tiktok/features/onboarding/screens/interests_screen.dart';
import 'package:tiktok/utils/utils.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        Utils.navPushAndRemoveUntil(
          context,
          const InterestsScreen(),
          (route) => false,
        );
      }
    }
  }

  void _onSavedFn(String field, String? newValue) {
    if (newValue != null) formData[field] = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.focusout(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please write your email";
                    }
                    return null;
                  },
                  onSaved: (newValue) => _onSavedFn('email', newValue),
                ),
                Gaps.v16,
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please write password';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _onSavedFn('password', newValue),
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: const FormButton(
                    disabled: false,
                    text: 'Log in',
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
