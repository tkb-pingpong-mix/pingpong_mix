import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';

// プロバイダ定義: UserViewModelのインスタンスを提供
final userViewModelProvider =
    StateNotifierProvider<UserViewModel, AppUser?>((ref) {
  return UserViewModel();
});

class UserViewModel extends StateNotifier<AppUser?> {
  UserViewModel() : super(null);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ユーザー情報をFirestoreから取得
  Future<void> fetchUser(String userId) async {
    try {
      final doc = await _firestore.collection('Users').doc(userId).get();
      if (doc.exists) {
        state = AppUser.fromFirestore(doc);
      } else {
        state = null;
        // Use a logging framework like Logger
        Logger().w('User not found in Firestore');
      }
    } catch (e) {
      // Use a logging framework like Logger
      Logger().e('Error feÏtching user: \$e');
      state = null;
    }
  }

  // ユーザー情報を更新
  Future<void> updateUser(AppUser updatedUser) async {
    try {
      await _firestore.collection('Users').doc(updatedUser.userId).set(
            updatedUser.toFirestore(),
          );
      state = updatedUser;
    } catch (e) {
      // Use a logging framework like Logger
      Logger().e('Error updating user: \$e');
    }
  }

  // 状態をリセット
  void resetUser() {
    state = null;
  }
}
