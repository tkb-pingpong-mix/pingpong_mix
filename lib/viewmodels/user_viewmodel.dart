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
      if (userId.isEmpty) {
        throw Exception("User ID is empty.");
      }

      final doc = await _firestore.collection('Users').doc(userId).get();
      if (doc.exists) {
        state = AsyncValue.data(AppUser.fromFirestore(doc));
      } else {
        state = const AsyncValue.data(null);
        Logger().w('User not found in Firestore');
      }
    } catch (e, stackTrace) {
      Logger().e('Error fetching user: $e, $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createUser(AppUser appUser) async {
    try {
      if (appUser.userId.isEmpty) {
        throw Exception("User ID is empty.");
      }

      await _firestore
          .collection('Users')
          .doc(appUser.userId)
          .set(appUser.toFirestore());
      state = AsyncValue.data(appUser);
    } catch (e, stackTrace) {
      Logger().e('Create User Failed: $e , $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }
  

  Future<void> updateUser(AppUser updatedUser) async {
    try {
      await _firestore
          .collection('Users')
          .doc(updatedUser.userId)
          .update(updatedUser.toFirestore());
      state = AsyncValue.data(updatedUser);
      Logger().i('User profile updated successfully');
    } catch (e, stackTrace) {
      Logger().e('Update User Failed: $e, $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // 状態をリセット
  Future<void> resetUser() async {
    state = const AsyncValue.data(null);
  }
}
