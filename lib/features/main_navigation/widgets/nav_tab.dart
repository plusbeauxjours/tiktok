import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/utils/utils.dart';

class NavTab extends ConsumerWidget {
  const NavTab({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIndex,
    this.selectedIcon,
  });

  final String text;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;
  final int selectedIndex;
  final IconData? selectedIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context, ref);
    final backgroundColor =
        selectedIndex == 0 || isDark ? Colors.black : Colors.white;
    final contentColor =
        backgroundColor == Colors.black ? Colors.white : Colors.black;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: backgroundColor,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.6,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? (selectedIcon ?? icon) : icon,
                  color: contentColor,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: TextStyle(color: contentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
