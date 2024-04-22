import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/rawData/inboxs.dart';
import 'package:tiktok/constants/sizes.dart';

class Activities extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Gaps.v14,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size12,
              ),
              child: Text(
                'New',
                style: TextStyle(
                  fontSize: Sizes.size14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            Gaps.v14,
            for (var notification in notifications)
              Dismissible(
                key: Key(notification),
                onDismissed: (direction) => onDismissed(notification),
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.green,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: Sizes.size10,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.checkDouble,
                      color: Colors.white,
                      size: Sizes.size24,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.only(
                      right: Sizes.size10,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.white,
                      size: Sizes.size24,
                    ),
                  ),
                ),
                child: ListTile(
                  minVerticalPadding: Sizes.size16,
                  leading: Container(
                    width: Sizes.size52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: Sizes.size1,
                      ),
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.bell,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: "Account updates:",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: Sizes.size16,
                      ),
                      children: [
                        const TextSpan(
                          text: " Upload longer videos",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
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
                  ),
                  trailing: const FaIcon(
                    FontAwesomeIcons.chevronRight,
                    size: Sizes.size16,
                  ),
                ),
              )
          ],
        ),
        if (showBarrier)
          AnimatedModalBarrier(
            color: barrierAnimation,
            dismissible: true,
            onDismiss: toggleAnimations,
          ),
        SlideTransition(
          position: panelAnimation,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  Sizes.size5,
                ),
                bottomRight: Radius.circular(
                  Sizes.size5,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var tab in tabs)
                  ListTile(
                    title: Row(
                      children: [
                        FaIcon(
                          tab["icon"],
                          color: Colors.black,
                          size: Sizes.size16,
                        ),
                        Gaps.h20,
                        Text(
                          tab['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
