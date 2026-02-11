import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_model.dart';
import '../services/events_service.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final EventsService _eventsService = EventsService();

  late Future<EventModel?> _eventFuture;
  bool _isParticipating = false; // tracks participation
  bool _loadingParticipation = true;

  @override
  void initState() {
    super.initState();
    _eventFuture = _eventsService.fetchEventById(widget.eventId);

    // Check if user participates
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _eventsService.isParticipating(widget.eventId).then((value) {
        setState(() {
          _isParticipating = value;
          _loadingParticipation = false;
        });
      });
    } else {
      _loadingParticipation = false;
    }
  }

  void _toggleParticipation(EventModel event) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Should not happen; button should be disabled
      return;
    }

    setState(() {
      _isParticipating = !_isParticipating;
    });

    try {
      if (_isParticipating) {
        await _eventsService.participate(event.id);
      } else {
        await _eventsService.cancelParticipation(event.id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isParticipating
                ? 'You are participating in this event.'
                : 'You cancelled your participation.',
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isParticipating = !_isParticipating;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update participation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = FirebaseAuth.instance.currentUser != null;

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

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
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
                              Text(DateFormat('MMM dd, yyyy • HH:mm')
                                  .format(event.dateTime)),
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
                              Text(event.price > 0
                                  ? event.price.toStringAsFixed(2)
                                  : 'Free'),
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
              if (!_loadingParticipation)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton.icon(
                    onPressed: isUser
                        ? () => _toggleParticipation(event)
                        : () {
                            // Guest: show dialog
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Sign In Required'),
                                content: const Text(
                                    'You need to sign in to participate in events.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // TODO: navigate to login screen
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Text('Sign In'),
                                  ),
                                ],
                              ),
                            );
                          },
                    icon: Icon(
                        _isParticipating ? Icons.cancel : Icons.check_circle_outline),
                    label: Text(
                        _isParticipating ? 'Cancel Participation' : 'Participate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isParticipating
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
