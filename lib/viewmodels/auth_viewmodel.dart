import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// プロバイダ定義
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref); // refを渡して依存関係を管理
});

// AuthState: ViewModelの状態を表現するクラス
class AuthState {
  final UserModel? user; // ユーザー情報
  final bool isCodeSent; // SMSコードが送信されたかどうか
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

// ViewModelクラス: 認証ロジックを管理
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;
  String? _verificationId; // SMS認証で使うID

  // コンストラクタ
  AuthViewModel(StateNotifierProviderRef<AuthViewModel, AuthState> ref)
      : _authService = ref.read(authServiceProvider), // AuthServiceの依存を注入
        super(AuthState.initial()); // 初期状態を設定

  // 電話番号の認証（SMSコード送信）
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      await _authService.verifyPhoneNumber(phoneNumber, (verificationId) {
        _verificationId = verificationId;
        state =
            state.copyWith(isCodeSent: true, errorMessage: null); // SMSコード送信成功
      });
    } catch (e) {
      state = state.copyWith(
          errorMessage: "Failed to send SMS: ${e.toString()}"); // エラー処理
    }
  }

  // SMSコードを使って認証（サインイン/サインアップ兼用）
  Future<void> signUpWithSmsCode(String smsCode) async {
    try {
      if (_verificationId != null) {
        final user =
            await _authService.signInWithSmsCode(_verificationId!, smsCode);
        if (user != null) {
          state = state.copyWith(
            user: UserModel(uid: user.uid, phoneNumber: user.phoneNumber ?? ''),
            errorMessage: null,
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage: "Failed to sign up: ${e.toString()}"); // エラー処理
    }
  }
}

// AuthServiceの依存関係を提供するプロバイダ
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
