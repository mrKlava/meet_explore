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
                  text: DateFormat(AppDateFormats.eventDateTime)
                      .format(event.dateTime),
                ),
                _MetaRow(icon: Icons.location_on, text: event.location),
                _MetaRow(
                  icon: Icons.euro,
                  text: event.price > 0
                      ? event.price.toStringAsFixed(2)
                      : AppStrings.free,
                ),
                const SizedBox(height: AppDimens.space16),
                Text(
                  event.detailedDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
