import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingpong_mix/providers/auth_provider.dart';
import '../services/auth_service.dart';

// プロバイダ定義: AuthViewModelのインスタンスを提供
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<User?>>((ref) {
  return AuthViewModel(ref.read(authServiceProvider));
});

// ViewModelクラス: 認証ロジックを管理する
class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user =
          await _authService.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user =
          await _authService.signUpWithEmailAndPassword(email, password);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
