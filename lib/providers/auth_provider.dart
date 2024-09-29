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
  final bool isCodeSent; // SMSコードが送信されたかどうかを示す
  final String? errorMessage; // エラーメッセージ

  AuthState({
    this.user,
    this.isCodeSent = false,
    this.errorMessage,
  });

  // 初期状態を返すファクトリメソッド
  factory AuthState.initial() {
    return AuthState(
      user: null,
      isCodeSent: false,
      errorMessage: null,
    );
  }

  // 状態のコピーを作成するメソッド
  AuthState copyWith({
    UserModel? user,
    bool? isCodeSent,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// 認証ロジックを管理するクラス
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  String? _verificationId;

  // コンストラクタで依存関係を注入
  AuthNotifier(StateNotifierProviderRef<AuthNotifier, AuthState> ref)
      : _authService = ref.read(authServiceProvider),
        super(AuthState.initial());

  // 電話番号の認証（SMSコード送信）
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    state = state.copyWith(errorMessage: null); // エラーリセット
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber,
        (verificationId) {
          _verificationId = verificationId;
          state = state.copyWith(
            isCodeSent: true,
            errorMessage: null,
          );
        },
        (error) {
          state = state.copyWith(errorMessage: error);
        },
        () {
          // 自動認証成功時の処理
          state = state.copyWith(
            isCodeSent: false,
            errorMessage: "Automatic verification succeeded!",
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: "Failed to send SMS: ${e.toString()}",
      );
    }
  }

  // SMSコードを使用して認証（サインイン/サインアップ）
  Future<void> signInWithSmsCode(String smsCode) async {
    state = state.copyWith(errorMessage: null); // エラーリセット
    try {
      if (_verificationId != null) {
        final user = await _authService.signInWithSmsCode(_verificationId!, smsCode);
        if (user != null) {
          state = state.copyWith(
            user: UserModel(uid: user.uid, phoneNumber: user.phoneNumber ?? ''),
            errorMessage: null,
          );
        }
      } else {
        throw Exception("Verification ID is null");
      }
    } catch (e) {
      state = state.copyWith(errorMessage: "Failed to sign in: ${e.toString()}");
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
