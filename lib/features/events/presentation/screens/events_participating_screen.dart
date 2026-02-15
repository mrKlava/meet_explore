import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/core/widgets/app_drawer.dart';
import 'package:meet_explore/core/widgets/app_state_views.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/events_provider.dart';
import '../widgets/participating_event_card.dart';
import 'event_detail_screen.dart';

class EventsParticipatingScreen extends ConsumerWidget {
  const EventsParticipatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(participatingEventsProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(AppStrings.participatingTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: eventsAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(error: error, prefix: AppStrings.errorPrefix),
        data: (events) {
          if (events.isEmpty) {
            return const AppEmptyView(message: AppStrings.participatingEmpty);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(participatingEventsProvider);
              await ref.read(participatingEventsProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimens.space16),
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimens.space12),
              itemBuilder: (context, index) {
                final event = events[index];
                return ParticipatingEventCard(
                  event: event,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(eventId: event.id),
                      ),
                    );
                    ref.invalidate(participatingEventsProvider);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
