import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';

class VideoBgmInfo extends StatelessWidget {
  const VideoBgmInfo({
    super.key,
    required String bgmInfo,
  }) : _bgmInfo = bgmInfo;

  final String _bgmInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '♫',
          style: TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16,
          ),
        ),
        Gaps.h10,
        Expanded(
          child: MarqueeText(
            text: TextSpan(
              text: _bgmInfo,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size16,
            ),
            speed: 20,
            alwaysScroll: true,
          ),
        ),
      ],
    );
  }
}
