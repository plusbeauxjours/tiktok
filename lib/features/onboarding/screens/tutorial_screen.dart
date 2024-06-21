import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/enum/direction.dart';
import 'package:tiktok/constants/enum/showing_page.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/onboarding/widgets/tutorial.dart';
import 'package:tiktok/utils/utils.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends ConsumerState<TutorialScreen> {
  Direction _direction = Direction.right;

  ShowingPage _showingPage = ShowingPage.first;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _direction = details.delta.dx > 0 ? Direction.right : Direction.left;
    });
    print(details);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _showingPage =
          _direction == Direction.left ? ShowingPage.second : ShowingPage.first;
    });
  }

  void _onPressArrow(Direction direction) {
    _showingPage =
        direction == Direction.left ? ShowingPage.second : ShowingPage.first;
    setState(() {});
  }

  void _onEnterAppTap() {
    goRouteGo(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    final isWebScreen = MediaQuery.of(context).size.width > Breakpoints.lg;

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
          child: SafeArea(
            child: AnimatedCrossFade(
              firstChild: const Tutorial(
                  mainText: 'Watch cool videos!',
                  subText:
                      'Videos are personalized for you based on what you watch, like, and share.'),
              secondChild: const Tutorial(
                mainText: 'Follow the rules!',
                subText: 'Take care of one another! please.',
              ),
              crossFadeState: _showingPage == ShowingPage.first
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size32,
            left: isWebScreen ? 275 : Sizes.size24,
            right: isWebScreen ? 275 : Sizes.size24,
          ),
          color: isDarkMode(context, ref) ? Colors.black : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size24,
              horizontal: Sizes.size24,
            ),
            child: AnimatedOpacity(
              opacity:
                  _showingPage == ShowingPage.first && !isWebScreen ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisAlignment: isWebScreen
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (isWebScreen)
                    AnimatedOpacity(
                      opacity: _showingPage == ShowingPage.first ? 0 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        onPressed: () => _onPressArrow(Direction.right),
                        icon: const FaIcon(FontAwesomeIcons.chevronLeft),
                      ),
                    ),
                  CupertinoButton(
                    onPressed: () =>
                        _showingPage == ShowingPage.first && isWebScreen
                            ? _onPressArrow(Direction.left)
                            : _onEnterAppTap(), // url -> /:tab 파라미터 정보 입력해 진입
                    color: Theme.of(context).primaryColor,
                    child: Text(
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                        ),
                        _showingPage == ShowingPage.first && isWebScreen
                            ? 'Next'
                            : 'Enter the app!'),
                  ),
                  if (isWebScreen)
                    AnimatedOpacity(
                      opacity: _showingPage == ShowingPage.first ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        onPressed: () => _onPressArrow(Direction.left),
                        icon: const FaIcon(FontAwesomeIcons.chevronRight),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
