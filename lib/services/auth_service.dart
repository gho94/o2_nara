import 'package:firebase_auth/firebase_auth.dart';
import 'package:o2_nara/models/user_model.dart';
import 'package:o2_nara/repositories/user_repository.dart';

class AuthService {
  final FirebaseAuth auth;
  final UserRepository userRepository;

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

      if (userCredential.user != null) {
        final user = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name ?? email.split('@')[0],
          createdAt: DateTime.now(),
          updatedAt: null,
        );

        await userRepository.createUser(user);
        return user;
      }
      return null;
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

      if (userCredential.user != null) {
        final user = await userRepository.getUser(userCredential.user!.uid);
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
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
