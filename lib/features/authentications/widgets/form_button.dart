import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils/utils.dart';

class FormButton extends ConsumerWidget {
  const FormButton({
    super.key,
    required this.disabled,
    this.text = '',
  });

  final bool disabled;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size5),
          color: disabled
              ? isDarkMode(context, ref)
                  ? Colors.grey.shade800
                  : Colors.grey.shade300
              : Theme.of(context).primaryColor,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: disabled ? Colors.grey : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          child: Text(
            text.isNotEmpty ? text : 'Next',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
