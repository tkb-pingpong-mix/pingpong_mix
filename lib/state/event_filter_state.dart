import 'package:cloud_firestore/cloud_firestore.dart';

class EventFilterState {
  final String status;
  final Timestamp? startDateRange; // Firestore `Timestamp` に変更
  final Timestamp? endDateRange; // Firestore `Timestamp` に変更
  final int? startTimeRange; // 追加: 検索開始時刻（24時間制、例: 17 = 17:00）
  final int? endTimeRange; // 追加: 検索終了時刻（24時間制、例: 22 = 22:00）
  final String? eventType;
  final String? location;
  final String? venueId;
  final int? maxParticipants;
  final String? organizerId;
  final bool showFullEvents;
  final String? keyword;
  final dynamic lastDocument;

  EventFilterState({
    this.status = "open",
    this.startDateRange,
    this.endDateRange,
    this.startTimeRange,
    this.endTimeRange,
    this.eventType,
    this.location,
    this.venueId,
    this.maxParticipants,
    this.organizerId,
    this.showFullEvents = false,
    this.keyword,
    this.lastDocument,
  });

  EventFilterState copyWith({
    String? status,
    Timestamp? startDateRange,
    Timestamp? endDateRange,
    int? startTimeRange,
    int? endTimeRange,
    String? eventType,
    String? location,
    String? venueId,
    int? maxParticipants,
    String? organizerId,
    bool? showFullEvents,
    String? keyword,
    dynamic lastDocument,
  }) {
    return EventFilterState(
      status: status ?? this.status,
      startDateRange: startDateRange ?? this.startDateRange,
      endDateRange: endDateRange ?? this.endDateRange,
      startTimeRange: startTimeRange ?? this.startTimeRange,
      endTimeRange: endTimeRange ?? this.endTimeRange,
      eventType: eventType ?? this.eventType,
      location: location ?? this.location,
      venueId: venueId ?? this.venueId,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      organizerId: organizerId ?? this.organizerId,
      showFullEvents: showFullEvents ?? this.showFullEvents,
      keyword: keyword ?? this.keyword,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}
