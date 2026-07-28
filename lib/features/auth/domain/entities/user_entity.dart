class UserEntity {
  final String id;
  final String userName;
  final bool userNameSet;
  final String? displayName;
  final String email;
  final String? bio;
  final String? displayPictureUrl;
  final DateTime dateCreated;
  final String? instagramUrl;
  final String? tiktokUrl;

  const UserEntity({
    required this.id,
    required this.userName,
    required this.userNameSet,
    this.displayName,
    required this.email,
    this.bio,
    this.displayPictureUrl,
    required this.dateCreated,
    this.instagramUrl,
    this.tiktokUrl,
  });
}