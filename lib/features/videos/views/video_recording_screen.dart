import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok/constants/gaps.dart';
import 'package:tiktok/constants/sizes.dart';
import 'package:tiktok/features/videos/views/video_preview_screen.dart';
import 'package:tiktok/features/videos/views/widgets/camera_control_buttons.dart';
import 'package:tiktok/utils/utils.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = 'postVideo';
  static const String routeURL = '/upload';

  const VideoRecordingScreen({Key? key}) : super(key: key);

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _deniedPermission = false;
  bool _isSelfieMode = false;
  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late CameraController _cameraController;
  late FlashMode _flashMode;
  double zoomLevel = 1.0;
  late double minZoomLevel;
  late double maxZoomLevel;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    // 애니메이션 최소/최대값 지정
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    // 이 앱의 라이프사이클(실행중/백그라운드에서 실행중/종료 등)을 추적하는 옵저버 추가
    WidgetsBinding.instance.addObserver(this);
    // _progressAnimationController.value 변화 추적
    _progressAnimationController.addListener(() {
      // 변화가 감지되면 화면 갱신 -> 진행도 애니메이션 동작
      setState(() {});
    });
    // _progressAnimationController.status 변화 추적
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 변화가 감지되면 화면 갱신 -> 진행도 애니메이션 종료(리셋)
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    if (!_noCamera) _cameraController.dispose();
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  // 아래 앱 라이프사이클 추적 메서드는 WidgetsBindingObserver 믹싱으로 오버라이드 가능
  // -> 목적: 앱 라이프사이클 변화에 따라, 카메라제어자(_cameraController) 초기화 또는 제거 실행
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 단, 이 메서드는 앱 처음 실행 시 카메라 접근권한 설정 창이 뜨는 상황에서도 자동 실행된다.
    //  -> 카메라 제어 권한도 없는 상태에서 앱 라이프사이클 추적은 무의미 -> 불필요한 추적 중단
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return; // 카메라 초기화가 안 된 경우도 마찬가지
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    try {
      _cameraController = CameraController(
        cameras[_isSelfieMode ? 1 : 0],
        ResolutionPreset.ultraHigh,
      );
      await _cameraController.initialize();
      await _cameraController.prepareForVideoRecording();
      _flashMode = _cameraController.value.flashMode;

      minZoomLevel = await _cameraController.getMinZoomLevel();
      maxZoomLevel = await _cameraController.getMaxZoomLevel();
      setState(() {});
    } catch (err) {
      if (err is CameraException) {
        switch (err.code) {
          case 'CameraAccessDenied':
            if (kDebugMode) print('User denied camera access.');
            break;
          default:
            if (kDebugMode) print('Handle other errors.');
            break;
        }
      }
    }
  }

  Future<void> initPermissions() async {
    // 안드로이드와 iOS에서 사용자에게 접근 허용할 건지 묻는 팝업 등장
    final cameraPermission = await Permission.camera.request(); // 앱 사용중에만 허용 선택
    final micPermission =
        await Permission.microphone.request(); // 앱 사용중에만 허용 선택

    final isCameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final isMicDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    // 카메라, 마이크 접근 권한이 모두 확인되면 카메라 초기화
    if (!isCameraDenied && !isMicDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    } else {
      _deniedPermission = true;
      _cameraController.dispose();
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    // 전후면 카메라 전환 -> 카메라 컨트롤러 초기화 필요
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode); // 카메라 플레시모드 변경
    _flashMode = newFlashMode; // state 변경
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails details) async {
    if (_cameraController.value.isRecordingVideo) return;
    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    // 녹화중이 아니라면 중지명령 무시
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final XFile video = await _cameraController.stopVideoRecording();

    zoomLevel = minZoomLevel;
    await _cameraController.setZoomLevel(minZoomLevel);
    setState(() {});

    if (!mounted) return;
    navPush(context, VideoPreviewScreen(video: video, isPicked: false));
  }

  Future<void> _onZoomInOut(DragUpdateDetails details) async {
    double deltaY = details.delta.dy;
    if (deltaY > 0) {
      zoomLevel = (zoomLevel - 0.05).clamp(minZoomLevel, maxZoomLevel);
    } else if (deltaY < 0) {
      zoomLevel = (zoomLevel + 0.05).clamp(minZoomLevel, maxZoomLevel);
    } else {
      return;
    }
    await _cameraController.setZoomLevel(zoomLevel);
    setState(() {});
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) return;
    if (!mounted) return;
    navPush(context, VideoPreviewScreen(video: video, isPicked: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !_deniedPermission
                        ? 'Initializing...'
                        : 'You do not have access to the camera.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  !_deniedPermission
                      ? const CircularProgressIndicator.adaptive()
                      : const Text(
                          'Please reset the permission.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size20,
                          ),
                        ),
                ],
              )
            : SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_noCamera && _cameraController.value.isInitialized)
                      CameraPreview(_cameraController),
                    const Positioned(
                      top: Sizes.size40,
                      left: Sizes.size20,
                      child: CloseButton(
                        color: Colors.white,
                      ),
                    ),
                    if (!_noCamera)
                      Positioned(
                        top: Sizes.size10,
                        right: Sizes.size10,
                        child: CameraControlButtons(
                          controller: _cameraController,
                          flashMode: _flashMode,
                          setFlashMode: _setFlashMode,
                          toggleSelfieMode: _toggleSelfieMode,
                        ),
                      ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: Sizes.size40,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onPanUpdate: (details) => _onZoomInOut(details),
                            onPanEnd: (detail) => _stopRecording(),
                            onTapDown: _startRecording,
                            onTapUp: (detail) => _stopRecording(),
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    child: CircularProgressIndicator(
                                      color: Colors.amber.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size60,
                                    height: Sizes.size60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
