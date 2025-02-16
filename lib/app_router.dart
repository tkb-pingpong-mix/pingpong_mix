import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpong_mix/models/post_model.dart';
import 'package:pingpong_mix/screens/chat_details_screen.dart';
import 'package:pingpong_mix/screens/chat_list_screen.dart';
import 'package:pingpong_mix/screens/event_create_screen.dart';
import 'package:pingpong_mix/screens/map_screen.dart';
import 'package:pingpong_mix/screens/post_create_screen.dart';
import 'package:pingpong_mix/screens/post_details_screen.dart';
import 'package:pingpong_mix/screens/filter_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/clan_list_screen.dart';
import 'screens/clan_edit_screen.dart';
import 'screens/post_list_screen.dart';
import 'screens/event_search_screen.dart';
import 'screens/event_detail_screen.dart';

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
          return HomeScreen(child: child);
        },
        routes: [
          // イベント検索画面
          GoRoute(
            path: '/home/events',
            builder: (context, state) => const EventSearchScreen(),
            routes: [
              // フィルター画面
              GoRoute(
                path: 'filter',
                builder: (context, state) => const FilterScreen(),
              ),
              // イベント作成画面
              GoRoute(
                path: 'create',
                builder: (context, state) => const EventCreateScreen(),
              ),
              // イベント詳細画面
              GoRoute(
                path: 'detail/:eventId',
                builder: (context, state) {
                  final eventId = state.pathParameters['eventId']!;
                  return EventDetailScreen(eventId: eventId);
                },
              ),
            ],
          ),
          // 投稿一覧画面
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
                  final chatRoomId = state.pathParameters['chatId'];
                  if (chatRoomId == null) {
                    throw Exception('Invalid Chat ID');
                  }
                  return ChatDetailsScreen(chatRoomId: chatRoomId);
                },
              ),
            ],
          ),
          // プロフィール画面
          GoRoute(
            path: '/home/profile',
            builder: (context, state) {
              return const ProfileScreen();
            },
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => ProfileEditScreen(),
              ),
            ],
          ),
          // マップ画面
          GoRoute(
            path: '/home/map',
            builder: (context, state) => const MapScreen(),
          ),
          // クラン画面
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
        return '/home/events';
      }

      return null;
    },
  );
}
