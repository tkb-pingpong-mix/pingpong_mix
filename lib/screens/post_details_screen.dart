import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/post_model.dart';
import '../widgets/like_button.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // `go_router` の `extra` から `PostModel` を取得
    final post = GoRouterState.of(context).extra as PostModel?;

    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('投稿詳細')),
        body: const Center(child: Text('エラー: 投稿が見つかりません')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿詳細'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.imageURLs.isNotEmpty)
            Image.network(
              post.imageURLs.first,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.content,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '投稿日: ${post.postedAt.toLocal()}',
                  style: const TextStyle(color: Colors.grey),
                ),
                LikeButton(
                  postId: post.postId,
                  likesId: post.likesId,
                  initialLikes: post.likesCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
