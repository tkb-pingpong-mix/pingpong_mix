import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/event_viewmodel.dart';
import '../widgets/keyword_search_bar.dart';

class EventSearchScreen extends ConsumerWidget {
  const EventSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.watch(eventViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント検索"),
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
                  return const Center(child: Text("該当するイベントがありません"));
                }
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text("状態: ${event.status}"),
                      onTap: () {
                        context.push('/home/events/detail/${event.eventId}');
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text("エラー: $error")),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/home/events/create'); // イベント作成画面へ遷移
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
