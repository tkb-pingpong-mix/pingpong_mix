import 'package:flutter/material.dart';
import 'package:pingpong_mix/app_router.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PingPongMix',
      theme: ThemeData(
        primarySwatch: Colors.blue, // メインカラー
        scaffoldBackgroundColor: Colors.white, // Scaffold全体の背景色
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // AppBarの背景色
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blue, // BottomNavigationBarの背景色
          selectedItemColor: Color.fromARGB(255, 247, 3, 3), // 選択されたアイテムの色
          unselectedItemColor:
              Color.fromARGB(179, 231, 58, 211), // 選択されていないアイテムの色
        ),
      ),
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      routerConfig: appRouter.router, // GoRouter を設定
    );
  }
}
