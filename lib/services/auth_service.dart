import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 電話番号の認証（SMSコード送信）
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    void Function(String verificationId) codeSentCallback,
    void Function(String error) errorCallback, // エラー用のコールバック
    void Function() autoVerifiedCallback, // 自動認証時のコールバック
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // 自動認証が完了した場合にすぐにサインイン
          await _auth.signInWithCredential(credential);
          autoVerifiedCallback(); // 自動認証時のアクションを実行
        },
        verificationFailed: (FirebaseAuthException e) {
          errorCallback("Phone number verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // SMSコードが送信された場合
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // 自動取得のタイムアウト
        },
      );
    } catch (e) {
      errorCallback("Failed to send SMS: ${e.toString()}");
    }
  }

  // SMSコードを使ってサインイン
  Future<User?> signInWithSmsCode(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw FirebaseAuthException(
        code: "sign_in_failed",
        message: "Sign in with SMS code failed: ${e.toString()}",
      );
    }
  }

  // サインアウト
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw FirebaseAuthException(
        code: "sign_out_failed",
        message: "Sign out failed: ${e.toString()}",
      );
    }
  }

  // Firebaseの認証状態の監視
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
