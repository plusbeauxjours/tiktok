import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils/utils.dart';

class InterestButton extends ConsumerStatefulWidget {
  const InterestButton({
    super.key,
    required this.interest,
  });

  final String interest;

  @override
  InterestButtonState createState() => InterestButtonState();
}

class InterestButtonState extends ConsumerState<InterestButton> {
  bool _isSelected = false;

  void _onTap() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
          horizontal: Sizes.size24,
        ),
        decoration: BoxDecoration(
          color: _isSelected
              ? Theme.of(context).primaryColor
              : isDarkMode(context, ref)
                  ? Colors.grey.shade700
                  : Colors.white,
          borderRadius: BorderRadius.circular(Sizes.size32),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 5,
            )
          ],
        ),
        child: Text(
          widget.interest,
          style: TextStyle(
            fontSize: 16,
            color: _isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
