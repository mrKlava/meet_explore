import '../entities/contact_message.dart';

abstract class ContactRepository {
  Future<void> sendMessage(ContactMessage message);
}
