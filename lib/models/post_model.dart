import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String authorId;
  final String content;
  final DateTime postedAt;
  final List<String> imageURLs;
  final String? linkedEventId;
  final String likesId; // いいねデータの管理ID
  final int likesCount; // いいね数のキャッシュ


  PostModel({
    required this.postId,
    required this.authorId,
    required this.content,
    required this.postedAt,
    required this.imageURLs,
    required this.likesId,
    required this.likesCount,
    this.linkedEventId,
  });

  /// Firestore からデータを取得するコンストラクタ
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      authorId: data['authorId'] ?? '',
      content: data['content'] ?? '',
      postedAt: (data['postedAt'] as Timestamp).toDate(),
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
      linkedEventId: data['linkedEventId'],
      likesId: data['likes_id'] ?? '', // `Likes` コレクションの ID
      likesCount: (data['likes_count'] ?? 0), // `likes_count` のキャッシュ
    );
  }

  /// `copyWith` メソッド: 指定した値だけを更新して新しいインスタンスを作成
  PostModel copyWith({
    int? likesCount,
  }) {
    return PostModel(
      postId: postId,
      authorId: authorId,
      content: content,
      postedAt: postedAt,
      imageURLs: imageURLs,
      linkedEventId: linkedEventId,
      likesId: likesId,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  /// Firestore にデータを保存するためのマップ変換
  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'content': content,
      'postedAt': postedAt,
      'imageURLs': imageURLs,
      if (linkedEventId != null) 'linkedEventId': linkedEventId,
      'likes_id': likesId, // いいねの ID
      'likes_count': likesCount, // いいね数のキャッシュ
    };
  }
}
