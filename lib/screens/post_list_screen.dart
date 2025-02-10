import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import 'post_details_screen.dart';

final postsProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  return FirebaseFirestore.instance.collection('Posts').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList(),
      );
});

class PostListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('投稿一覧')),
      body: postsAsync.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              child: ListTile(
                leading: post.imageURLs.isNotEmpty
                    ? Image.network(post.imageURLs.first,
                        width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.text_snippet),
                title: Text(post.content),
                subtitle: Text(post.postedAt.toLocal().toString()),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostDetailsScreen(post: post)),
                ),
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('エラー: $error')),
      ),
    );
  }
}
