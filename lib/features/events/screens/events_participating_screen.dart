import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/events_service.dart';
import 'event_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:meet_explore/core/widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsParticipatingScreen extends StatefulWidget {
  const EventsParticipatingScreen({super.key});

  @override
  State<EventsParticipatingScreen> createState() =>
      _EventsParticipatingScreenState();
}

class _EventsParticipatingScreenState extends State<EventsParticipatingScreen> {
  final EventsService _eventsService = EventsService();
  late Future<List<EventModel>> _participatingEventsFuture;

  @override
  void initState() {
    super.initState();
    _loadParticipatingEvents();
  }

  void _loadParticipatingEvents() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Guest: empty list
      _participatingEventsFuture = Future.value([]);
      return;
    }

    _participatingEventsFuture = _fetchParticipatingEventsForUser(user.uid);
  }

  Future<List<EventModel>> _fetchParticipatingEventsForUser(String uid) async {
    final ids = await _eventsService.fetchParticipatingEventIds();
    final allEvents = await _eventsService.fetchEvents();
    // Filter only events user participates in
    return allEvents.where((event) => ids.contains(event.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('My Participating Events'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _participatingEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text('You are not participating in any events yet.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () async {
                  // Open event details
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(eventId: event.id),
                    ),
                  );
                  // Refresh after returning in case participation changed
                  setState(() => _loadParticipatingEvents());
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          event.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event.detailedDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat(
                                    'MMM dd, HH:mm',
                                  ).format(event.dateTime),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event.location,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
