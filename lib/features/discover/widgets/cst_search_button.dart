import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/utils/utils.dart';

class CstSearchButton extends ConsumerWidget {
  final VoidCallback moveBack;
  final TextEditingController textEditingController;
  final void Function(String)? onSearchChanged;
  final void Function(String)? onSearchSubmitted;
  final bool isThereSearchValue;
  final VoidCallback onCloseIcon;

  const CstSearchButton({
    Key? key,
    required this.moveBack,
    required this.textEditingController,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.isThereSearchValue,
    required this.onCloseIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(),
        Expanded(child: _buildSearchField(context, ref)),
        const FaIcon(FontAwesomeIcons.sliders),
      ],
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: moveBack,
      child: const FaIcon(FontAwesomeIcons.chevronLeft),
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size18),
      height: Sizes.size44,
      child: TextField(
        controller: textEditingController,
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
        cursorColor: Theme.of(context).primaryColor,
        decoration: _buildInputDecoration(context, ref),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, WidgetRef ref) {
    return InputDecoration(
      hintText: 'Search',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.size5),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: isDarkMode(context, ref)
          ? Colors.grey.shade800
          : Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
      prefixIcon: _buildSearchIcon(context, ref),
      suffixIcon: _buildClearIcon(context),
    );
  }

  Widget _buildSearchIcon(BuildContext context, WidgetRef ref) {
    return Container(
      width: Sizes.size20,
      alignment: Alignment.center,
      child: FaIcon(
        FontAwesomeIcons.magnifyingGlass,
        color: isDarkMode(context, ref) ? Colors.grey.shade500 : Colors.black,
        size: Sizes.size18,
      ),
    );
  }

  Widget _buildClearIcon(BuildContext context) {
    return Container(
      width: Sizes.size20,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: Sizes.size10, right: Sizes.size8),
      child: AnimatedOpacity(
        opacity: isThereSearchValue ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: onCloseIcon,
          child: FaIcon(
            FontAwesomeIcons.solidCircleXmark,
            color: Colors.grey.shade600,
            size: Sizes.size18,
          ),
        ),
      ),
    );
  }
}
