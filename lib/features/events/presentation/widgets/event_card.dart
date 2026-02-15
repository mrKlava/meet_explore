import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/event.dart';
import '../screens/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(AppDateFormats.eventDateTime)
        .format(event.dateStart);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(eventId: event.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space8,
        ),
        clipBehavior: Clip.antiAlias,
        elevation: AppDimens.elevation3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.imageUrl,
              height: AppDimens.eventCardImageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimens.space6),
                  Text(
                    event.descriptionText,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.space10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: AppDimens.icon16),
                      const SizedBox(width: AppDimens.space6),
                      Text(formattedDate),
                    ],
                  ),
                  const SizedBox(height: AppDimens.space6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: AppDimens.icon16),
                      const SizedBox(width: AppDimens.space6),
                      Expanded(child: Text(event.shortLocation)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
