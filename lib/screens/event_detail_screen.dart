import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = GoRouterState.of(context).extra as EventModel?;
    final user = ref.watch(userViewModelProvider).value;

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('イベント詳細')),
        body: const Center(child: Text('エラー: イベントが見つかりません')),
      );
    }

    final bool isParticipant = user != null && event.participants.contains(user.userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('イベント詳細'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                event.description,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text('会場: ${event.venue} (${event.location})'),
              Text('開始日時: ${event.startDate.toDate()}'),
              Text('終了日時: ${event.endDate.toDate()}'),
              Text('主催者: ${event.organizerId}'),
              Text('最大参加人数: ${event.maxParticipants ?? '制限なし'}'),
              const SizedBox(height: 20),

              // 参加ボタン
              if (user != null && !isParticipant)
                ElevatedButton(
                  onPressed: () async {
                    await ref.read(eventViewModelProvider.notifier).joinEvent(event.eventId, user.userId);
                  },
                  child: const Text("参加する"),
                ),

              // すでに参加済みの場合
              if (isParticipant) const Text("あなたはこのイベントに参加済みです", style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
