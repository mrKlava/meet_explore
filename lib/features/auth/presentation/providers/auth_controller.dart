import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_provider.dart';

class AuthController extends StateNotifier<AsyncValue<UserEntity?>> {
  final AuthRepository repository;

  AuthController(this.repository)
      : super(const AsyncData(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final user = await repository.signIn(
        email: email,
        password: password,
      );
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final user = await repository.signUp(
        email: email,
        password: password,
      );
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserEntity?>>(
  (ref) => AuthController(
    ref.read(authRepositoryProvider),
  ),
);
