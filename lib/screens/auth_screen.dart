import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/viewmodels/auth_viewmodel.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import '../models/user_model.dart';
import '../utils/custom_colors.dart';

class AuthScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final userViewModel = ref.read(userViewModelProvider.notifier);
    final authViewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Authentication'),
        centerTitle: true,
        backgroundColor: CustomColors.appBarBackground,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            // 未ログイン状態: ログインフォームを表示
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign in to continue',
                      style: TextStyle(
                          fontSize: 16.0, color: CustomColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    if (authViewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          authViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email, color: CustomColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            Icon(Icons.lock, color: CustomColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        await authViewModel.signInWithEmailAndPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        print(userId);
                        if (userId != null) {
                          await userViewModel.fetchUser(userId);
                          context.go('/home/matching');
                        }
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        side: BorderSide(color: CustomColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        await ref
                            .read(authViewModelProvider.notifier)
                            .signUpWithEmailAndPassword(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          final newUser = AppUser(
                            userId: userId,
                            email: _emailController.text.trim(),
                            displayName: '',
                            profilePicture: '',
                            skillLevel: '',
                            region: '',
                            playStyle: '',
                            createdAt: DateTime.now(),
                            totalWins: 0,
                            totalLosses: 0,
                            winRate: 0.0,
                            recentMatches: [],
                            clans: [],
                            events: [],
                            posts: [],
                          );
                          await userViewModel.createUser(newUser);
                          context.go('/home/matching');
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // ログイン済み: 既に取得したユーザー情報に基づいて遷移
            return const Center(child: CircularProgressIndicator());
          }
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
