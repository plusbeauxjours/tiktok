import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/constants/enum/direction.dart';
import 'package:tiktok/constants/enum/showing_page.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:tiktok/features/onboarding/widgets/tutorial.dart';
import 'package:tiktok/utils/utils.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
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

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size24,
              horizontal: 24,
            ),
            child: AnimatedOpacity(
              opacity: _showingPage == ShowingPage.first ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: CupertinoButton(
                onPressed: () => Utils.navPushAndRemoveUntil(
                    context, const MainNavigationScreen()),
                color: Theme.of(context).primaryColor,
                child: const Text('Enter the app!'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
