import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventify/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:eventify/features/auth/domain/entities/user_entity.dart';
import 'package:eventify/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository{
  final fb_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthRepositoryImplementation({
    fb_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore
  }) : 
  _firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
  _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> get authStateChanges{
    return _firebaseAuth.authStateChanges().asyncMap((user) async{
      if(user == null) 
        {return null;}
      else{
        return _fetchUserDoc(user.uid);
      }
    });
  }

  @override
  Future <UserEntity> signUp({required String email, required String password}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;

    final newUser = UserModel(
      id: uid, 
      email: email, 
      userName: '', 
      userNameSet: false, 
      dateCreated: DateTime.now()
    );

    await _firebaseFirestore.collection("users").doc(uid).set(newUser.toMap());
    return newUser;
  }

  @override
  Future<UserEntity> signIn({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _fetchUserDoc(credential.user!.uid);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserName({required String uid, required String userName}) async {
    await _firebaseFirestore.collection("users").doc(uid).update({'userName': userName, 'userNameSet': true});
  }

  @override
  Future<bool> isUserNameAvailable(String userName) async {
    final query = await _firebaseFirestore.collection("users").where('userName', isEqualTo: userName).limit(1).get();

    return query.docs.isEmpty;
  }

  Future <UserEntity> _fetchUserDoc(String uid) async {
    final userDoc = await _firebaseFirestore.collection("users").doc(uid).get();
    if (!userDoc.exists){
      throw Exception("user not found");
    }try { 
      return UserModel.fromMap(userDoc.data()!, uid);
    } catch (e){
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getUserById(String uid) async {
    final userDoc = await _firebaseFirestore.collection("users").doc(uid).get();
    if(!userDoc.exists){
      return null;
    }
    return UserModel.fromMap(userDoc.data()!, uid);
  }

  @override
  Future<void> updateUserProfile({required String uid, String? displayName, String? bio, String? tiktokUrl, String? instagramUrl}) async {
    final updates = <String, dynamic>{};
    if(displayName != null){
      updates["displayName"] = displayName;
    }
    if(bio != null){
      updates["bio"] = bio;
    }
    if(tiktokUrl != null){
      updates["tiktokUrl"] = tiktokUrl;
    }
    if(instagramUrl != null){
      updates["instagramUrl"] = instagramUrl;
    }
    if(updates.isEmpty) return; 

    await _firebaseFirestore.collection("users").doc(uid).update(updates);
  } 
}