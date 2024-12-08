import 'package:flutter/material.dart';
import 'package:pingpong_mix/models/post_model.dart';

class PostDetailsScreen extends StatelessWidget {
  final PostModel post;

  PostDetailsScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "${post.timestamp.month}/${post.timestamp.day}/${post.timestamp.year}",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              post.content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
