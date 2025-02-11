import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/widgets/post_card.dart';
import '../models/post_model.dart';

final postsProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  return FirebaseFirestore.instance.collection('Posts').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList(),
      );
});

class PostListScreen extends ConsumerWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿一覧'),
        centerTitle: true,
        elevation: 5,
      ),
      body: postsAsync.when(
        data: (posts) => ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
        ),
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'エラー: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/home/posts/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
