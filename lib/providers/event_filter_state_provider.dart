import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/state/event_filter_state.dart';

class EventFilterStateNotifier extends StateNotifier<EventFilterState> {
  EventFilterStateNotifier() : super(EventFilterState());

  void updateFilter({
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
    state = state.copyWith(
      status: status ?? state.status,
      startDateRange: startDateRange ?? state.startDateRange,
      endDateRange: endDateRange ?? state.endDateRange,
      startTimeRange: startTimeRange ?? state.startTimeRange,
      endTimeRange: endTimeRange ?? state.endTimeRange,
      eventType: eventType ?? state.eventType,
      location: location ?? state.location,
      venueId: venueId ?? state.venueId,
      maxParticipants: maxParticipants ?? state.maxParticipants,
      organizerId: organizerId ?? state.organizerId,
      showFullEvents: showFullEvents ?? state.showFullEvents,
      keyword: keyword ?? state.keyword,
      lastDocument: lastDocument ?? state.lastDocument,
    );
  }

  void updateKeyword(String keyword) {
    state = state.copyWith(keyword: keyword.isNotEmpty ? keyword : null);
  }

  void updateLastDocument(dynamic lastDoc) {
    state = state.copyWith(lastDocument: lastDoc);
  }

  void resetPagination() {
    state = state.copyWith(lastDocument: null);
  }

  void resetFilters() {
    state = EventFilterState();
  }
}

final eventFilterProvider =
    StateNotifierProvider<EventFilterStateNotifier, EventFilterState>((ref) {
  return EventFilterStateNotifier();
});
