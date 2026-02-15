import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

import '../../data/repositories/event_repository_impl.dart';
import '../../data/services/events_remote_service.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

final eventsRemoteServiceProvider = Provider<EventsRemoteService>((ref) {
  return EventsRemoteService();
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(ref.read(eventsRemoteServiceProvider));
});

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  return ref.read(eventRepositoryProvider).fetchEvents();
});

final participatingEventsProvider = FutureProvider<List<Event>>((ref) async {
  return ref.read(eventRepositoryProvider).fetchParticipatingEvents();
});

final eventByIdProvider = FutureProvider.family<Event?, String>((ref, eventId) async {
  return ref.read(eventRepositoryProvider).fetchEventById(eventId);
});

final isParticipatingProvider = FutureProvider.family<bool, String>((ref, eventId) async {
  ref.watch(authStateProvider);
  return ref.read(eventRepositoryProvider).isParticipating(eventId);
});


