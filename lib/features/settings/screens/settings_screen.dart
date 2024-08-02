import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/videos/view_models/playback_config_view_model.dart';
import 'package:tiktok/utils/utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSwitchListTile(
            ref,
            title: "Dark Mode",
            subtitle: "Dark mode is applied by default.",
            value: ref.watch(playbackConfigProvider).darkmode,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setDarkmode(value),
          ),
          _buildSwitchListTile(
            ref,
            title: "Mute video",
            subtitle: "Video will be muted by default.",
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setMuted(value),
          ),
          _buildSwitchListTile(
            ref,
            title: "Autoplay",
            subtitle: "Video will start playing automatically.",
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setAutoplay(value),
          ),
          _buildSwitchListTile(
            ref,
            title: "Enable notifications",
            subtitle: "Enable notifications",
            value: false,
            onChanged: (value) {},
          ),
          _buildCheckboxListTile(context),
          _buildBirthdayListTile(context),
          _buildLogoutListTile(
              context, ref, "Log out (iOS)", _showIosLogoutDialog),
          _buildLogoutListTile(
              context, ref, "Log out (Android)", _showAndroidLogoutDialog),
          _buildLogoutListTile(context, ref, "Log out (iOS / Bottom)",
              _showIosBottomLogoutDialog),
          const AboutListTile(
            applicationVersion: "1.0",
            applicationLegalese: "Don't copy me.",
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchListTile(
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildCheckboxListTile(BuildContext context) {
    return CheckboxListTile(
      activeColor: Theme.of(context).primaryColor,
      value: false,
      onChanged: (value) {},
      title: const Text("Enable notifications"),
      subtitle: const Text("We won't spam you."),
    );
  }

  Widget _buildBirthdayListTile(BuildContext context) {
    return ListTile(
      onTap: () => _showDatePickers(context),
      title: const Text("What is your birthday?"),
      subtitle: const Text("I need to know!"),
    );
  }

  Widget _buildLogoutListTile(BuildContext context, WidgetRef ref, String title,
      Function(BuildContext, WidgetRef) showDialog) {
    return ListTile(
      title: Text(title),
      textColor: Colors.red,
      onTap: () => showDialog(context, ref),
    );
  }

  void _showDatePickers(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
    );
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    showDateRangePicker(
      context: context,
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _showIosLogoutDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Please don't go"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => navPop(context),
            child: const Text("No"),
          ),
          CupertinoDialogAction(
            onPressed: () => _logout(context, ref),
            isDestructiveAction: true,
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showAndroidLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const FaIcon(FontAwesomeIcons.skull),
        title: const Text("Are you sure?"),
        content: const Text("Please don't go"),
        actions: [
          IconButton(
            onPressed: () => navPop(context),
            icon: const FaIcon(FontAwesomeIcons.car),
          ),
          TextButton(
            onPressed: () => _logout(context, ref),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showIosBottomLogoutDialog(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Are you sure?"),
        message: const Text("Please dooooont gooooo"),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => navPop(context),
            child: const Text("Not log out"),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => _logout(context, ref),
            child: const Text("Yes plz."),
          )
        ],
      ),
    );
  }

  void _logout(BuildContext context, WidgetRef ref) {
    ref.read(authRepo).signOut(context);
    context.go("/");
  }
}
