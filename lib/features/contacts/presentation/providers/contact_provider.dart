import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../domain/entities/contact_message.dart';
import '../../domain/repositories/contact_repository.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepositoryImpl();
});

class ContactController extends StateNotifier<AsyncValue<void>> {
  final ContactRepository repository;

  ContactController(this.repository) : super(const AsyncData(null));

  Future<void> send(ContactMessage message) async {
    state = const AsyncLoading();

    try {
      await repository.sendMessage(message);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final contactControllerProvider =
    StateNotifierProvider<ContactController, AsyncValue<void>>((ref) {
  final repo = ref.read(contactRepositoryProvider);
  return ContactController(repo);
});
