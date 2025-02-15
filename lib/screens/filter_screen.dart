import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/event_filter_state_provider.dart';
import '../viewmodels/event_viewmodel.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(eventFilterProvider);
    final filterNotifier = ref.read(eventFilterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("絞り込み"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ステータス選択
            DropdownButton<String>(
              value: filterState.status,
              items: const [
                DropdownMenuItem(value: "open", child: Text("募集中")),
                DropdownMenuItem(value: "closed", child: Text("締め切り")),
                DropdownMenuItem(value: "completed", child: Text("完了")),
              ],
              onChanged: (value) {
                filterNotifier.updateFilter(status: value);
              },
            ),

            // 開始日選択
            ListTile(
              title: Text(filterState.startDateRange != null
                  ? "開始日: ${filterState.startDateRange!.toDate().toLocal().toString().split(' ')[0]}"
                  : "開始日を選択"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      filterState.startDateRange?.toDate() ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  filterNotifier.updateFilter(
                      startDateRange: Timestamp.fromDate(pickedDate));
                }
              },
            ),

            // 終了日選択
            ListTile(
              title: Text(filterState.endDateRange != null
                  ? "終了日: ${filterState.endDateRange!.toDate().toLocal().toString().split(' ')[0]}"
                  : "終了日を選択"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate:
                      filterState.endDateRange?.toDate() ?? DateTime.now(),
                  firstDate:
                      filterState.startDateRange?.toDate() ?? DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  filterNotifier.updateFilter(
                      endDateRange: Timestamp.fromDate(pickedDate));
                }
              },
            ),

            const SizedBox(height: 20),

            // 適用ボタン（適用後、元の画面に戻る）
            ElevatedButton(
              onPressed: () {
                ref
                    .read(eventViewModelProvider.notifier)
                    .fetchFilteredEvents(ref);
                context.pop();
              },
              child: const Text("適用"),
            ),
          ],
        ),
      ),
    );
  }
}
