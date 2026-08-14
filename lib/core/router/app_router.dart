import 'package:eventify/core/widgets/home_shell.dart';
import 'package:eventify/features/auth/presentation/providers/auth_provider.dart';
import 'package:eventify/features/auth/presentation/providers/screens/login_screen.dart';
import 'package:eventify/features/auth/presentation/providers/screens/signup_screen.dart';
import 'package:eventify/features/auth/presentation/providers/screens/username_picker_screen.dart';
import 'package:eventify/features/events/presentation/providers/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = "/home";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String userNamePicker = "/userNamePicker";
}

final routerProvider = Provider<GoRouter>((ref){
  final refreshNotifier = _RouterRefreshNotifier();
  ref.listen(authStateChangesProvider, (_, __) => refreshNotifier.notify());

  return GoRouter(
    initialLocation: AppRoutes.signup,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    redirect: (context, state){
      final authState = ref.read(authStateChangesProvider);
      final isLoggedIn = authState.value != null;
      final user = authState.value;
      final loggingIn = state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.signup;

      if(authState.isLoading){
        return null;
      }
      if(!isLoggedIn && !loggingIn){
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
        builder: (context, state) => const HomeShell()
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen()
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen()
      ),
      GoRoute(
        path: AppRoutes.userNamePicker,
        builder: (context, state) => const UsernamePickerScreen()
      )
    ]
  );
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify () => notifyListeners();
}

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