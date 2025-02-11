import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

final postCreateProvider =
    StateNotifierProvider<PostCreateViewModel, AsyncValue<void>>(
        (ref) => PostCreateViewModel());

class PostCreateViewModel extends StateNotifier<AsyncValue<void>> {
  PostCreateViewModel() : super(const AsyncValue.data(null));

  Future<bool> submitPost(String userId, String? title, String content) async {
    if (content.isEmpty) return false;

    state = const AsyncValue.loading();
    try {
      final newPost = PostModel(
        postId: '', // Firestore の `doc.id` を後で取得
        authorId: userId,
        title: title?.isEmpty == true ? null : title,
        content: content,
        postedAt: DateTime.now(),
        imageURLs: [],
        linkedEventId: null,
        likesId: '', // 初期値
        likesCount: 0, // 初期値
      );

      final docRef = await FirebaseFirestore.instance
          .collection('Posts')
          .add(newPost.toFirestore());

      // Firestore から `postId` を設定
      await docRef.update({'postId': docRef.id});

      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}
