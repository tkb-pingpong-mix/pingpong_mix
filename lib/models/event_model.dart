import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String venue; // 必須: 会場名（自由記述）
  final String? venueId; // オプション: 卓球場ID（Venues コレクションと紐付け）
  final GeoPoint? geoPoint; // オプション: 緯度・経度
  final String organizerId; // 主催者ID
  final List<String> participants; // 参加ユーザーIDリスト
  final List<String> matchHistory; // 試合IDリスト
  final String eventType; // "試合" / "練習" / "試打会" など
  final bool isLeague; // true: リーグ戦, false: 通常の試合
  final int? maxParticipants; // オプション: 最大参加人数
  final String status; // "open"（募集中）/ "closed"（締め切り）/ "completed"（完了）

  EventModel({
    required this.eventId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.venue, // 必須
    this.venueId, // オプション
    this.geoPoint, // オプション
    required this.organizerId, // 主催者ID
    required this.participants,
    required this.matchHistory,
    required this.eventType,
    required this.isLeague,
    this.maxParticipants, // オプション
    required this.status, // 募集状態
  });

  /// Firestore からデータを取得してモデルに変換
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      eventId: data['eventId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      venue: data['venue'] ?? '', // 会場名
      venueId: data['venueId'], // 卓球場ID（オプション）
      geoPoint: data['geoPoint'] != null
          ? data['geoPoint'] as GeoPoint
          : null, // 緯度・経度（オプション）
      organizerId: data['organizerId'] ?? '', // 主催者ID
      participants: List<String>.from(data['participants'] ?? []),
      matchHistory: List<String>.from(data['matchHistory'] ?? []),
      eventType: data['eventType'] ?? 'match',
      isLeague: data['isLeague'] ?? false,
      maxParticipants: data['maxParticipants'], // 最大参加人数（オプション）
      status: data['status'] ?? 'open', // 募集状態（英語表記）
    );
  }

  /// Firestore にデータを保存するための形式に変換
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'venue': venue, // 会場名
      if (venueId != null) 'venueId': venueId, // 卓球場ID（オプション）
      if (geoPoint != null) 'geoPoint': geoPoint, // 緯度・経度（オプション）
      'organizerId': organizerId, // 主催者ID
      'participants': participants,
      'matchHistory': matchHistory,
      'eventType': eventType,
      'isLeague': isLeague,
      if (maxParticipants != null) 'maxParticipants': maxParticipants, // 最大参加人数（オプション）
      'status': status, // 募集状態（英語表記）
    };
  }
}
