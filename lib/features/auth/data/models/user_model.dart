import 'package:eventify/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    required super.userName,
    required super.userNameSet,
    super.bio,
    super.displayPictureUrl,
    super.instagramUrl,
    super.tiktokUrl,
    required super.dateCreated,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid){
    return UserModel(
      id: uid, 
      email: map['email'] as String, 
      displayName: map['displayName'] as String?, 
      userName: map['userName'] as String? ?? "", 
      userNameSet: map['userNameSet'] as bool? ?? false,
      displayPictureUrl: map['displayPictureUrl'] as String?, 
      bio: map['bio'] as String?,
      instagramUrl: map['instagramUrl'] as String?,
      tiktokUrl: map['tiktokUrl'] as String?,
      dateCreated: (map['dateCreated'] as dynamic).toDate() as DateTime,
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'email': email,
      'displayName': displayName,
      'userName': userName,
      'userNameSet': userNameSet,
      'displayPictureUrl': displayPictureUrl,
      'bio': bio,
      'tiktokUrl': tiktokUrl,
      'instagramUrl': instagramUrl,
      'dateCreated': dateCreated
    };
  }
}

