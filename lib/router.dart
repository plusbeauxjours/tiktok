import 'package:go_router/go_router.dart';
import 'package:tiktok/features/authentications/screens/email_screen.dart';
import 'package:tiktok/features/authentications/screens/login_screen.dart';
import 'package:tiktok/features/authentications/screens/signup_screen.dart';
import 'package:tiktok/features/authentications/screens/username_screen.dart';
import 'package:tiktok/features/users/screens/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: UsernameScreen.routeName,
      builder: (context, state) => const UsernameScreen(),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) => const EmailScreen(),
    ),
    GoRoute(
      path: "/users/:username",
      builder: (context, state) {
        final username = state.params['username'];
        return UserProfileScreen(username: username!);
      },
    )
  ],
);
