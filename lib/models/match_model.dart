import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String matchId;
  final String eventId;
  final String playerOneId;
  final String playerTwoId;
  final String? teamMatchId; // 団体戦の場合の紐付けID
  final String status; // "pending", "confirmed", "completed", "waiting_confirmation"
  final String? winnerId;
  final List<Map<String, int>> scores; // 各ゲームごとのスコア
  final DateTime timestamp;

  MatchModel({
    required this.matchId,
    required this.eventId,
    required this.playerOneId,
    required this.playerTwoId,
    this.teamMatchId,
    required this.status,
    this.winnerId,
    required this.scores,
    required this.timestamp,
  });

  // Firestore からデータを取得してモデルに変換
  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      matchId: data['matchId'] ?? '',
      eventId: data['eventId'] ?? '',
      playerOneId: data['playerOneId'] ?? '',
      playerTwoId: data['playerTwoId'] ?? '',
      teamMatchId: data['teamMatchId'],
      status: data['status'] ?? 'pending',
      winnerId: data['winnerId'],
      scores: (data['scores'] as List<dynamic>?)?.map((e) => Map<String, int>.from(e)).toList() ?? [],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Firestore にデータを保存するための形式に変換
  Map<String, dynamic> toFirestore() {
    return {
      'matchId': matchId,
      'eventId': eventId,
      'playerOneId': playerOneId,
      'playerTwoId': playerTwoId,
      'teamMatchId': teamMatchId,
      'status': status,
      'winnerId': winnerId,
      'scores': scores,
      'timestamp': timestamp,
    };
  }
}
