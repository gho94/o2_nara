import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2_nara/models/user_model.dart';
import 'package:o2_nara/repositories/user_repository.dart';
import 'package:o2_nara/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
  (ref) => AuthNotifier(
    AuthService(
      auth: FirebaseAuth.instance,
      userRepository: UserRepository(
        firestore: FirebaseFirestore.instance,
      ),
    ),
  ),
);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(const AsyncValue.loading());

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await authService.signUp(
        email: email,
        password: password,
        name: name,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await authService.signIn(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await authService.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> isEmailRegistered({
    required String email,
  }) async {
    try {
      return await authService.isEmailRegistered(email: email);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
