import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/common/widgets/main_navigation/custom_navigaton.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/discover/screens/discover_screen.dart';
import 'package:tiktok/features/inbox/screens/inbox_screen.dart';
import 'package:tiktok/features/users/screens/user_profile_screen.dart';
import 'package:tiktok/features/videos/screens/video_timeline_screen.dart';
import 'package:tiktok/utils/common_utils.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 4;
  bool _isVideoButtonHovered = false;

  void _onLongPressUp() {
    setState(() {
      _isVideoButtonHovered = false;
    });
  }

  void _onLongPressDown(LongPressDownDetails details) {
    setState(() {
      _isVideoButtonHovered = true;
    });
  }

  void _onHover() {
    setState(() {
      _isVideoButtonHovered = !_isVideoButtonHovered;
    });
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(
              username: "plusbeauxjours",
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isWebScreen(context)
          ? Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + Sizes.size12,
              ),
              color:
                  _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(Sizes.size12),
                child: CustomNavigation(
                  selectedIndex: _selectedIndex,
                  onTap: _onTap,
                  onHover: _onHover,
                  isVideoButtonHovered: _isVideoButtonHovered,
                  onLongPressUp: _onLongPressUp,
                  onLongPressDown: _onLongPressDown,
                ),
              ),
            )
          : null,
    );
  }
}
