import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../models/event_model.dart';
import '../services/events_remote_service.dart';

class EventRepositoryImpl implements EventRepository {
  final EventsRemoteService remoteService;

  EventRepositoryImpl(this.remoteService);

  Event _toEntity(EventModel model) {
    return Event(
      id: model.id,
      title: model.title,
      imageUrl: model.imageUrl,
      category: model.category,
      host: model.host,
      status: model.status,
      isPublished: model.isPublished,
      places: model.places,
      participantsCount: model.participantsCount,
      price: model.price,
      dateStart: model.dateStart,
      dateEnd: model.dateEnd,
      city: model.city,
      country: model.country,
      address: model.address,
      geoLat: model.geo?.latitude,
      geoLng: model.geo?.longitude,
      locationUrl: model.locationUrl,
      description: model.description,
      info: model.info,
      infoImportant: model.infoImportant,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  @override
  Future<List<Event>> fetchEvents() async {
    final models = await remoteService.fetchEvents();
    return models.map(_toEntity).toList();
  }

  @override
  Future<Event?> fetchEventById(String id) async {
    final model = await remoteService.fetchEventById(id);
    if (model == null) return null;
    return _toEntity(model);
  }

  @override
  Future<bool> isParticipating(String eventId) {
    return remoteService.isParticipating(eventId);
  }

  @override
  Future<void> participate(String eventId) {
    return remoteService.participate(eventId);
  }

  @override
  Future<void> cancelParticipation(String eventId) {
    return remoteService.cancelParticipation(eventId);
  }

  @override
  Future<List<String>> fetchParticipatingEventIds() {
    return remoteService.fetchParticipatingEventIds();
  }

  @override
  Future<List<Event>> fetchParticipatingEvents() async {
    final ids = await fetchParticipatingEventIds();
    if (ids.isEmpty) return [];

    final events = await fetchEvents();
    return events.where((event) => ids.contains(event.id)).toList();
  }
}
