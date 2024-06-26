import 'package:flutter/material.dart';

class CstTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? hintText;
  final bool? autocorrect;
  final Widget? suffix;
  final String? errorText;
  final void Function(String?)? onChanged;
  final void Function()? onEditingComplete;

  const CstTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.obscureText,
    this.hintText,
    this.autocorrect,
    this.suffix,
    this.errorText,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      autocorrect: autocorrect ?? false,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
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
        suffix: suffix,
      ),
    );
  }
}
