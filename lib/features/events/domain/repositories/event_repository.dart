import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents();

  Future<Event?> fetchEventById(String id);

  Future<bool> isParticipating(String eventId);

  Future<void> participate(String eventId);

  Future<void> cancelParticipation(String eventId);

  Future<List<String>> fetchParticipatingEventIds();

  Future<List<Event>> fetchParticipatingEvents();
}
