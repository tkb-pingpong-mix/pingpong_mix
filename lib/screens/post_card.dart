import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/post_model.dart';
import '../widgets/like_button.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final bool hasTitle = post.title != null && post.title!.isNotEmpty;
    final bool hasImage = post.imageURLs != null && post.imageURLs!.isNotEmpty;
    final String? firstImage = hasImage ? post.imageURLs!.first : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 画像エリア（タップで詳細画面へ遷移）
          if (hasImage)
            GestureDetector(
              onTap: () => context.go('/home/posts/detail', extra: post),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: firstImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported,
                        size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
          // テキストエリア（タイトル・本文）
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasTitle)
                  GestureDetector(
                    onTap: () => context.go('/home/posts/detail', extra: post),
                    child: Text(
                      post.title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => context.go('/home/posts/detail', extra: post),
                  child: Text(
                    post.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '投稿日: ${post.postedAt.toLocal()}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
