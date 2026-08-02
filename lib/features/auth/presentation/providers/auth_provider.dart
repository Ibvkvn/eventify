import 'package:eventify/features/auth/domain/entities/user_entity.dart';
import 'package:eventify/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventify/features/auth/domain/repositories/auth_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoyProvider = Provider<AuthRepository>((ref){
  return AuthRepositoryImplementation();
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref){
  return ref.watch(authRepositoyProvider).authStateChanges;
});

class AuthController extends AsyncNotifier{
  @override
  Future<void> build() async{}

  Future<void> singUp({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoyProvider).signUp(email: email, password: password);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoyProvider).signIn(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoyProvider).signOut();
    });
  }

  Future<void> setUserName(String uid, String userName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoyProvider).setUserName(uid: uid, userName: userName);
    });
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>((){
  return AuthController();
});