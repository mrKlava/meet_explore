import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/event.dart';
import '../providers/events_provider.dart';
import '../../../../routes/app_routes.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isUpdatingParticipation = false;

  Future<void> _toggleParticipation(Event event, bool isParticipating) async {
    setState(() {
      _isUpdatingParticipation = true;
    });

    try {
      if (isParticipating) {
        await ref.read(eventRepositoryProvider).cancelParticipation(event.id);
      } else {
        await ref.read(eventRepositoryProvider).participate(event.id);
      }

      ref.invalidate(isParticipatingProvider(widget.eventId));
      ref.invalidate(participatingEventsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isParticipating
                ? 'You cancelled your participation.'
                : 'You are participating in this event.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update participation: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingParticipation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.value != null;

    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));
    final participationAsync = ref.watch(isParticipatingProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (event) {
          if (event == null) {
            return const Center(child: Text('Event not found'));
          }

          final rawIsParticipating = participationAsync.maybeWhen(
            data: (value) => value,
            orElse: () => false,
          );

          final isParticipating = isAuthenticated && rawIsParticipating;
          final participationReady = !isAuthenticated || participationAsync.hasValue;

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
                              Text(
                                DateFormat('MMM dd, yyyy - HH:mm')
                                    .format(event.dateTime),
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
                              Text(
                                event.price > 0
                                    ? event.price.toStringAsFixed(2)
                                    : 'Free',
                              ),
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
              if (participationReady)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: ElevatedButton.icon(
                    onPressed: _isUpdatingParticipation
                        ? null
                        : isAuthenticated
                            ? () => _toggleParticipation(event, isParticipating)
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Sign In Required'),
                                    content: const Text(
                                      'You need to sign in to participate in events.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, AppRoutes.login);
                                        },
                                        child: const Text('Sign In'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                    icon: Icon(
                      isParticipating
                          ? Icons.cancel
                          : Icons.check_circle_outline,
                    ),
                    label: Text(
                      isParticipating
                          ? 'Cancel Participation'
                          : 'Participate',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isParticipating
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






