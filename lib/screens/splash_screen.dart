import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(seconds: 2), () {
      final authState = ref.read(authProvider); // AuthState を取得
      //TODO: 必ずhomeを表示するようにしているため、元に戻す
      if (authState.user != null) {
        // AuthState 内の user が null かどうかを判定
        context.go('/home/matching');
      } else {
        context.go('/auth');
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
