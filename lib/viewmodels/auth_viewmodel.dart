import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// プロバイダ定義: AuthViewModelのインスタンスを提供
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref);
});

// AuthState: ViewModelの状態を表現するクラス
class AuthState {
  final UserModel? user; // ユーザー情報
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

// ViewModelクラス: 認証ロジックを管理する
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthViewModel(Ref ref)
      : _authService = ref.read(authServiceProvider),
        super(AuthState.initial()) {
    // Firebaseの認証状態を監視
    _authService.authStateChanges.listen((user) {
      if (user == null) {
        // サインアウト状態
        state = AuthState.initial();
      } else {
        // サインイン状態
        state = state.copyWith(
          user: UserModel(uid: user.uid, email: user.email),
        );
      }
    });
  }

  // メールとパスワードでサインイン
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(errorMessage: null); // エラーメッセージをリセット
    try {
      final user =
          await _authService.signInWithEmailAndPassword(email, password);
      state = state.copyWith(
        user: UserModel(uid: user.uid, email: user.email ?? ''),
        errorMessage: null,
      );
    } catch (e) {
      state =
          state.copyWith(errorMessage: "Failed to sign in: ${e.toString()}");
    }
  }

  // メールとパスワードでサインアップ
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(errorMessage: null); // エラーメッセージをリセット
    try {
      final user =
          await _authService.signUpWithEmailAndPassword(email, password);
      state = state.copyWith(
        user: UserModel(uid: user.uid, email: user.email ?? ''),
        errorMessage: null,
      );
    } catch (e) {
      state =
          state.copyWith(errorMessage: "Failed to sign up: ${e.toString()}");
    }
  }

  // ユーザーのサインアウト
  Future<void> signOut() async {
    state = state.copyWith(errorMessage: null); // エラーメッセージをリセット
    try {
      await _authService.signOut();
      state = AuthState.initial(); // 初期状態にリセット
    } catch (e) {
      state =
          state.copyWith(errorMessage: "Failed to sign out: ${e.toString()}");
    }
  }
}

// AuthServiceの依存関係を提供するプロバイダ
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
