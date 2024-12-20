import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {}

  Future<void> signInWithRedirect() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    } catch (e) {
      throw Exception('サインインに失敗しました: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception('サインアウトに失敗しました: $e');
    }
  }

  Future<UserCredential?> getRedirectResult() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.getRedirectResult();
      return userCredential;
    } catch (e) {
      throw Exception('リダイレクトからのユーザー認証情報の取得に失敗しました: $e');
    }
  }
}
