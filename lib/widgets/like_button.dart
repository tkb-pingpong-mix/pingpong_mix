import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeButton extends StatefulWidget {
  final String postId;
  final String likesId;
  final int initialLikes;

  const LikeButton({
    super.key,
    required this.postId,
    required this.likesId,
    required this.initialLikes,
  });

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late int likes;
  bool? isLiked; // `late` を使わず `null` 許容にする
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    likes = widget.initialLikes;
    _checkIfLiked();
  }

  /// Firestore の `Likes` コレクションを確認して、いいね済みかを判定
  Future<void> _checkIfLiked() async {
    final likeRef = FirebaseFirestore.instance
        .collection('Likes')
        .doc('$userId\_${widget.postId}');
    final doc = await likeRef.get();

    if (mounted) {
      setState(() {
        isLiked = doc.exists;
      });
    }
  }

  /// いいねの追加・削除
  Future<void> _toggleLike() async {
    if (userId.isEmpty || isLiked == null)
      return; // `isLiked` が `null` の場合は処理しない

    setState(() {
      isLiked = !isLiked!;
      likes += isLiked! ? 1 : -1;
    });

    final likeRef = FirebaseFirestore.instance
        .collection('Likes')
        .doc('$userId\_${widget.postId}');
    final postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);

    if (isLiked!) {
      await likeRef.set({
        'userId': userId,
        'postId': widget.postId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await postRef.update({'likes_count': FieldValue.increment(1)});
    } else {
      await likeRef.delete();
      await postRef.update({'likes_count': FieldValue.increment(-1)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked == null
                ? Icons.favorite_border // データ取得前は空の状態
                : (isLiked! ? Icons.favorite : Icons.favorite_border),
            color: isLiked == true ? Colors.red : Colors.grey,
          ),
          onPressed: isLiked == null ? null : _toggleLike, // データ未取得時はボタン無効
        ),
        Text('$likes いいね', style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
