import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('投稿詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.content, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (post.imageURLs.isNotEmpty)
              Image.network(post.imageURLs.first,
                  width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text('投稿日: ${post.postedAt.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
