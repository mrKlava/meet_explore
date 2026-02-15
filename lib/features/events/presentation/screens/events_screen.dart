import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../providers/events_provider.dart';
import '../widgets/event_card.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return AppScaffold(
      title: AppStrings.eventsTitle,
      body: eventsAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) =>
            const AppEmptyView(message: AppStrings.eventsLoadFailed),
        data: (events) {
          if (events.isEmpty) {
            return const AppEmptyView(message: AppStrings.eventsEmpty);
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
