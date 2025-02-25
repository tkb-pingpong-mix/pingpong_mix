import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/viewmodels/post_create_viewmodel.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import 'package:pingpong_mix/viewmodels/image_picker_viewmodel.dart';
import 'dart:io';

class PostCreateScreen extends ConsumerWidget {
  const PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postCreateProvider);
    final postViewModel = ref.read(postCreateProvider.notifier);
    final user = ref.watch(userViewModelProvider).value;
    final image = ref.watch(imagePickerProvider);
    final imagePickerViewModel = ref.read(imagePickerProvider.notifier);

    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('新規投稿')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'タイトル（省略可）'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: '本文'),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: imagePickerViewModel.pickImage,
              child: const Text('画像を選択'),
            ),
            const SizedBox(height: 12),
            if (image != null) Image.file(File(image.path)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: postState.isLoading || user == null
                  ? null
                  : () async {
                      final success = await postViewModel.submitPost(
                        titleController.text,
                        contentController.text,
                        image?.path ?? '',
                      );

                      if (success && context.mounted) {
                        context.pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('投稿に失敗しました')),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: postState.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('投稿する'),
            ),
          ],
        ),
      ),
    );
  }
}
