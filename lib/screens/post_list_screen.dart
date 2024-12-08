import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/models/post_model.dart';
import 'package:pingpong_mix/screens/post_details_screen.dart';

class PostListScreen extends StatelessWidget {
  final List<PostModel> posts = [
    PostModel(
        id: '1',
        title: 'Table Tennis Tips',
        content: 'Learn some great tips for improving your game...',
        timestamp: DateTime.now().subtract(Duration(days: 1))),
    PostModel(
        id: '2',
        title: 'Upcoming Tournaments',
        content: 'Check out these upcoming tournaments in your area...',
        timestamp: DateTime.now().subtract(Duration(days: 2))),
    // Add more sample posts
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content.length > 50
                ? post.content.substring(0, 50) + '...'
                : post.content),
            trailing: Text(
              "${post.timestamp.month}/${post.timestamp.day}/${post.timestamp.year}",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              context.go('/home/posts/detail', extra: post);
            },
          );
        },
      ),
    );
  }
}
