import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents();
  Future<List<Event>> fetchAllEventsForAdmin();

  Future<Event?> fetchEventById(String id);

  Future<bool> isParticipating(String eventId);

  Future<void> participate(String eventId);

  Future<void> cancelParticipation(String eventId);

  Future<List<String>> fetchParticipatingEventIds();

  Future<List<Event>> fetchParticipatingEvents();

  Future<void> updateEventPublishStatus({
    required String eventId,
    required bool isPublished,
  });

  Future<void> updateEventStatus({
    required String eventId,
    required String status,
  });

  Future<void> createEvent(Event event);

  Future<void> updateEvent(Event event);

  Future<void> deleteEvent(String eventId);
}
