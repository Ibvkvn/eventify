import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = "/";
  static const String login = "/login";
  static const String signup = "/signup";
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const _PlaceholderScreen(title: "home")
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const _PlaceholderScreen(title: "login")
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const _PlaceholderScreen(title: "signup")
    ),
  ]
);

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall
        ),
      ),
    );
  }
}