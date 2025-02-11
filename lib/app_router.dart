import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/models/post_model.dart';
import 'package:pingpong_mix/screens/chat_details_screen.dart';
import 'package:pingpong_mix/screens/chat_list_screen.dart';
import 'package:pingpong_mix/screens/map_screen.dart';
import 'package:pingpong_mix/screens/post_create_screen.dart';
import 'package:pingpong_mix/screens/post_details_screen.dart';
import 'package:pingpong_mix/viewmodels/user_viewmodel.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/clan_list_screen.dart';
import 'screens/clan_edit_screen.dart';
import 'screens/post_list_screen.dart';
import 'screens/matching_screen.dart';

// 設計概要
// アプリ起動時の流れ

// 最初に SplashScreen を表示。
// ユーザーがログイン済みかどうかを確認し、以下のいずれかに遷移：
// ログイン済み → HomeScreen
// 未ログイン → AuthScreen
// HomeScreen の構成

// BottomNavigationBar を使用して以下のタブを管理：
// チャット (/home/chats)
// マッチング (/home/matching)
// 投稿 (/home/posts)
// AppBar のプロファイルボタン：
// プロファイル画面に遷移 (/home/profile)

class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(
              child: child); // HomeScreen with BottomNavigationBar
        },
        routes: [
          GoRoute(
            path: '/home/matching',
            builder: (context, state) => const MatchingScreen(),
          ),
          GoRoute(
            path: '/home/posts',
            builder: (context, state) => PostListScreen(),
            routes: [
              GoRoute(
                path: 'detail',
                builder: (context, state) {
                  final post = state.extra as PostModel?;
                  if (post == null) {
                    throw Exception('PostModel が null です');
                  }
                  return PostDetailsScreen();
                },
              ),
              GoRoute(
                path: 'create',
                builder: (context, state) => PostCreateScreen(),
              ),
            ],
          ),

          // チャットリスト画面
          GoRoute(
            path: '/home/chats',
            builder: (context, state) => ChatListScreen(),
            routes: [
              // チャット詳細画面
              GoRoute(
                path: 'detail/:chatId',
                builder: (context, state) {
                  final chatId = state.pathParameters['chatId'];
                  if (chatId == null) {
                    // エラーハンドリング: chatId が無い場合
                    throw Exception('Invalid Chat ID');
                  }
                  return ChatDetailsScreen(chatId: chatId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/home/profile',
            builder: (context, state) {
              final container = ProviderScope.containerOf(context);
              final userViewModel =
                  container.read(userViewModelProvider.notifier);

              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                userViewModel.fetchUser(userId); // fetchUserを呼び出す
              }

              return const ProfileScreen(); // ProfileScreenを返す
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => ProfileEditScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/home/map',
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: '/home/clan',
            builder: (context, state) => const ClanListScreen(),
            routes: [
              GoRoute(
                path: 'clan-edit',
                builder: (context, state) => const ClanEditScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isAuthRoute = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isAuthRoute) {
        return '/auth';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/home/matching';
      }

      return null;
    },
  );
}
