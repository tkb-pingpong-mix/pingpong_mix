import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:json_theme_plus/json_theme_plus.dart';
import 'package:pingpong_mix/app.dart';
import 'firebase_options.dart';
import 'package:pingpong_mix/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // AppRouter インスタンスを作成
  final appRouter = AppRouter();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  // アプリを起動
  runApp(
    ProviderScope(
      child: MyApp(appRouter: appRouter, theme: theme), // AppRouter を MyApp に渡す
    ),
  );
}
