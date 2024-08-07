import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/common/widgets/cst_text_form_field.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/authentications/view_models/login_view_model.dart';
import 'package:tiktok/features/authentications/widgets/form_button.dart';
import 'package:tiktok/utils/utils.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  LoginFormScreenState createState() => LoginFormScreenState();
}

class LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      ref.read(loginProvider.notifier).login(
            _formData["email"]!,
            _formData["password"]!,
            context,
          );
    }
  }

  void _onSavedFn(String field, String? newValue) {
    if (newValue != null) _formData[field] = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusout(context),
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
                CstTextFormField(
                  hintText: 'Email',
                  validator: (value) =>
                      value?.isEmpty ?? true ? "Please write your email" : null,
                  onSaved: (newValue) => _onSavedFn('email', newValue),
                ),
                Gaps.v16,
                CstTextFormField(
                  hintText: 'Password',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please write password' : null,
                  onSaved: (newValue) => _onSavedFn('password', newValue),
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmitTap,
                  child: FormButton(
                    disabled: ref.watch(loginProvider).isLoading,
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
