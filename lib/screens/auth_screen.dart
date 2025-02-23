import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/viewmodels/auth_viewmodel.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import '../models/user_model.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Authentication'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to continue',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // エラーメッセージ表示用
              Consumer(
                builder: (context, ref, _) {
                  final errorMessage = ref.watch(authErrorProvider);
                  if (errorMessage == null) return const SizedBox.shrink();
                  print("Error message set: $errorMessage");
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      errorMessage,
                    ),
                  );
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
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
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, _) {
                  final authViewModel = ref.watch(authViewModelProvider.notifier);
                  final userViewModel = ref.watch(userViewModelProvider.notifier);

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () async {
                      try {
                        await authViewModel.signInWithEmailAndPassword(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        final userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null && context.mounted) {
                          await userViewModel.fetchUser(userId);
                          if (context.mounted) {
                            context.go('/home/events');
                            authViewModel.errorMessage = null;
                          }
                        }
                      } catch (e) {
                        authViewModel.errorMessage = "Sign In failed: $e";
                      }
                    },
                    child: const Text(
                      'Sign In',
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  final authViewModel = ref.read(authViewModelProvider.notifier);
                  final userViewModel = ref.read(userViewModelProvider.notifier);

                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: BorderSide(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      await authViewModel.signUpWithEmailAndPassword(
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
                        if (context.mounted) {
                          context.go('/home/events');
                          authViewModel.errorMessage = null;
                        }
                      }
                    },
                    child: const Text('Sign Up'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
