import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok/features/authentications/screens/login_screen.dart';
import 'package:tiktok/features/authentications/repos/authentication_repo.dart';
import 'package:tiktok/features/authentications/screens/signup_screen.dart';
import 'package:tiktok/features/inbox/screens/activity_screen.dart';
import 'package:tiktok/features/inbox/screens/chat_detail_screen.dart';
import 'package:tiktok/features/inbox/screens/chats_screen.dart';
import 'package:tiktok/features/main_navigation/screens/main_navigation_screen.dart';
import 'package:tiktok/features/notifications/notifications_provider.dart';
import 'package:tiktok/features/onboarding/screens/interests_screen.dart';
import 'package:tiktok/features/videos/views/video_recording_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.read(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            ref.read(notificationsProvider(context));
            return child;
          },
          routes: [
            GoRoute(
              name: SignUpScreen.routeName,
              path: SignUpScreen.routeURL,
              builder: (context, state) => const SignUpScreen(),
            ),
            GoRoute(
              name: LoginScreen.routeName,
              path: LoginScreen.routeURL,
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              name: InterestsScreen.routeName,
              path: InterestsScreen.routeURL,
              builder: (context, state) => const InterestsScreen(),
            ),
            GoRoute(
              path: "/:tab(home|discover|inbox|profile)",
              name: MainNavigationScreen.routeName,
              builder: (context, state) {
                final tab = state.params["tab"]!;
                return MainNavigationScreen(tab: tab);
              },
            ),
            GoRoute(
              name: ActivityScreen.routeName,
              path: ActivityScreen.routeURL,
              builder: (context, state) => const ActivityScreen(),
            ),
            GoRoute(
              name: ChatsScreen.routeName,
              path: ChatsScreen.routeURL,
              builder: (context, state) => const ChatsScreen(),
              routes: [
                GoRoute(
                  name: ChatDetailScreen.routeName,
                  path: ChatDetailScreen.routeURL,
                  builder: (context, state) {
                    final chatId = state.params["chatId"] ?? "";
                    return ChatDetailScreen(
                      chatId: chatId,
                    );
                  },
                )
              ],
            ),
            GoRoute(
              path: VideoRecordingScreen.routeURL,
              name: VideoRecordingScreen.routeName,
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 200),
                child: const VideoRecordingScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  final position = Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(
                    position: position,
                    child: child,
                  );
                },
              ),
            )
          ],
        )
      ]);
});
