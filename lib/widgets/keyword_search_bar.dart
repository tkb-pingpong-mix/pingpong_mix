import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_filter_state_provider.dart';
import '../viewmodels/event_viewmodel.dart';

class KeywordSearchBar extends ConsumerStatefulWidget {
  const KeywordSearchBar({super.key});

  @override
  ConsumerState<KeywordSearchBar> createState() => _KeywordSearchBarState();
}

class _KeywordSearchBarState extends ConsumerState<KeywordSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "イベント名で検索",
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final keyword = _searchController.text.trim();
              ref.read(eventFilterProvider.notifier).updateKeyword(keyword);
              ref
                  .read(eventViewModelProvider.notifier)
                  .fetchFilteredEvents(ref);
            },
            child: const Text("検索"),
          ),
        ],
      ),
    );
  }
}
