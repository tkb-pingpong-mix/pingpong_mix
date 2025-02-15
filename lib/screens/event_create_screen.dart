import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

class EventCreateScreen extends ConsumerStatefulWidget {
  const EventCreateScreen({super.key});

  @override
  ConsumerState<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends ConsumerState<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _eventType = "match";
  int? _maxParticipants;
  bool _isLoading = false;

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && context.mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 0),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startDate = selectedDateTime;
            _startDateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.format(context)}";
          } else {
            _endDate = selectedDateTime;
            _endDateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day} ${pickedTime.format(context)}";
          }
        });
      }
    }
  }

  Future<void> _createEvent() async {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
      setState(() {
        _isLoading = true;
      });

      final user = ref.watch(userViewModelProvider).value;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザー情報を取得できませんでした')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final eventId = FirebaseFirestore.instance.collection("Events").doc().id;
      final newEvent = EventModel(
        eventId: eventId,
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: Timestamp.fromDate(_startDate!),
        endDate: Timestamp.fromDate(_endDate!),
        location: _locationController.text,
        venue: _venueController.text,
        organizerId: user.userId,
        participants: [],
        matchHistory: [],
        eventType: _eventType,
        isLeague: false,
        maxParticipants: _maxParticipants,
        status: "open",
      );

      await ref.read(eventViewModelProvider.notifier).createEvent(newEvent);

      setState(() {
        _isLoading = false;
      });

      if (context.mounted) {
        context.go('/home/events');
      } // イベント作成後、イベント一覧へ遷移}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("イベント作成")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "タイトル"),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "説明"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "場所"),
              ),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: "会場名"),
              ),
              const SizedBox(height: 10),

              // 開始日時
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "開始日時"),
                onTap: () => _selectDateTime(context, true),
              ),

              // 終了日時
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "終了日時"),
                onTap: () => _selectDateTime(context, false),
              ),

              // イベント種別
              DropdownButtonFormField<String>(
                value: _eventType,
                decoration: const InputDecoration(labelText: "イベント種別"),
                items: const [
                  DropdownMenuItem(value: "match", child: Text("試合")),
                  DropdownMenuItem(value: "practice", child: Text("練習")),
                  DropdownMenuItem(value: "trial", child: Text("試打会")),
                ],
                onChanged: (value) {
                  setState(() {
                    _eventType = value!;
                  });
                },
              ),

              // 最大参加人数
              TextFormField(
                decoration: const InputDecoration(labelText: "最大参加人数（オプション）"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _maxParticipants = int.tryParse(value);
                  });
                },
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _createEvent,
                      child: const Text("作成"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
