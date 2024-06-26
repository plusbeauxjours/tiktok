import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/common/widgets/cst_text_field.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/users/view_models/profile_state_view_model.dart';
import 'package:tiktok/features/users/view_models/users_view_models.dart';

class UserProfileBody extends ConsumerStatefulWidget {
  final String bio;
  final String link;

  const UserProfileBody({
    super.key,
    required this.bio,
    required this.link,
  });

  @override
  ConsumerState<UserProfileBody> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends ConsumerState<UserProfileBody> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  bool _isBioEdit = false;
  bool _isLinkEdit = false;

  String _bio = '';
  String _link = '';

  void _toggleBioEdit() {
    _isBioEdit = !_isBioEdit;
    ref.read(editProvider.notifier).toggleEditMode();
    if (!_isBioEdit && widget.bio != _bio) {
      ref.read(usersProvider.notifier).onUpdateUserBio(_bio);
    }
    setState(() {});
  }

  void _toggleLinkEdit() {
    _isLinkEdit = !_isLinkEdit;
    if (!_isLinkEdit && widget.link != _link) {
      ref.read(usersProvider.notifier).onUpdateUserLink(_link);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.bio;
    _linkController.text = widget.link;

    _bioController.addListener(() {
      _bio = _bioController.text;
      setState(() {});
    });
    _linkController.addListener(() {
      _link = _linkController.text;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = ref.watch(editProvider)['isEditMode'];
    return SizedBox(
      width: 450,
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.66,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size14,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Sizes.size4),
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.v14,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
            child: _isBioEdit
                ? CstTextField(
                    controller: _bioController,
                    hintText: 'Please write your intro',
                    suffix: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _bioController.clear(),
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h5,
                          GestureDetector(
                            onTap: _toggleBioEdit,
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: kIsWeb
                            ? null
                            : MediaQuery.of(context).size.width - 100,
                        child: Text(
                          // 'All highlights and where to watch live matches on FIFA+',
                          widget.bio,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      Gaps.h8,
                      if (isEditMode)
                        GestureDetector(
                          onTap: _toggleBioEdit,
                          child: const FaIcon(
                            FontAwesomeIcons.pen,
                            size: 14,
                          ),
                        ),
                    ],
                  ),
          ),
          Gaps.v14,
          _isLinkEdit
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
                  child: CstTextField(
                    controller: _linkController,
                    hintText: 'Please write your link',
                    suffix: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _linkController.clear(),
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleXmark,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                          Gaps.h5,
                          GestureDetector(
                            onTap: _toggleLinkEdit,
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: Colors.grey.shade500,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: kIsWeb
                          ? null
                          : MediaQuery.of(context).size.width - 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.link.isNotEmpty)
                            const FaIcon(
                              FontAwesomeIcons.link,
                              size: Sizes.size12,
                            ),
                          Text(
                            ' ${widget.link}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    Gaps.h8,
                    if (isEditMode)
                      GestureDetector(
                        onTap: _toggleLinkEdit,
                        child: const FaIcon(
                          FontAwesomeIcons.pen,
                          size: Sizes.size14,
                        ),
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}
