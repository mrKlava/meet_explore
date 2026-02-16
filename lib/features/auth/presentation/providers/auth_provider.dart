import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService(ref.read(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(firebaseAuthServiceProvider),
  );
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.read(authRepositoryProvider).authStateChanges();
});

final currentUserRoleProvider = StreamProvider<String?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);

  return ref
      .watch(firestoreProvider)
      .collection('users')
      .doc(user.id)
      .snapshots()
      .map((doc) {
    final data = doc.data();
    final role = data?['role'];
    if (role is String) return role.toLowerCase().trim();
    return null;
  });
});

final isAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(currentUserRoleProvider).value;
  return role == 'admin';
});
