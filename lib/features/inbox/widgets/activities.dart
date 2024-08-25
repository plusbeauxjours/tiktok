import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/rawData/inboxs.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils/utils.dart';

class Activities extends ConsumerWidget {
  final void Function(String) onDismissed;
  final Animation<Offset> panelAnimation;
  final bool showBarrier;
  final Animation<Color?> barrierAnimation;
  final void Function() toggleAnimations;

  const Activities({
    Key? key,
    required this.onDismissed,
    required this.panelAnimation,
    required this.showBarrier,
    required this.barrierAnimation,
    required this.toggleAnimations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context, ref);
    return Stack(
      children: [
        _buildNotificationList(context, isDark),
        if (showBarrier) _buildAnimatedBarrier(),
        _buildSlidePanel(context),
      ],
    );
  }

  Widget _buildNotificationList(BuildContext context, bool isDark) {
    return ListView(
      children: [
        Gaps.v14,
        _buildSectionTitle(context),
        Gaps.v14,
        ...notifications.map((notification) =>
            _buildNotificationTile(context, notification, isDark)),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
      child: Text(
        'New',
        style: TextStyle(
          fontSize: Sizes.size14,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
      BuildContext context, String notification, bool isDark) {
    return Dismissible(
      key: Key(notification),
      onDismissed: (direction) => onDismissed(notification),
      background: _buildDismissibleBackground(
        color: Colors.green,
        icon: FontAwesomeIcons.checkDouble,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildDismissibleBackground(
        color: Colors.red,
        icon: FontAwesomeIcons.trashCan,
        alignment: Alignment.centerRight,
      ),
      child: ListTile(
        minVerticalPadding: Sizes.size16,
        leading: _buildLeadingIcon(isDark),
        title: _buildNotificationText(notification, isDark),
        trailing: const FaIcon(
          FontAwesomeIcons.chevronRight,
          size: Sizes.size16,
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground({
    required Color color,
    required IconData icon,
    required AlignmentGeometry alignment,
  }) {
    return Container(
      alignment: alignment,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size10),
        child: FaIcon(
          icon,
          color: Colors.white,
          size: Sizes.size24,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(bool isDark) {
    return Container(
      width: Sizes.size52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.grey.shade800 : Colors.white,
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
          width: Sizes.size1,
        ),
      ),
      child: const Center(
        child: FaIcon(FontAwesomeIcons.bell),
      ),
    );
  }

  Widget _buildNotificationText(String notification, bool isDark) {
    return RichText(
      text: TextSpan(
        text: "Account updates:",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: Sizes.size16,
          color: isDark ? null : Colors.black,
        ),
        children: [
          const TextSpan(
            text: "Upload longer videos",
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: " $notification",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBarrier() {
    return AnimatedModalBarrier(
      color: barrierAnimation,
      dismissible: true,
      onDismiss: toggleAnimations,
    );
  }

  Widget _buildSlidePanel(BuildContext context) {
    return SlideTransition(
      position: panelAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(Sizes.size5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var tab in tabs)
              ListTile(
                title: Row(
                  children: [
                    Icon(tab["icon"], size: Sizes.size16),
                    Gaps.h20,
                    Text(
                      tab['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
