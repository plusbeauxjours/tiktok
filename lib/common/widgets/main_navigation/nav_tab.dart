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
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Function onTap 선언 시, () => onTap
        child: Container(
          color: selectedIndex == 0 || isDark ? Colors.black : Colors.white,
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.6,
            duration: const Duration(milliseconds: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 자식위젯이 차지하는 만큼을 최대 높이로 지정
              children: [
                FaIcon(
                  isSelected && selectedIcon != null ? selectedIcon : icon,
                  color: selectedIndex != 0 && !isDark
                      ? Colors.black
                      : Colors.white,
                ),
                Gaps.v5,
                Text(
                  text,
                  style: TextStyle(
                    color: selectedIndex != 0 && !isDark
                        ? Colors.black
                        : Colors.white,
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
