import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/post_model.dart';
import '../widgets/like_button.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = GoRouterState.of(context).extra as PostModel?;

    if (post == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('投稿詳細'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                context.go('/home/profile');
              },
            ),
          ],
        ),
      );
    }

    final bool hasImage = post.imageURLs != null && post.imageURLs!.isNotEmpty;
    final bool hasTitle = post.title != null && post.title!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿詳細'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasTitle)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  post.title!,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            if (hasImage)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.imageURLs!.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: post.imageURLs![index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey,
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                post.content,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  // 投稿日時
                  Text('投稿日: ${post.postedAt.toLocal()}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                    postId: post.postId,
                    likesId: post.likesId,
                    initialLikes: post.likesCount,
                  ),
                  Text(
                    '${post.likesCount} いいね',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
