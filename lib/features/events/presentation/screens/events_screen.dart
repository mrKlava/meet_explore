import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/core/widgets/app_drawer.dart';

import '../providers/events_provider.dart';
import '../widgets/event_card.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Failed to load events')),
        data: (events) {
          if (events.isEmpty) {
            return const Center(
              child: Text('No events available yet.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(eventsProvider);
              await ref.read(eventsProvider.future);
            },
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventCard(event: events[index]);
              },
            ),
          );
        },
      ),
    );
  }
}


