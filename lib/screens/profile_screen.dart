import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/profile_placeholder.png'), // プロフィール画像のプレースホルダー
            ),
            const SizedBox(height: 16),
            const Text(
              'User Name', // ユーザー名
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'user@example.com', // メールアドレス
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // プロフィール編集画面に遷移
                context.go('/home/profile/edit');
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // ログアウト処理を実行
                context.go('/auth');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
