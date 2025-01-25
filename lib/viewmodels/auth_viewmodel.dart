import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// プロバイダ定義: AuthViewModelのインスタンスを提供
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<AppUser>>((ref) {
  return AuthViewModel(ref.read(authServiceProvider));
});

// AuthState: ViewModelの状態を表現するクラス
class AuthState {
  final AppUser? user; // ユーザー情報
  final String? errorMessage; // エラーメッセージ

  AuthState({
    this.user,
    this.errorMessage,
  });

  // 初期状態を返すファクトリメソッド
  factory AuthState.initial() {
    return AuthState(
      user: null,
      errorMessage: null,
    );
  }

  // 状態のコピーを作成するメソッド
  AuthState copyWith({
    AppUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ViewModelクラス: 認証ロジックを管理する
class AuthViewModel extends StateNotifier<AsyncValue<AppUser>> {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthViewModel(this._authService) : super(const AsyncValue.loading()) {
    // Firebaseの認証状態を監視
    _authService.authStateChanges.listen((user) async {
      if (user == null) {
        // サインアウト状態
        state = const AsyncValue.loading();
      } else {
        // Firestoreにユーザー情報を保存または更新
        await _createOrUpdateUserInFirestore(user);

        // サインイン状態
        state = AsyncValue.data(
          AppUser(
            userId: user.uid,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
            profilePicture: user.photoURL ?? '',
            skillLevel: '', // 必要に応じてデフォルト値
            region: '',
            playStyle: '',
            createdAt: DateTime.now(),
            totalWins: 0,
            totalLosses: 0,
            winRate: 0.0,
            recentMatches: [],
            clans: [],
            events: [],
            posts: [],
          ),
        );
      }
    });
  }

  // Firestoreにユーザー情報を保存または更新
  Future<void> _createOrUpdateUserInFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'userId': user.uid,
        'email': user.email ?? '',
        'displayName': user.displayName ?? '',
        'profilePicture': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'totalWins': 0,
        'totalLosses': 0,
        'winRate': 0.0,
        'recentMatches': [],
        'clans': [],
        'events': [],
        'posts': [],
      });
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading(); // 状態をローディング中に設定
    try {
      final user =
          await _authService.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(
        AppUser(
          userId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          profilePicture: user.photoURL ?? '',
          skillLevel: '',
          region: '',
          playStyle: '',
          createdAt: DateTime.now(),
          totalWins: 0,
          totalLosses: 0,
          winRate: 0.0,
          recentMatches: [],
          clans: [],
          events: [],
          posts: [],
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // エラー時の状態を設定
    }
  }

  // メールとパスワードでサインアップ
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading(); // 状態をローディング中に設定
    try {
      final user =
          await _authService.signUpWithEmailAndPassword(email, password);
      await _createOrUpdateUserInFirestore(user);

      state = AsyncValue.data(
        AppUser(
          userId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          profilePicture: user.photoURL ?? '',
          skillLevel: '',
          region: '',
          playStyle: '',
          createdAt: DateTime.now(),
          totalWins: 0,
          totalLosses: 0,
          winRate: 0.0,
          recentMatches: [],
          clans: [],
          events: [],
          posts: [],
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // エラー時の状態を設定
    }
  }

  // ユーザーのサインアウト
  Future<void> signOut() async {
    state = const AsyncValue.loading(); // 状態をローディング中に設定
    try {
      await _authService.signOut();
      state = const AsyncValue.loading(); // 初期状態にリセット
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // エラー時の状態を設定
    }
  }
}

// AuthServiceの依存関係を提供するプロバイダ
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
