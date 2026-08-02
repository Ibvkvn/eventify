import 'package:eventify/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity> signUp({required String email, required String password});
  Future<UserEntity> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> setUserName({required String uid, required String userName});
  Future<bool> isUserNameAvailable(String userName);
}