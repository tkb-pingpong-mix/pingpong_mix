import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/event_viewmodel.dart';
import '../widgets/keyword_search_bar.dart';

class EventSearchScreen extends ConsumerWidget {
  const EventSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            context.go('/home/profile');
          },
        ),
        title: const Text("Event Search"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              context.push('/home/events/filter');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // キーワード検索バー
          KeywordSearchBar(),

          // イベントリスト
          Expanded(
            child: eventState.when(
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      "該当するイベントがありません",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: events.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      elevation: 2,
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text("状態: ${event.status}"),
                        onTap: () {
                          context.push('/home/events/detail/${event.eventId}');
                        },
                        trailing: Icon(Icons.chevron_right),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  "エラー: $error",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/home/events/create'); // イベント作成画面へ遷移
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
    );
  }
}
