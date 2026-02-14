import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService authService;

  AuthRepositoryImpl(this.authService);

  UserEntity? _mapUser(User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return authService.authStateChanges().map(_mapUser);
  }

  @override
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    final user = await authService.signIn(email, password);
    return _mapUser(user);
  }

  @override
  Future<UserEntity?> signUp({
    required String email,
    required String password,
  }) async {
    final user = await authService.signUp(email, password);
    return _mapUser(user);
  }

  @override
  Future<void> signOut() {
    return authService.signOut();
  }
}
