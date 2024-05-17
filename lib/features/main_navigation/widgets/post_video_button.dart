import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils/common_utils.dart';

class PostVideoButton extends StatefulWidget {
  final bool isVideoButtonHovered;
  final VoidCallback onHover;
  final bool inverted;

  const PostVideoButton({
    super.key,
    required this.isVideoButtonHovered,
    required this.onHover,
    required this.inverted,
  });

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton> {
  double heightAni() => widget.isVideoButtonHovered ? 40 : 30;
  double widthAni() => widget.isVideoButtonHovered ? 35 : 25;
  double sizeAni([double? iconSize]) =>
      widget.isVideoButtonHovered ? Sizes.size24 : iconSize ?? Sizes.size8;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) => widget.onHover(),
      onExit: (e) => widget.onHover(),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: widget.isVideoButtonHovered ? 1 : 0.9,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 20,
              child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                height: heightAni(),
                width: widthAni(),
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                decoration: BoxDecoration(
                  color: widget.isVideoButtonHovered
                      ? Colors.blue
                      : const Color(0xff61D4F0),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(sizeAni()),
                    right: Radius.zero,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                height: heightAni(),
                width: widthAni(),
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                decoration: BoxDecoration(
                  color: widget.isVideoButtonHovered
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.zero,
                    right: Radius.circular(sizeAni()),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              height: heightAni(),
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
              decoration: BoxDecoration(
                color: !widget.inverted || isDark ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(sizeAni()),
              ),
              child: Center(
                child: AnimatedSize(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 600),
                  child: FaIcon(
                    widget.isVideoButtonHovered
                        ? FontAwesomeIcons.camera
                        : FontAwesomeIcons.plus,
                    color: !widget.inverted || isDark
                        ? Colors.black
                        : Colors.white,
                    size: sizeAni(Sizes.size16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
