import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/common/widgets/main_navigation/nav_tab.dart';
import 'package:tiktok/common/widgets/main_navigation/post_video_button.dart';
import 'package:tiktok/constants/rawData/discovers.dart';
import 'package:tiktok/utils/utils.dart';

class CustomNavigation extends ConsumerWidget {
  final int selectedIndex;
  final void Function(int selectedIdx) onTap;
  final void Function() onHover;
  final bool isVideoButtonHovered;
  final void Function() onLongPressUp;
  final void Function(LongPressDownDetails longPressDownDetails)?
      onLongPressDown;

  const CustomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.onHover,
    required this.isVideoButtonHovered,
    required this.onLongPressUp,
    this.onLongPressDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context, ref);
    return Container(
      color: selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var nav in navs)
            navs.indexOf(nav) != 2
                ? NavTab(
                    text: nav['title'],
                    icon: nav['icon'],
                    isSelected: selectedIndex == navs.indexOf(nav),
                    onTap: () => onTap(navs.indexOf(nav)),
                    selectedIndex: selectedIndex,
                  )
                : PostVideoButton(
                    isVideoButtonHovered: isVideoButtonHovered,
                    onHover: onHover,
                    inverted: selectedIndex != 0,
                    onLongPressDown: onLongPressDown,
                    onLongPressUp: onLongPressUp,
                  ),
        ],
      ),
    );
  }
}
