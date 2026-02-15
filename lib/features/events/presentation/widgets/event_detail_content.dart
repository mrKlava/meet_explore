import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/event.dart';

class EventDetailContent extends StatelessWidget {
  final Event event;

  const EventDetailContent({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppDimens.bottomActionInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            event.imageUrl,
            height: AppDimens.eventDetailImageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.space16),
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
                const SizedBox(height: AppDimens.space8),
                _MetaRow(
                  icon: Icons.person,
                  text: '${AppStrings.hostedByPrefix} ${event.host}',
                ),
                _MetaRow(icon: Icons.category, text: event.category),
                _MetaRow(
                  icon: Icons.calendar_today,
                  text: _buildDateRange(event),
                ),
                _MetaRow(icon: Icons.location_on, text: event.fullLocation),
                _MetaRow(
                  icon: Icons.euro,
                  text: event.price > 0
                      ? event.price.toStringAsFixed(2)
                      : AppStrings.free,
                ),
                _MetaRow(icon: Icons.groups, text: '${event.places} places'),
                _MetaRow(
                  icon: Icons.flag,
                  text: 'Status: ${event.status}',
                ),
                const SizedBox(height: AppDimens.space16),
                if (event.description.isNotEmpty)
                  _TextSection(
                    title: 'Description',
                    items: event.description,
                  ),
                if (event.info.isNotEmpty)
                  _TextSection(
                    title: 'Info',
                    items: event.info,
                  ),
                if (event.infoImportant.isNotEmpty)
                  _TextSection(
                    title: 'Important Info',
                    items: event.infoImportant,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildDateRange(Event event) {
    final start = DateFormat(AppDateFormats.eventDateTime).format(event.dateStart);
    if (event.dateEnd == null) return start;
    final end = DateFormat(AppDateFormats.eventDateTime).format(event.dateEnd!);
    return '$start - $end';
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space6),
      child: Row(
        children: [
          Icon(icon, size: AppDimens.icon18),
          const SizedBox(width: AppDimens.space6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _TextSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.space6),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.space8),
                child: Text(item),
              )),
        ],
      ),
    );
  }
}


