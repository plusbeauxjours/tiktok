import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/rawData/discovers.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/constants/rawData/foreground_image.dart';
import 'package:tiktok/features/discover/widgets/cst_search_button.dart';
import 'package:tiktok/utils/utils.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _textEditingController = TextEditingController(text: "Initial Text");
  late bool _isThereSearchValue = _textEditingController.text.isNotEmpty;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _isThereSearchValue = value.isNotEmpty);
  }

  void _onSearchSubmitted(String value) {
    print('Submitted $value');
  }

  void _onCloseIcon() {
    setState(() {
      _textEditingController.clear();
      _isThereSearchValue = false;
    });
  }

  void _moveBack() {
    print('The Back button has been pressed.');
  }

  @override
  Widget build(BuildContext context) {
    final width = getWinWidth(context);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            _buildGridView(width),
            for (var tab in tabs.skip(1)) _buildCenteredText(tab),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: isWebScreen(context) ? 0 : 1,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
        child: CstSearchButton(
          moveBack: _moveBack,
          textEditingController: _textEditingController,
          onSearchChanged: _onSearchChanged,
          onSearchSubmitted: _onSearchSubmitted,
          isThereSearchValue: _isThereSearchValue,
          onCloseIcon: _onCloseIcon,
        ),
      ),
      bottom: _buildTabBar(context),
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      onTap: (value) => focusout(context),
      splashFactory: NoSplash.splashFactory,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
      isScrollable: true,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
      tabs: [for (var tab in tabs) Tab(text: tab)],
    );
  }

  Widget _buildGridView(double width) {
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: 20,
      padding: const EdgeInsets.all(Sizes.size6),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > Breakpoints.lg ? 5 : 2,
        crossAxisSpacing: Sizes.size10,
        mainAxisSpacing: Sizes.size10,
        childAspectRatio: 9 / 20,
      ),
      itemBuilder: (context, index) => LayoutBuilder(
        builder: (context, constraints) => _buildGridItem(constraints),
      ),
    );
  }

  Widget _buildGridItem(BoxConstraints constraints) {
    return Column(
      children: [
        _buildImageContainer(),
        Gaps.v10,
        _buildCaption(),
        Gaps.v8,
        if (constraints.maxWidth < 150 || constraints.maxWidth > 200)
          _buildUserInfo(constraints),
      ],
    );
  }

  Widget _buildImageContainer() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size4),
      ),
      child: AspectRatio(
        aspectRatio: 10 / 16,
        child: FadeInImage.assetNetwork(
          fit: BoxFit.cover,
          placeholder: 'assets/images/windmill-7367963.jpg',
          image: "https://cdn.pixabay.com/photo/2023/01/24/13/23/viet-nam-7741017_960_720.jpg",
        ),
      ),
    );
  }

  Widget _buildCaption() {
    return const Text(
      "This is a very long caption for my tiktok that i'm upload just now currently.",
      style: TextStyle(
        fontSize: Sizes.size18,
        fontWeight: FontWeight.bold,
        height: 1.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildUserInfo(BoxConstraints constraints) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: Sizes.size14,
        fontWeight: FontWeight.w600,
        color: isDarkMode(context, ref) ? Colors.grey.shade300 : Colors.grey.shade600,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 15,
            foregroundImage: NetworkImage(foregroundImage),
          ),
          Gaps.h4,
          const Expanded(
            child: Text(
              'My avatar is going to be very long',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gaps.h4,
          FaIcon(
            FontAwesomeIcons.heart,
            size: Sizes.size16,
            color: isDarkMode(context, ref) ? Colors.grey.shade300 : Colors.grey.shade600,
          ),
          Gaps.h2,
          const Text('2.5M'),
        ],
      ),
    );
  }

  Widget _buildCenteredText(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 36),
      ),
    );
  }
}