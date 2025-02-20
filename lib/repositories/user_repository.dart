import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:o2_nara/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository({
    required this.firestore,
  });

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await firestore.collection('users').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final doc = await firestore.collection('users').where('email', isEqualTo: email).get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
