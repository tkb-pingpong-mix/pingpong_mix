import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String authorId;
  final String? title;
  final String content;
  final DateTime postedAt;
  final List<String>? imageURLs;
  final String? linkedEventId;
  final String likesId;
  final int likesCount;

  PostModel({
    required this.postId,
    required this.authorId,
    this.title,
    required this.content,
    required this.postedAt,
    this.imageURLs,
    required this.likesId,
    required this.likesCount,
    this.linkedEventId,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      authorId: data['authorId'] ?? '',
      title: data['title'],
      content: data['content'] ?? '',
      postedAt: (data['postedAt'] as Timestamp).toDate(),
      imageURLs: data['imageURLs'] != null
          ? List<String>.from(data['imageURLs'])
          : null,
      linkedEventId: data['linkedEventId'],
      likesId: data['likes_id'] ?? '',
      likesCount: (data['likes_count'] ?? 0),
    );
  }

  PostModel copyWith({
    String? title,
    List<String>? imageURLs,
    int? likesCount,
  }) {
    return PostModel(
      postId: postId,
      authorId: authorId,
      title: title ?? this.title,
      content: content,
      postedAt: postedAt,
      imageURLs: imageURLs ?? this.imageURLs,
      linkedEventId: linkedEventId,
      likesId: likesId,
      likesCount: likesCount ?? this.likesCount,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      if (title != null) 'title': title,
      'content': content,
      'postedAt': postedAt,
      if (imageURLs != null) 'imageURLs': imageURLs,
      if (linkedEventId != null) 'linkedEventId': linkedEventId,
      'likes_id': likesId,
      'likes_count': likesCount,
    };
  }
}
