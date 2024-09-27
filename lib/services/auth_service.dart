import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 電話番号の認証（SMSコード送信）
  Future<void> verifyPhoneNumber(String phoneNumber,
      void Function(String verificationId) codeSentCallback) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // 自動認証が完了した場合にすぐにサインイン
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception("Phone number verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        // SMSコードが送信された場合
        codeSentCallback(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // タイムアウトになった場合
        codeSentCallback(verificationId);
      },
    );
  }

  // SMSコードを使ってサインイン
  Future<User?> signInWithSmsCode(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception("Sign in with SMS code failed: $e");
    }
  }

  // サインアウト
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Sign out failed: ${e.toString()}");
    }
  }

  // Firebaseの認証状態の監視
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
