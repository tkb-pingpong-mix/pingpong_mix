import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String authorId;
  final String content;
  final DateTime postedAt;
  final List<String> imageURLs;
  final String? linkedEventId;

  PostModel({
    required this.postId,
    required this.authorId,
    required this.content,
    required this.postedAt,
    required this.imageURLs,
    this.linkedEventId,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      authorId: data['authorId'],
      content: data['content'],
      postedAt: (data['postedAt'] as Timestamp).toDate(),
      imageURLs: List<String>.from(data['imageURLs'] ?? []),
      linkedEventId: data['linkedEventId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'content': content,
      'postedAt': postedAt,
      'imageURLs': imageURLs,
      if (linkedEventId != null) 'linkedEventId': linkedEventId,
    };
  }
}
