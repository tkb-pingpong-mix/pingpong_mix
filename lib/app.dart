import 'package:flutter/material.dart';
import 'package:pingpong_mix/app_router.dart';
import 'package:pingpong_mix/utils/custom_colors.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PingPongMix',
      theme: ThemeData(
        primaryColor: CustomColors.primary,
        scaffoldBackgroundColor: CustomColors.scaffoldBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.appBarBackground,
          titleTextStyle: const TextStyle(
            color: CustomColors.appBarText,
            fontSize: 20.0,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: CustomColors.bottomNavBackground,
          selectedItemColor: CustomColors.selectedItem,
          unselectedItemColor: CustomColors.unselectedItem,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: CustomColors.textPrimary),
          bodyMedium: TextStyle(color: CustomColors.textSecondary),
          bodySmall: TextStyle(color: CustomColors.textTertiary),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: CustomColors.fabBackground,
          foregroundColor: CustomColors.fabForeground,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
    );
  }
}
