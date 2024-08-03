import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/settings/screens/settings_screen.dart';
import 'package:tiktok/features/user/models/user_profile_model.dart';
import 'package:tiktok/features/user/view_models/profile_state_view_model.dart';
import 'package:tiktok/features/user/view_models/user_view_model.dart';
import 'package:tiktok/features/user/widgets/user_info.dart';
import 'package:tiktok/utils/utils.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(userProvider).when(
          error: (error, stackTrace) => _buildErrorWidget(error),
          loading: () => _buildLoadingWidget(),
          data: (data) => _buildProfileScreen(data),
        );
  }

  // 에러 위젯
  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  // 로딩 위젯
  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  // 메인 프로필 화면
  Widget _buildProfileScreen(UserProfileModel data) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: widget.tab == "likes" ? 1 : 0,
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(),
                _buildSliverUserInfo(data),
              ];
            },
            body: _buildTabBarView(),
          ),
        ),
      ),
    );
  }

  // SliverAppBar 위젯
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      centerTitle: true,
      title: Text(widget.username),
      actions: [
        IconButton(
          onPressed: () => ref.read(editProvider.notifier).toggleEditMode(),
          icon: FaIcon(
            !ref.watch(editProvider)["isEditMode"]
                ? FontAwesomeIcons.pen
                : FontAwesomeIcons.check,
          ),
        ),
        IconButton(
          onPressed: () => navPush(context, const SettingsScreen()),
          icon: const FaIcon(
            FontAwesomeIcons.gear,
          ),
        ),
      ],
    );
  }

  // 사용자 정보 위젯
  Widget _buildSliverUserInfo(UserProfileModel data) {
    return SliverToBoxAdapter(
      child: UserInfo(
        name: data.name,
        username: data.username,
        hasAvatar: data.hasAvatar,
        uid: data.uid,
        bio: data.bio,
        link: data.link,
      ),
    );
  }

  // TabBarView 위젯
  Widget _buildTabBarView() {
    return TabBarView(
      children: [
        _buildGridView(),
        const Center(
          child: Text(
            'Page two',
          ),
        ),
      ],
    );
  }

  // GridView 위젯
  Widget _buildGridView() {
    return GridView.builder(
      itemCount: 20,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: Sizes.size2,
        mainAxisSpacing: Sizes.size2,
        childAspectRatio: 9 / 14,
      ),
      itemBuilder: (context, index) => _buildGridItem(),
    );
  }

  // GridView 아이템 위젯
  Widget _buildGridItem() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 9 / 14,
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            placeholder: 'assets/images/windmill-7367963.jpg',
            image:
                "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
          ),
        ),
      ],
    );
  }
}
