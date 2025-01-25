// User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String userId;
  final String email;
  final String displayName;
  final String profilePicture;
  final String skillLevel;
  final String region;
  final String playStyle;
  final DateTime createdAt;
  final int totalWins;
  final int totalLosses;
  final double winRate;
  final List<String> recentMatches;
  final List<String> clans;
  final List<String> events;
  final List<String> posts;

  AppUser({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.profilePicture,
    required this.skillLevel,
    required this.region,
    required this.playStyle,
    required this.createdAt,
    required this.totalWins,
    required this.totalLosses,
    required this.winRate,
    required this.recentMatches,
    required this.clans,
    required this.events,
    required this.posts,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      userId: data['userId'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      skillLevel: data['skillLevel'] ?? '',
      region: data['region'] ?? '',
      playStyle: data['playStyle'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      totalWins: data['totalWins'] ?? 0,
      totalLosses: data['totalLosses'] ?? 0,
      winRate: (data['winRate'] ?? 0).toDouble(),
      recentMatches: List<String>.from(data['recentMatches'] ?? []),
      clans: List<String>.from(data['clans'] ?? []),
      events: List<String>.from(data['events'] ?? []),
      posts: List<String>.from(data['posts'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'profilePicture': profilePicture,
      'skillLevel': skillLevel,
      'region': region,
      'playStyle': playStyle,
      'createdAt': createdAt,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'winRate': winRate,
      'recentMatches': recentMatches,
      'clans': clans,
      'events': events,
      'posts': posts,
    };
  }
}
