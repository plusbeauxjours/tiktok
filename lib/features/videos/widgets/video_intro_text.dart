import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tiktok/constants/sizes.dart';

class VideoIntroText2 extends StatelessWidget {
  const VideoIntroText2({
    super.key,
    required String descText,
    required FontWeight mainTextBold,
  })  : _descText = descText,
        _mainTextBold = mainTextBold;

  final String _descText;
  final FontWeight _mainTextBold;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      _descText,
      trimLines: 1,
      trimMode: TrimMode.Line,
      colorClickableText: Colors.white,
      trimCollapsedText: 'See More',
      trimExpandedText: '  Briefly',
      style: TextStyle(
        color: Colors.white,
        fontSize: Sizes.size16,
        fontWeight: _mainTextBold,
      ),
      moreStyle: const TextStyle(
        color: Colors.white,
        fontSize: Sizes.size16,
        fontWeight: FontWeight.w600,
      ),
      lessStyle: const TextStyle(
        color: Colors.white,
        fontSize: Sizes.size16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
