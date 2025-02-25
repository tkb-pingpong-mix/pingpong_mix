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
  final int? followers;
  final int? following;
  final List<String>? followersList;
  final List<String>? followingList;
  final String? racket;
  final String? forehandRubber;
  final String? backhandRubber;
  final String? shoes;

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
    this.followers,
    this.following,
    this.followersList,
    this.followingList,
    this.racket,
    this.forehandRubber,
    this.backhandRubber,
    this.shoes,
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
      followers: data['followers'],
      following: data['following'],
      followersList: data['followersList'] != null ? List<String>.from(data['followersList']) : null,
      followingList: data['followingList'] != null ? List<String>.from(data['followingList']) : null,
      racket: data['racket'],
      forehandRubber: data['forehandRubber'],
      backhandRubber: data['backhandRubber'],
      shoes: data['shoes'],
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
      if (followers != null) 'followers': followers,
      if (following != null) 'following': following,
      if (followersList != null) 'followersList': followersList,
      if (followingList != null) 'followingList': followingList,
      if (racket != null) 'racket': racket,
      if (forehandRubber != null) 'forehandRubber': forehandRubber,
      if (backhandRubber != null) 'backhandRubber': backhandRubber,
      if (shoes != null) 'shoes': shoes,
    };
  }

  AppUser copyWith({
    String? displayName,
    String? profilePicture,
    String? skillLevel,
    String? region,
    String? playStyle,
    int? totalWins,
    int? totalLosses,
    double? winRate,
    List<String>? recentMatches,
    List<String>? clans,
    List<String>? events,
    List<String>? posts,
    int? followers,
    int? following,
    List<String>? followersList,
    List<String>? followingList,
    String? racket,
    String? forehandRubber,
    String? backhandRubber,
    String? shoes,
  }) {
    return AppUser(
      userId: userId,
      email: email,
      displayName: displayName ?? this.displayName,
      profilePicture: profilePicture ?? this.profilePicture,
      skillLevel: skillLevel ?? this.skillLevel,
      region: region ?? this.region,
      playStyle: playStyle ?? this.playStyle,
      createdAt: createdAt,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      winRate: winRate ?? this.winRate,
      recentMatches: recentMatches ?? this.recentMatches,
      clans: clans ?? this.clans,
      events: events ?? this.events,
      posts: posts ?? this.posts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
      racket: racket ?? this.racket,
      forehandRubber: forehandRubber ?? this.forehandRubber,
      backhandRubber: backhandRubber ?? this.backhandRubber,
      shoes: shoes ?? this.shoes,
    );
  }
}
