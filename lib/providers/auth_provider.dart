import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// 認証プロバイダ
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

// 認証状態を表現するクラス
class AuthState {
  final UserModel? user;
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
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// 認証ロジックを管理するクラス
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  // コンストラクタで依存関係を注入
  AuthNotifier(StateNotifierProviderRef<AuthNotifier, AuthState> ref)
      : _authService = ref.read(authServiceProvider),
        super(AuthState.initial());

  // メールアドレスとパスワードでサインイン
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(errorMessage: null); // エラーリセット
    try {
      final user = await _authService.signInWithEmailAndPassword(email, password);
      state = state.copyWith(
        user: UserModel(uid: user.uid, email: user.email),
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to sign in: ${e.toString()}");
    }
  }

  // メールアドレスとパスワードでサインアップ
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(errorMessage: null); // エラーリセット
    try {
      final user = await _authService.signUpWithEmailAndPassword(email, password);
      state = state.copyWith(
        user: UserModel(uid: user.uid, email: user.email),
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to sign up: ${e.toString()}");
    }
  }

  // ユーザーのサインアウト
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = AuthState.initial(); // 初期状態にリセット
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Failed to sign out: ${e.toString()}",
      );
    }
  }
}

// AuthServiceの依存関係を提供するプロバイダ
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
