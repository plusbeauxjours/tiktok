import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/common/widgets/cst_text_field.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/user/view_models/profile_state_view_model.dart';
import 'package:tiktok/features/user/view_models/user_view_model.dart';

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
  late final TextEditingController _bioController;
  late final TextEditingController _linkController;

  bool _isBioEdit = false;
  bool _isLinkEdit = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.bio);
    _linkController = TextEditingController(text: widget.link);

    _bioController.addListener(() => setState(() {}));
    _linkController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bioController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _toggleEdit(bool isEdit, String field) {
    setState(() {
      if (field == 'bio') {
        _isBioEdit = !_isBioEdit;
        ref.read(editProvider.notifier).toggleEditMode();
        if (!_isBioEdit && widget.bio != _bioController.text) {
          ref.read(userProvider.notifier).onUpdateUserBio(_bioController.text);
        }
      } else {
        _isLinkEdit = !_isLinkEdit;
        if (!_isLinkEdit && widget.link != _linkController.text) {
          ref
              .read(userProvider.notifier)
              .onUpdateUserLink(_linkController.text);
        }
      }
    });
  }

  Widget _buildEditableField(
    bool isEdit,
    TextEditingController controller,
    String hintText,
    String field,
  ) {
    return isEdit
        ? CstTextField(
            controller: controller,
            hintText: hintText,
            suffix:
                _buildEditButtons(controller, () => _toggleEdit(isEdit, field)),
          )
        : _buildDisplayField(controller.text, field);
  }

  Widget _buildEditButtons(
      TextEditingController controller, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: controller.clear,
            child: FaIcon(
              FontAwesomeIcons.solidCircleXmark,
              color: Colors.grey.shade500,
              size: Sizes.size20,
            ),
          ),
          Gaps.h5,
          GestureDetector(
            onTap: onToggle,
            child: FaIcon(
              FontAwesomeIcons.solidCircleCheck,
              color: Colors.grey.shade500,
              size: Sizes.size20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayField(String text, String field) {
    final isEditMode = ref.watch(editProvider)['isEditMode'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: kIsWeb ? null : MediaQuery.of(context).size.width - 100,
          child: field == 'link'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (text.isNotEmpty)
                      const FaIcon(
                        FontAwesomeIcons.link,
                        size: Sizes.size12,
                      ),
                    Text(
                      ' $text',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                )
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
        ),
        Gaps.h8,
        if (isEditMode)
          GestureDetector(
            onTap: () =>
                _toggleEdit(field == 'bio' ? _isBioEdit : _isLinkEdit, field),
            child: const FaIcon(
              FontAwesomeIcons.pen,
              size: Sizes.size14,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.66,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Sizes.size14),
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
          Gaps.v14,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
            child: _buildEditableField(
                _isBioEdit, _bioController, 'Please write your intro', 'bio'),
          ),
          Gaps.v14,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size32),
            child: _buildEditableField(
                _isLinkEdit, _linkController, 'Please write your link', 'link'),
          ),
        ],
      ),
    );
  }
}
