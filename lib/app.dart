import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pingpong_mix/app_router.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final ThemeData theme;

  const MyApp({super.key, required this.appRouter, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PingPongMix',
      theme: theme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
      supportedLocales: const [
        Locale('ja', ''), // 日本語
        Locale('en', ''), // 英語
        Locale('zh', ''), // 中国語
        Locale('ko', ''), // 韓国語
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
