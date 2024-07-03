import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/common/widgets/main_navigation/custom_navigaton.dart';
import 'package:tiktok/constants/rawData/discovers.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils/utils.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static const String routeName = 'mainNavigation';
  final String tab;

  const MainNavigationScreen({
    Key? key,
    required this.tab,
  }) : super(key: key);

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "xxxxx", // fake element for video post icon
    "inbox",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);
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
    context.go('/${_tabs[index]}');
    _selectedIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) _tabs.remove("xxxxx");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context, ref);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: isWebScreen(context)
          ? Row(
              children: [
                NavigationRail(
                  backgroundColor: _selectedIndex == 0 || isDark
                      ? Colors.black
                      : Colors.white,
                  labelType: NavigationRailLabelType.selected,
                  selectedIconTheme: IconThemeData(
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                  unselectedIconTheme: IconThemeData(
                    color: _selectedIndex == 0
                        ? Colors.grey.shade200
                        : Colors.grey.shade600,
                  ),
                  indicatorColor: Theme.of(context).primaryColor,
                  selectedLabelTextStyle:
                      TextStyle(color: Theme.of(context).primaryColor),
                  unselectedLabelTextStyle: TextStyle(
                    color: _selectedIndex == 0
                        ? Colors.grey.shade200
                        : Colors.grey.shade600,
                  ),
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onTap,
                  // 웹에서는 카메라가 없으므로, 생략 -> 활성화해봐야 에러 발생
                  // trailing: Padding(
                  //   padding: const EdgeInsets.only(top: Sizes.size20),
                  //   child: PostVideoButton(
                  //     isVideoButtonHovered: _isVideoButtonHovered,
                  //     onHover: _onHover,
                  //     inverted: _selectedIndex != 0,
                  //     onLongPressDown: _onLongPressDown,
                  //     onLongPressUp: _onLongPressUp,
                  //   ),
                  // ),
                  destinations: [
                    for (var nav in navs2)
                      NavigationRailDestination(
                        icon: FaIcon(nav['icon']),
                        label: Text(nav['title']),
                      ),
                  ],
                ),
                VerticalDivider(
                  color: _selectedIndex == 0
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  thickness: 1,
                  width: 1,
                ),
              ],
            )
          : Stack(
              children: [
                for (var offStage in offStages)
                  Offstage(
                    offstage: _selectedIndex != offStages.indexOf(offStage),
                    child: offStage,
                  )
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
                padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(context).padding.bottom + Sizes.size12),
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
