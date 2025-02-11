import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../utils/image_brightness.dart';
import '../models/post_model.dart';
import '../widgets/like_button.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Color overlayColor = Colors.black.withOpacity(0.6);

  @override
  void initState() {
    super.initState();
    _updateOverlayColor();
  }

  Future<void> _updateOverlayColor() async {
    if (widget.post.imageURLs.isNotEmpty) {
      double brightness =
          await calculateImageBrightness(widget.post.imageURLs.first);
      if (mounted) {
        // ← setState を呼ぶ前に mounted をチェック
        setState(() {
          overlayColor = brightness > 128
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.4);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 投稿画像（タップ時に詳細画面へ遷移）
          if (widget.post.imageURLs.isNotEmpty)
            GestureDetector(
              onTap: () {
                context.go('/home/posts/detail', extra: widget.post);
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.imageURLs.first,
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
                  // 動的オーバーレイ
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: overlayColor,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '投稿日: ${widget.post.postedAt.toLocal()}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                LikeButton(
                  postId: widget.post.postId,
                  likesId: widget.post.likesId,
                  initialLikes: widget.post.likesCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
