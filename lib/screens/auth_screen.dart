import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:pingpong_mix/widgets/phone_number_input.dart';

class AuthScreen extends ConsumerWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);
    final isCodeSent = authState.isCodeSent;
    final errorMessage = authState.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCodeSent)
              PhoneNumberInput(
                phoneController: _phoneController,
                onPhoneNumberSubmitted: (phoneNumber) async {
                  // 電話番号を使ってFirebaseの認証をリクエスト
                  await authViewModel.verifyPhoneNumber(phoneNumber);
                },
              ),
            if (isCodeSent)
              TextField(
                controller: _smsController,
                decoration: const InputDecoration(labelText: 'SMS Code'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isCodeSent) {
                  // SMSコードを使ってサインイン/サインアップ
                  await authViewModel
                      .signUpWithSmsCode(_smsController.text.trim());

                  // 認証が成功したら、ホーム画面へ遷移
                  if (ref.read(authViewModelProvider).user != null) {
                    context.go('/home/matching');
                  }
                }
              },
              child: Text(isCodeSent ? 'Complete Verification' : 'Send Code'),
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
