import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppIcons {
  static const IconData eventSearch = Icons.search;
  static const IconData posts = Icons.event;
  static const IconData chats = Icons.chat;
  static const IconData profile = Icons.person;
  static const IconData logout = Icons.logout;
}

final currentIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  static final List<Map<String, dynamic>> _tabs = [
    {'label': 'Events', 'icon': AppIcons.eventSearch, 'route': '/home/events'},
    {'label': 'Posts', 'icon': AppIcons.posts, 'route': '/home/posts'},
    {'label': 'Chats', 'icon': AppIcons.chats, 'route': '/home/chats'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(currentIndexProvider.notifier).state = index;
          context.go(_tabs[index]['route']!);
        },
        items: _tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: Icon(tab['icon']),
                  label: tab['label'],
                ))
            .toList(),
      ),
    );
  }
}
