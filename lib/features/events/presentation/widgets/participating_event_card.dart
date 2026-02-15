import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/event.dart';

class ParticipatingEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const ParticipatingEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
        ),
        elevation: AppDimens.elevation4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimens.radius12),
              ),
              child: Image.network(
                event.imageUrl,
                height: AppDimens.participatingEventImageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDimens.space6),
                  Text(
                    event.detailedDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.space6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: AppDimens.icon16),
                      const SizedBox(width: AppDimens.space4),
                      Text(
                        DateFormat(AppDateFormats.eventShortDateTime)
                            .format(event.dateTime),
                      ),
                      const SizedBox(width: AppDimens.space12),
                      const Icon(Icons.location_on, size: AppDimens.icon16),
                      const SizedBox(width: AppDimens.space4),
                      Expanded(
                        child: Text(
                          event.location,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
