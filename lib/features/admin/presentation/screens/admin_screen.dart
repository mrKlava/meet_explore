import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/presentation/providers/events_provider.dart';
import 'admin_event_form_screen.dart';
import '../providers/admin_provider.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _AdminFilter _selectedFilter = _AdminFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const List<String> _eventStatuses = [
    'scheduled',
    'cancelled',
    'postponed',
  ];

  Future<void> _updatePublishStatus(
    BuildContext context,
    WidgetRef ref,
    Event event,
    bool isPublished,
  ) async {
    try {
      await ref.read(eventRepositoryProvider).updateEventPublishStatus(
            eventId: event.id,
            isPublished: isPublished,
          );
      ref.invalidate(adminEventsProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.errorPrefix}: $e')),
      );
    }
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    Event event,
    String status,
  ) async {
    if (status == event.status) return;

    try {
      await ref.read(eventRepositoryProvider).updateEventStatus(
            eventId: event.id,
            status: status,
          );
      ref.invalidate(adminEventsProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.errorPrefix}: $e')),
      );
    }
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'cancelled':
        return Colors.red.shade700;
      case 'postponed':
        return Colors.orange.shade700;
      default:
        return Colors.green.shade700;
    }
  }

  Future<void> _openEventForm(
    BuildContext context, {
    required WidgetRef ref,
    Event? event,
  }) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminEventFormScreen(initialEvent: event),
      ),
    );
    if (changed == true) {
      ref.invalidate(adminEventsProvider);
    }
  }

  Future<void> _deleteEvent(
    BuildContext context,
    WidgetRef ref,
    Event event,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete event'),
          content: Text('Delete "${event.title}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref.read(eventRepositoryProvider).deleteEvent(event.id);
      ref.invalidate(adminEventsProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.errorPrefix}: $e')),
      );
    }
  }

  List<Event> _applyFilters(List<Event> events) {
    var filtered = events;

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      filtered = filtered.where((event) {
        return event.title.toLowerCase().contains(query) ||
            event.city.toLowerCase().contains(query) ||
            event.country.toLowerCase().contains(query) ||
            event.category.toLowerCase().contains(query);
      }).toList();
    }

    switch (_selectedFilter) {
      case _AdminFilter.all:
        return filtered;
      case _AdminFilter.published:
        return filtered.where((e) => e.isPublished).toList();
      case _AdminFilter.draft:
        return filtered.where((e) => !e.isPublished).toList();
      case _AdminFilter.scheduled:
        return filtered.where((e) => e.status == 'scheduled').toList();
      case _AdminFilter.cancelled:
        return filtered.where((e) => e.status == 'cancelled').toList();
      case _AdminFilter.postponed:
        return filtered.where((e) => e.status == 'postponed').toList();
    }
  }

  String _filterLabel(_AdminFilter filter) {
    switch (filter) {
      case _AdminFilter.all:
        return 'All';
      case _AdminFilter.published:
        return 'Published';
      case _AdminFilter.draft:
        return 'Draft';
      case _AdminFilter.scheduled:
        return 'Scheduled';
      case _AdminFilter.cancelled:
        return 'Cancelled';
      case _AdminFilter.postponed:
        return 'Postponed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);
    final eventsAsync = ref.watch(adminEventsProvider);

    return AppScaffold(
      title: AppStrings.adminTitle,
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _openEventForm(context, ref: ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
            )
          : null,
      body: !isAdmin
          ? const Center(child: Text(AppStrings.adminNoAccess))
          : eventsAsync.when(
              loading: () => const AppLoadingView(),
              error: (error, _) =>
                  AppErrorView(error: error, prefix: AppStrings.errorPrefix),
              data: (events) {
                if (events.isEmpty) {
                  return const AppEmptyView(message: 'No events found.');
                }

                final filteredEvents = _applyFilters(events);
                final totalCount = events.length;
                final publishedCount = events.where((e) => e.isPublished).length;
                final draftCount = events.length - publishedCount;
                final cancelledCount =
                    events.where((e) => e.status == 'cancelled').length;

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(adminEventsProvider);
                    await ref.read(adminEventsProvider.future);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimens.space16),
                    itemCount: filteredEvents.length + 3,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppDimens.space12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final cardWidth =
                                (constraints.maxWidth - AppDimens.space12) / 2;
                            return Wrap(
                              spacing: AppDimens.space12,
                              runSpacing: AppDimens.space12,
                              children: [
                                SizedBox(
                                  width: cardWidth,
                                  child: _SummaryCard(
                                    label: 'Total',
                                    value: totalCount.toString(),
                                    color: Colors.blueGrey.shade700,
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: _SummaryCard(
                                    label: 'Published',
                                    value: publishedCount.toString(),
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: _SummaryCard(
                                    label: 'Drafts',
                                    value: draftCount.toString(),
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: _SummaryCard(
                                    label: 'Cancelled',
                                    value: cancelledCount.toString(),
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      if (index == 1) {
                        return _AdminToolbar(
                          searchController: _searchController,
                          onSearchChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          selectedFilter: _selectedFilter,
                          filterLabelBuilder: _filterLabel,
                          onFilterSelected: (filter) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        );
                      }

                      if (index == 2) {
                        if (filteredEvents.isEmpty) {
                          return const AppEmptyView(
                            message:
                                'No events match current search/filter criteria.',
                          );
                        }
                        return Text(
                          '${filteredEvents.length} result(s)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }

                      final event = filteredEvents[index - 3];
                      final startDate = DateFormat(AppDateFormats.eventDateTime)
                          .format(event.dateStart);
                      final publishLabel =
                          event.isPublished ? 'Published' : 'Draft';
                      final placesLabel = event.hasLimitedPlaces
                          ? '${event.availablePlaces}/${event.places} places available'
                          : 'Unlimited places';

                      return Card(
                        elevation: AppDimens.elevation3,
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimens.space12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radius12,
                                    ),
                                    child: Image.network(
                                      event.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.black12,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.space12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: AppDimens.space6),
                                        Text(startDate),
                                        const SizedBox(height: AppDimens.space4),
                                        Text('${event.city}, ${event.country}'),
                                        const SizedBox(height: AppDimens.space4),
                                        Text(placesLabel),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.space12),
                              Wrap(
                                spacing: AppDimens.space8,
                                runSpacing: AppDimens.space8,
                                children: [
                                  Chip(
                                    avatar: Icon(
                                      Icons.flag,
                                      color: _statusColor(context, event.status),
                                      size: AppDimens.icon16,
                                    ),
                                    label: Text(event.status),
                                  ),
                                  Chip(
                                    avatar: Icon(
                                      event.isPublished
                                          ? Icons.public
                                          : Icons.edit_note,
                                      size: AppDimens.icon16,
                                      color: event.isPublished
                                          ? Colors.green.shade700
                                          : Colors.orange.shade700,
                                    ),
                                    backgroundColor: event.isPublished
                                        ? Colors.green.shade50
                                        : Colors.orange.shade50,
                                    side: BorderSide(
                                      color: event.isPublished
                                          ? Colors.green.shade200
                                          : Colors.orange.shade200,
                                    ),
                                    label: Text(
                                      publishLabel,
                                      style: TextStyle(
                                        color: event.isPublished
                                            ? Colors.green.shade800
                                            : Colors.orange.shade800,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.space8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _openEventForm(
                                        context,
                                        ref: ref,
                                        event: event,
                                      ),
                                      icon: const Icon(Icons.edit_outlined),
                                      label: const Text('Edit'),
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.space8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _deleteEvent(context, ref, event),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red.shade700,
                                      ),
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.space8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text('Publish'),
                                        const SizedBox(width: AppDimens.space8),
                                        Switch(
                                          value: event.isPublished,
                                          onChanged: (value) =>
                                              _updatePublishStatus(
                                            context,
                                            ref,
                                            event,
                                            value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: DropdownButtonFormField<String>(
                                      initialValue: event.status,
                                      decoration: const InputDecoration(
                                        labelText: 'Status',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      items: _eventStatuses
                                          .map(
                                            (status) =>
                                                DropdownMenuItem<String>(
                                              value: status,
                                              child: Text(status),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value == null) return;
                                        _updateStatus(
                                          context,
                                          ref,
                                          event,
                                          value,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimens.space4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

enum _AdminFilter {
  all,
  published,
  draft,
  scheduled,
  cancelled,
  postponed,
}

class _AdminToolbar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final _AdminFilter selectedFilter;
  final ValueChanged<_AdminFilter> onFilterSelected;
  final String Function(_AdminFilter) filterLabelBuilder;

  const _AdminToolbar({
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.filterLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDimens.elevation3,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by title, city, country, or category',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: AppDimens.space12),
            Wrap(
              spacing: AppDimens.space8,
              runSpacing: AppDimens.space8,
              children: _AdminFilter.values.map((filter) {
                return ChoiceChip(
                  label: Text(filterLabelBuilder(filter)),
                  selected: selectedFilter == filter,
                  onSelected: (_) => onFilterSelected(filter),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
