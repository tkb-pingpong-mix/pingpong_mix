import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid; // Firebase AuthのユーザーID
  final String? email; // ユーザーのメールアドレス
  final String? phoneNumber; // ユーザーの電話番号（電話認証用）
  final String? displayName; // ユーザー名
  final String? photoURL; // プロフィール画像URL

  UserModel({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoURL,
  });

  // Firebase UserからUserModelを生成するファクトリメソッド
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      phoneNumber: user.phoneNumber,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  // ユーザーデータをJSON形式に変換する（必要ならば使用）
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  // JSON形式からUserModelを生成する（必要ならば使用）
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }
}
