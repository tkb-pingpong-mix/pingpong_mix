import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/viewmodels/auth_viewmodel.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            // 未ログイン状態の場合
            return const Center(child: Text('No user data available'));
          }
          // ログイン中の場合
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.profilePicture.isNotEmpty
                      ? NetworkImage(user.profilePicture)
                      : const AssetImage(
                              'assets/images/profile_placeholder.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName.isNotEmpty ? user.displayName : 'User Name',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email.isNotEmpty ? user.email : 'user@example.com',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                  onPressed: () async {
                    // ログアウト処理
                    await ref.read(userViewModelProvider.notifier).resetUser();
                    await ref.read(authViewModelProvider.notifier).signOut();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
