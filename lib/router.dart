import 'package:go_router/go_router.dart';
import 'package:tiktok/features/videos/screens/video_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const VideoRecordingScreen(),
    )
  ],
);
