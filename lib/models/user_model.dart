class UserModel {
  final String uid;
  final String phoneNumber;

  UserModel({required this.uid, required this.phoneNumber});

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      phoneNumber: user.phoneNumber ?? '',
    );
  }
}
