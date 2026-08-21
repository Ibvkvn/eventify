import 'package:eventify/features/auth/domain/entities/user_entity.dart';
import 'package:eventify/features/auth/domain/repositories/auth_repository.dart';
import 'package:eventify/features/auth/domain/repositories/auth_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  return AuthRepositoryImplementation();
});

final authStateChangesProvider = StreamProvider<UserEntity?>((ref){
  return ref.watch(authRepositoryProvider).authStateChanges;
});

class AuthController extends AsyncNotifier{
  @override
  Future<void> build() async{}

  Future<void> singUp({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUp(email: email, password: password);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signIn(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }

  Future<void> setUserName(String uid, String userName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).setUserName(uid: uid, userName: userName);
    });
  }

  Future<void> updateUserProfile({required String uid, String? displayName, String? bio, String? tiktokUrl, String? instagramUrl}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).updateUserProfile(
        uid: uid, 
        displayName: displayName, 
        bio: bio, 
        tiktokUrl: tiktokUrl, 
        instagramUrl: instagramUrl
      );
    });
  }

}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>((){
  return AuthController();
});