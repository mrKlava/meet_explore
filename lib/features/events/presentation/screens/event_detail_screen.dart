import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/event.dart';
import '../providers/events_provider.dart';
import '../widgets/event_detail_content.dart';
import '../widgets/event_participation_button.dart';

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
      ref.invalidate(eventByIdProvider(widget.eventId));
      ref.invalidate(eventsProvider);
      ref.invalidate(participatingEventsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isParticipating
                ? AppStrings.participationCancelled
                : AppStrings.participationSuccess,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.participationFailedPrefix}: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingParticipation = false;
        });
      }
    }
  }

  void _showSignInDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.signInRequired),
        content: const Text(AppStrings.signInRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.login);
            },
            child: const Text(AppStrings.drawerSignIn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.value != null;

    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));
    final participationAsync = ref.watch(isParticipatingProvider(widget.eventId));

    return AppScaffold(
      title: AppStrings.eventDetailsTitle,
      showDrawer: false,
      body: eventAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) =>
            AppErrorView(error: error, prefix: AppStrings.errorPrefix),
        data: (event) {
          if (event == null) {
            return const AppEmptyView(message: AppStrings.eventNotFound);
          }

          final rawIsParticipating = participationAsync.maybeWhen(
            data: (value) => value,
            orElse: () => false,
          );
          final isParticipating = isAuthenticated && rawIsParticipating;
          final isFull =
              event.hasLimitedPlaces && event.availablePlaces == 0 && !isParticipating;
          final participationReady =
              !isAuthenticated || participationAsync.hasValue;

          return Stack(
            children: [
              EventDetailContent(event: event),
              if (participationReady)
                Positioned(
                  left: AppDimens.space16,
                  right: AppDimens.space16,
                  bottom: AppDimens.space16,
                  child: EventParticipationButton(
                    isLoading: _isUpdatingParticipation,
                    isParticipating: isParticipating,
                    isAuthenticated: isAuthenticated,
                    isFull: isFull,
                    onAuthenticatedTap: () =>
                        _toggleParticipation(event, isParticipating),
                    onGuestTap: _showSignInDialog,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
