import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String likesId; // 投稿またはイベントに紐づく "likes_xxx" ID
  final int likesCount; // いいね数
  final List<String> likedBy; // いいねしたユーザーのリスト

  LikeModel({
    required this.likesId,
    required this.likesCount,
    required this.likedBy,
  });

  /// Firestore からデータを取得
  factory LikeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LikeModel(
      likesId: doc.id,
      likesCount: (data['likesCount'] ?? 0),
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  /// Firestore にデータを保存
  Map<String, dynamic> toFirestore() {
    return {
      'likesCount': likesCount,
      'likedBy': likedBy,
    };
  }

  Future<void> addLike(String postId, String userId) async {
    final likeRef =
        FirebaseFirestore.instance.collection('Likes').doc('${userId}_$postId');
    final postRef = FirebaseFirestore.instance.collection('Posts').doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // いいねデータを追加
      transaction.set(likeRef, {
        'userId': userId,
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // `likes_count` を即時更新
      transaction.update(postRef, {'likes_count': FieldValue.increment(1)});
    });
  }
}
