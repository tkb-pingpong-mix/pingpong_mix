import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/image_brightness.dart';

class PostCard extends StatefulWidget {
  final String imageUrl;
  final String content;

  const PostCard({
    super.key,
    required this.imageUrl,
    required this.content,
  });

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
    double brightness = await calculateImageBrightness(widget.imageUrl);
    setState(() {
      overlayColor = brightness > 128
          ? Colors.black.withOpacity(0.4) // 明るい画像なら濃いめの黒
          : Colors.white.withOpacity(0.4); // 暗い画像なら薄めの白
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Stack(
        children: [
          // 背景画像 (キャッシュ対応)
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
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
          // アニメーション付きオーバーレイ
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [
                  overlayColor.withOpacity(0.8),
                  overlayColor.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // テキスト
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              widget.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
