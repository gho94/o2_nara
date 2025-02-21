import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class SocialAuthService {
  final _googleSignIn = GoogleSignIn(signInOption: SignInOption.standard);
  final _facebookAuth = FacebookAuth.instance;
  final _kakaoAuth = UserApi.instance;

  SocialAuthService();

  Future<OAuthCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google 로그인 실패');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<OAuthCredential> signInWithFacebook() async {
    try {
      final loginResult = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );
      if (loginResult.accessToken == null) throw Exception('Facebook 로그인 실패');

      final credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<OAuthCredential> signInWithKakao() async {
    try {
      final token = await _kakaoAuth.loginWithKakaoAccount();
      if (token.idToken == null) throw Exception('카카오 로그인 실패');

      final credential = OAuthProvider('oidc.o2nara').credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      final isGoogleLoggedIn = await _googleSignIn.isSignedIn();
      if (isGoogleLoggedIn) await _googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOutWithFacebook() async {
    try {
      final isFacebookLoggedIn = await _facebookAuth.accessToken != null;
      if (isFacebookLoggedIn) await _facebookAuth.logOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOutWithKakao() async {
    try {
      final isKakaoLoggedIn = await AuthApi.instance.hasToken();
      if (isKakaoLoggedIn) await _kakaoAuth.logout();
    } catch (e) {
      rethrow;
    }
  }
}
