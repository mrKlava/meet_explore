import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/events_service.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final EventsService _eventsService = EventsService();
  late Future<EventModel?> _eventFuture;

  @override
  void initState() {
    super.initState();
    _eventFuture = _eventsService.fetchEventById(widget.eventId);
  }

  void _toggleParticipation(EventModel event) {
    setState(() {
      event.isParticipating = !event.isParticipating;
    });

    // Optional: show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isParticipating
              ? 'You are participating in this event.'
              : 'You cancelled your participation.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: FutureBuilder<EventModel?>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Event not found'));
          }

          final event = snapshot.data!;

          // Only body part updated; rest stays the same
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // leave space for button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      event.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18),
                              const SizedBox(width: 6),
                              Text('Hosted by ${event.host}'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.category, size: 18),
                              const SizedBox(width: 6),
                              Text(event.category),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy • HH:mm',
                                ).format(event.dateTime),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 18),
                              const SizedBox(width: 6),
                              Text(event.location),
                            ],
                          ),
                          const SizedBox(height: 6),
                          
                            Row(
                              children: [
                                const Icon(Icons.euro, size: 18),
                                const SizedBox(width: 6),
                                Text(event.price > 0 ?event.price.toStringAsFixed(2) : 'Free'),
                              ],
                            ),
                          const SizedBox(height: 16),
                          Text(
                            event.detailedDescription,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Sticky bottom button
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: ElevatedButton.icon(
                  onPressed: () => _toggleParticipation(event),
                  icon: Icon(
                    event.isParticipating
                        ? Icons.cancel
                        : Icons.check_circle_outline,
                  ),
                  label: Text(
                    event.isParticipating
                        ? 'Cancel Participation'
                        : 'Participate',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: event.isParticipating
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
