import 'package:firebase_auth/firebase_auth.dart';
import 'package:o2_nara/models/user_model.dart';
import 'package:o2_nara/repositories/user_repository.dart';
import 'package:o2_nara/services/social_auth_service.dart';

class AuthService {
  final FirebaseAuth auth;
  final UserRepository userRepository;
  final _socialAuthService = SocialAuthService();

  AuthService({
    required this.auth,
    required this.userRepository,
  });

  User? get currentUser => auth.currentUser;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name ?? email.split('@')[0],
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await userRepository.createUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      final user = await userRepository.getUser(userCredential.user!.uid);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final userCredential = await auth.signInWithCredential(
        await _socialAuthService.signInWithGoogle(),
      );

      final user = userCredential.user;
      if (user == null) return null;

      final existingUser = await userRepository.getUser(user.uid);
      if (existingUser != null) return existingUser;

      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? user.providerData.first.email!,
        name: user.displayName,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      await userRepository.createUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signInWithFacebook() async {
    try {
      final userCredential = await auth.signInWithCredential(
        await _socialAuthService.signInWithFacebook(),
      );

      final user = userCredential.user;
      if (user == null) return null;

      final existingUser = await userRepository.getUser(user.uid);
      if (existingUser != null) return existingUser;

      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? user.providerData.first.email!,
        name: user.displayName,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await userRepository.createUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signInWithNaver() async {
    try {
      final userCredential = await auth.signInWithCustomToken(
        await _socialAuthService.signInWithNaver(),
      );

      final user = userCredential.user;
      if (user == null) return null;

      final existingUser = await userRepository.getUser(user.uid);
      if (existingUser != null) return existingUser;

      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? user.providerData.first.email!,
        name: user.displayName,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await userRepository.createUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> signInWithKakao() async {
    try {
      final userCredential = await auth.signInWithCredential(
        await _socialAuthService.signInWithKakao(),
      );

      final user = userCredential.user;
      if (user == null) return null;

      final existingUser = await userRepository.getUser(user.uid);
      if (existingUser != null) return existingUser;

      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? user.providerData.first.email!,
        name: user.displayName,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await userRepository.createUser(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _socialAuthService.signOutWithGoogle();
      await _socialAuthService.signOutWithFacebook();
      await _socialAuthService.signOutWithKakao();

      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isEmailRegistered({
    required String email,
  }) async {
    try {
      return await userRepository.isEmailRegistered(email);
    } catch (e) {
      rethrow;
    }
  }
}
