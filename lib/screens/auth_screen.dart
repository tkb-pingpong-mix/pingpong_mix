import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/custom_colors.dart';

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
      appBar: AppBar(
        title: const Text('Email Authentication'),
        centerTitle: true,
        backgroundColor: CustomColors.appBarBackground,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                style: TextStyle(fontSize: 16.0, color: CustomColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: CustomColors.primary),
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
                  prefixIcon: Icon(Icons.lock, color: CustomColors.primary),
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

                  final updatedAuthState = ref.read(authViewModelProvider);

                  if (updatedAuthState.user != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go('/home/matching');
                    });
                  } else if (updatedAuthState.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(updatedAuthState.errorMessage!),
                          backgroundColor: Colors.red,
                        ),
                      );
                    });
                  }
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                  await authViewModel.signUpWithEmailAndPassword(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16.0, color: CustomColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
