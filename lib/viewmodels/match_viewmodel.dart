import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../models/match_model.dart';

final matchViewModelProvider =
    StateNotifierProvider<MatchViewModel, AsyncValue<List<MatchModel>>>((ref) {
  return MatchViewModel();
});

class MatchViewModel extends StateNotifier<AsyncValue<List<MatchModel>>> {
  MatchViewModel() : super(const AsyncValue.loading()) {
    fetchMatches();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 試合一覧を取得
  Future<void> fetchMatches() async {
    try {
      final querySnapshot = await _firestore.collection('Matches').get();
      final matches = querySnapshot.docs
          .map((doc) => MatchModel.fromFirestore(doc))
          .toList();
      state = AsyncValue.data(matches);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 試合申し込み（pending状態でFirestoreに保存）
  Future<void> requestMatch(
      String eventId, String playerOneId, String playerTwoId,
      {String? teamMatchId}) async {
    try {
      final matchRef = _firestore.collection('Matches').doc();
      final match = MatchModel(
        matchId: matchRef.id,
        eventId: eventId,
        playerOneId: playerOneId,
        playerTwoId: playerTwoId,
        teamMatchId: teamMatchId, // 団体戦の場合は紐づける
        status: 'pending',
        winnerId: null,
        scores: [], // 各ゲームのスコアをリストで管理
        timestamp: DateTime.now(),
      );
      await matchRef.set(match.toFirestore());
      fetchMatches();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 試合承認
  Future<void> confirmMatch(String matchId) async {
    try {
      await _firestore
          .collection('Matches')
          .doc(matchId)
          .update({'status': 'confirmed'});
      fetchMatches();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 試合拒否（削除）
  Future<void> rejectMatch(String matchId) async {
    try {
      await _firestore.collection('Matches').doc(matchId).delete();
      fetchMatches();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 試合結果を報告（PlayerOneが入力し、PlayerTwoが確認）
  Future<void> reportMatchResult(String matchId, String playerOneId,
      String winnerId, List<Map<String, int>> scores) async {
    try {
      await _firestore.collection('Matches').doc(matchId).update({
        'winnerId': winnerId,
        'scores': scores, // 各ゲームごとのスコア
        'status': 'waiting_confirmation',
        'confirmationDeadline':
            DateTime.now().add(Duration(hours: 24)) // 24時間後に自動承認
      });
      fetchMatches();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// PlayerTwoが試合結果を確認して確定
  Future<void> confirmMatchResult(String matchId) async {
    try {
      await _firestore
          .collection('Matches')
          .doc(matchId)
          .update({'status': 'completed'});
      fetchMatches();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 自動承認処理（一定時間経過後に未承認なら自動で承認）
  Future<void> autoConfirmMatchResults() async {
    try {
      final querySnapshot = await _firestore
          .collection('Matches')
          .where('status', isEqualTo: 'waiting_confirmation')
          .where('confirmationDeadline', isLessThan: DateTime.now())
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': 'completed'});
      }
      fetchMatches();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
