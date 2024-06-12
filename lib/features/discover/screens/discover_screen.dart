import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/breakpoints.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/rawData/discovers.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/constants/rawData/foreground_image.dart';
import 'package:tiktok/features/discover/widgets/custom_search_button.dart';
import 'package:tiktok/utils/utils.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "Initial Text");

  late bool _isThereSearchValue = _textEditingController.text.isNotEmpty;

  void _onSearchChanged(String value) {
    print(value);
    setState(() {
      _isThereSearchValue = value.isNotEmpty;
    });
  }

  void _onSearchSubmitted(String value) {
    print('Submitted $value');
  }

  void _onCloseIcon() {
    setState(() {
      _textEditingController.text = '';
      _isThereSearchValue = false;
    });
  }

  void _moveBack() {
    print('The Back button has been pressed.');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = getWinWidth(context);

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: isWebScreen(context) ? 0 : 1, // 앱바와 바디 사이 구분선 효과
          // ConstrainedBox -> 최대/최소 크기를 제한할 수 있는 박스
          //  참고. Container -> constraints 에서 동일한 속성 설정 가능(기능 동일)
          title: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
            child: CustomSearchButton(
              moveBack: _moveBack,
              textEditingController: _textEditingController,
              onSearchChanged: _onSearchChanged,
              onSearchSubmitted: _onSearchSubmitted,
              isThereSearchValue: _isThereSearchValue,
              onCloseIcon: _onCloseIcon,
            ),
          ),
          // PreferredSizeWidget bottom -> 자식의 크기를 제한하지 않는다. TabBar 가 대표적
          bottom: TabBar(
            onTap: (value) => focusout(context),
            splashFactory: NoSplash.splashFactory, // 클릭 시 기본 번짐 효과 제거
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
            isScrollable: true,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            // 원래는 테마 변경 시 결과가 바로 적용돼야 하지만, 자동 적용이 안 되는 경우도 있다.
            //  그럴 땐 아래처럼 직접 재지정해준다.
            indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            tabs: [
              for (var tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridView.builder(
              // 스크롤 동안 키보드 감추기
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: 20,
              padding: const EdgeInsets.all(Sizes.size6),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width > Breakpoints.lg ? 5 : 2,
                crossAxisSpacing: Sizes.size10,
                mainAxisSpacing: Sizes.size10,
                childAspectRatio: 9 / 20, // 그리드 비율
              ),
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.size4),
                      ),
                      child: AspectRatio(
                        aspectRatio: 10 / 16,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/windmill-7367963.jpg',
                          image:
                              "https://cdn.pixabay.com/photo/2023/01/24/13/23/viet-nam-7741017_960_720.jpg",
                        ),
                      ),
                    ),
                    Gaps.v10,
                    const Text(
                      "This is a very long caption for my tiktok that i'm upload just now currently.",
                      style: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.v8,
                    // 레이아웃이 너무 작으면 세부 텍스트 생략
                    if (constraints.maxWidth < 150 ||
                        constraints.maxWidth > 200)
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: Sizes.size14,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode(context, ref)
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
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
                              color: isDarkMode(context, ref)
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade600,
                            ),
                            Gaps.h2,
                            const Text(
                              '2.5M',
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            for (var tab in tabs.skip(1))
              Center(
                child: Text(
                  tab,
                  style: const TextStyle(
                    fontSize: 36,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
