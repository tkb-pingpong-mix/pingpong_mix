import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingpong_mix/providers/event_filter_state_provider.dart';
import 'package:pingpong_mix/utils/log.dart';
import '../models/event_model.dart';

final eventViewModelProvider = StateNotifierProvider<EventViewModel, AsyncValue<List<EventModel>>>((ref) {
  return EventViewModel();
});

class EventViewModel extends StateNotifier<AsyncValue<List<EventModel>>> {
  EventViewModel() : super(const AsyncValue.loading()) {
    fetchEvents();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// イベント一覧を取得
  Future<void> fetchEvents({String status = "open"}) async {
    try {
      final querySnapshot = await _firestore.collection('Events').where('status', isEqualTo: status).orderBy('startDate', descending: false).limit(30).get();

      final events = querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
      state = AsyncValue.data(events);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> fetchFilteredEvents(WidgetRef ref, {bool loadMore = false}) async {
    try {
      Log.d("fetchFilteredEvents: 処理開始");

      final filter = ref.read(eventFilterProvider);
      Query query = FirebaseFirestore.instance.collection('Events').where('status', isEqualTo: filter.status);

      Log.d("フィルタ条件: status = ${filter.status}");

      if (filter.keyword != null && filter.keyword!.isNotEmpty) {
        query = query.where("title", isGreaterThanOrEqualTo: filter.keyword).where("title", isLessThanOrEqualTo: "${filter.keyword}\uf8ff");
        Log.d("キーワード検索: ${filter.keyword}");
      }

      if (filter.startDateRange != null && filter.endDateRange != null) {
        query = query.where("startDate", isGreaterThanOrEqualTo: filter.startDateRange).where("startDate", isLessThanOrEqualTo: filter.endDateRange);
        Log.d("日付範囲検索: ${filter.startDateRange} 〜 ${filter.endDateRange}");
      }

      if (filter.startTimeRange != null && filter.endTimeRange != null) {
        query = query.where("startDate.hour", isGreaterThanOrEqualTo: filter.startTimeRange).where("startDate.hour", isLessThanOrEqualTo: filter.endTimeRange);
        Log.d("時間帯検索: ${filter.startTimeRange} 〜 ${filter.endTimeRange}");
      }

      if (filter.eventType != null) {
        query = query.where("eventType", isEqualTo: filter.eventType);
        Log.d("イベントタイプ: ${filter.eventType}");
      }

      if (filter.location != null) {
        query = query.where("location", isEqualTo: filter.location);
        Log.d("ロケーション: ${filter.location}");
      }

      if (filter.venueId != null) {
        query = query.where("venueId", isEqualTo: filter.venueId);
        Log.d("会場ID: ${filter.venueId}");
      }

      if (filter.organizerId != null) {
        query = query.where("organizerId", isEqualTo: filter.organizerId);
        Log.d("主催者ID: ${filter.organizerId}");
      }

      query = query.orderBy("startDate").limit(30);
      Log.d("クエリの最終形: ${query.toString()}");

      if (loadMore && filter.lastDocument != null) {
        query = query.startAfterDocument(filter.lastDocument);
        Log.d("ページネーション: lastDocument=${filter.lastDocument.id}");
      }

      final querySnapshot = await query.get();
      Log.d("取得したイベント数: ${querySnapshot.docs.length}");

      final events = querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();

      ref.read(eventFilterProvider.notifier).updateLastDocument(querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null);

      Log.d("fetchFilteredEvents: 成功");
      state = AsyncValue.data(events);
    } catch (e, stackTrace) {
      Log.e("fetchFilteredEvents: エラー発生", error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// eventIdに紐づくEventを取得
  Future<EventModel?> fetchEventById(String eventId) async {
    try {
      final docSnapshot = await _firestore.collection('Events').doc(eventId).get();

      if (!docSnapshot.exists) {
        return null; // イベントが存在しない場合
      }
      return EventModel.fromFirestore(docSnapshot);
    } catch (e) {
      return null; // エラーハンドリング
    }
  }

  /// 新しいイベントを作成（主催者情報・最大参加人数を含む）
  Future<void> createEvent(EventModel event) async {
    try {
      final eventRef = _firestore.collection('Events').doc(event.eventId);

      // Firestore に保存するデータを明示的にデバッグ
      final eventData = event.toFirestore();
      print("Saving event data: $eventData");

      await eventRef.set(eventData);
      fetchEvents(); // イベント一覧を更新
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print("Firestore Error: $e"); // エラー内容をログに出力
    }
  }

  /// イベントに参加（最大参加人数を考慮）
  Future<void> joinEvent(String eventId, String userId) async {
    try {
      final eventRef = _firestore.collection('Events').doc(eventId);
      final eventDoc = await eventRef.get();

      if (!eventDoc.exists) {
        state = AsyncValue.error("イベントが存在しません", StackTrace.current);
        return;
      }

      final event = EventModel.fromFirestore(eventDoc);
      final int currentParticipants = event.participants.length;
      final int? maxParticipants = event.maxParticipants;

      if (maxParticipants != null && currentParticipants >= maxParticipants) {
        state = AsyncValue.error("このイベントはすでに締め切られています", StackTrace.current);
        return;
      }

      await eventRef.update({
        'participants': FieldValue.arrayUnion([userId])
      });

      // もし現在の参加者数 +1 が上限に達した場合、`status` を `closed` に更新
      if (maxParticipants != null && currentParticipants + 1 == maxParticipants) {
        await eventRef.update({'status': 'closed'});
      }

      fetchEvents(); // 更新
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// イベントから退出
  Future<void> leaveEvent(String eventId, String userId) async {
    try {
      final eventRef = _firestore.collection('Events').doc(eventId);
      await eventRef.update({
        'participants': FieldValue.arrayRemove([userId])
      });

      fetchEvents(); // 更新
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// イベントを完了に更新（主催者のみ）
  Future<void> completeEvent(String eventId, String organizerId, String currentUserId) async {
    if (organizerId != currentUserId) {
      state = AsyncValue.error("イベントを完了できるのは主催者のみです", StackTrace.current);
      return;
    }
    try {
      await _firestore.collection('Events').doc(eventId).update({'status': 'completed'});
      fetchEvents(); // 更新
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
