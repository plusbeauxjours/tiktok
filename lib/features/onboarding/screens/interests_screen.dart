import 'package:flutter/material.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/rawData/interests.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/onboarding/screens/tutorial_screen.dart';
import 'package:tiktok/features/onboarding/widgets/interest_button.dart';
import 'package:tiktok/utils/utils.dart';

class InterestsScreen extends StatefulWidget {
  static const String routeName = 'interests';
  static const String routeURL = '/tutorial';

  const InterestsScreen({Key? key}) : super(key: key);

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100) {
      if (!_showTitle) setState(() => _showTitle = true);
    } else {
      if (_showTitle) setState(() => _showTitle = false);
    }
  }

  void _onNextTap() {
    navPush(context, const TutorialScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AnimatedOpacity(
        opacity: _showTitle ? 1 : 0,
        duration: const Duration(
          milliseconds: 300,
        ),
        child: const Text('Choose your interests'),
      ),
    );
  }

  Widget _buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Sizes.size24,
            0,
            Sizes.size24,
            Sizes.size16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v32,
              _buildTitle(),
              Gaps.v20,
              _buildSubtitle(),
              Gaps.v40,
              _buildInterestsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Choose your interests',
      style: TextStyle(
        fontSize: Sizes.size40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      'Get better video recommendations',
      style: TextStyle(
        fontSize: Sizes.size20,
      ),
    );
  }

  Widget _buildInterestsList() {
    return Wrap(
      spacing: Sizes.size16,
      runSpacing: Sizes.size16,
      children: [
        for (var interest in interests)
          InterestButton(
            interest: interest,
          )
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Sizes.size24, Sizes.size16, Sizes.size24, Sizes.size40),
      child: GestureDetector(
        onTap: _onNextTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size16 + Sizes.size2,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: const Text(
            'Next',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: Sizes.size16,
            ),
          ),
        ),
      ),
    );
  }
}
