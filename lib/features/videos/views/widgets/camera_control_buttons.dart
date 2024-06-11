import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tiktok/common/constants/rawData/camera_icons.dart';
import 'package:tiktok/common/widgets/camera_icon_button.dart';

class CameraControlButtons extends StatelessWidget {
  final CameraController controller;
  final FlashMode flashMode;
  final void Function() toggleSelfieMode;
  final void Function(FlashMode flashMode) setFlashMode;

  const CameraControlButtons({
    Key? key,
    required this.flashMode,
    required this.toggleSelfieMode,
    required this.setFlashMode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CameraIconButton(
          onPressed: toggleSelfieMode,
          icon: Icons.cameraswitch,
        ),
        for (var flashIcon in flashIcons)
          CameraIconButton(
            isSelect: flashMode == flashIcon["flashMode"],
            onPressed: () => setFlashMode(flashIcon["flashMode"]),
            icon: flashIcon["icon"],
          ),
      ],
    );
  }
}
