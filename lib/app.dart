import 'package:flutter/material.dart';
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
    );
  }
}
