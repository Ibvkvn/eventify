import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/auth/presentation/providers/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String userNamePicker = "/userNamePicker";
}

final routerProvider = Provider<GoRouter>((ref){
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.signup,
    debugLogDiagnostics: true,
    redirect: (context, state){
      final isLoggedIn = authState.value != null;
      final user = authState.value;
      final loggingIn = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.signup;

      if(authState.isLoading){
        return null;
      }
      if(!isLoggedIn && !isLoggedIn){
        return AppRoutes.signup;
      } 
      if(isLoggedIn && user!.userNameSet == false && state.matchedLocation != AppRoutes.userNamePicker){
        return AppRoutes.userNamePicker;
      }
      if(isLoggedIn && user!.userNameSet == true && loggingIn){
        return AppRoutes.home;
      }
      return null;
    },
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
        builder: (context, state) => const SignupScreen()
      ),
      GoRoute(
        path: AppRoutes.userNamePicker,
        builder: (context, state) => const _PlaceholderScreen(title: "username picker")
      )
    ]
  );
});

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