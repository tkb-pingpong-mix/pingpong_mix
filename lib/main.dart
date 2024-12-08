import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pingpong_mix/app.dart';
import 'firebase_options.dart';
import 'package:pingpong_mix/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // AppRouter インスタンスを作成
  final appRouter = AppRouter();

  // アプリを起動
  runApp(
    ProviderScope(
      child: MyApp(appRouter: appRouter), // AppRouter を MyApp に渡す
    ),
  );
}
