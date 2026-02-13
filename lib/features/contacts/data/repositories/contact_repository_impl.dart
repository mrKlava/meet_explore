import '../../domain/entities/contact_message.dart';
import '../../domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  @override
  Future<void> sendMessage(ContactMessage message) async {
    await Future.delayed(const Duration(seconds: 2));

    // Later:
    // - Send to Firebase
    // - Send to email API
    // - Store in Firestore
  }
}
