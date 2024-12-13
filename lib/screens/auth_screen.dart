import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);
    final errorMessage = authState.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('Email Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.signInWithEmailAndPassword(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );

                // 認証成功の場合のみ次の画面に進む
                if (ref.read(authViewModelProvider).user != null) {
                  context.go('/home/matching');
                } else {
                  // 認証失敗の場合、エラーメッセージを表示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ref.read(authViewModelProvider).errorMessage ?? 'Sign-in failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async {
                await authViewModel.signUpWithEmailAndPassword(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );

                // 登録成功の場合のみ次の画面に進む
                if (ref.read(authViewModelProvider).user != null) {
                  context.go('/home/matching');
                } else {
                  // 登録失敗の場合、エラーメッセージを表示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ref.read(authViewModelProvider).errorMessage ?? 'Sign-up failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Sign Up'),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
