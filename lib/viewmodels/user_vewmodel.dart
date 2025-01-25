import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';

// プロバイダ定義: UserViewModelのインスタンスを提供
final userViewModelProvider =
    StateNotifierProvider<UserViewModel, AsyncValue<AppUser?>>((ref) {
  return UserViewModel();
});

// ViewModelクラス: Firestoreのユーザーデータを管理する
class UserViewModel extends StateNotifier<AsyncValue<AppUser?>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserViewModel() : super(const AsyncValue.loading());

  Future<void> fetchUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        state = AsyncValue.data(AppUser.fromFirestore(doc));
      } else {
        Logger().w('User not found in Firestore');
        state = const AsyncValue.data(null);
      }
    } catch (e, stackTrace) {
      Logger().e('Error feÏtching user: \$e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createUser(AppUser appUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(appUser.userId)
          .set(appUser.toFirestore());
      state = AsyncValue.data(appUser);
    } catch (e, stackTrace) {
      Logger().e('Create User Failed: \$e');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // 状態をリセット
  Future<void> resetUser() async {
    state = const AsyncValue.data(null);
  }
}
