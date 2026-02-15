import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
                _MetaRow(icon: Icons.location_on, text: event.shortLocation),
                if (event.hasLimitedPlaces)
                  _MetaRow(
                    icon: Icons.groups,
                    text: '${event.availablePlaces} places available',
                  ),
                _MetaRow(
                  icon: Icons.euro,
                  text: event.price > 0
                      ? event.price.toStringAsFixed(2)
                      : AppStrings.free,
                ),
                const SizedBox(height: AppDimens.space16),
                if (event.description.isNotEmpty)
                  _TextSection(
                    title: 'Description',
                    items: event.description,
                  ),
                _LocationSection(
                  address: event.address,
                  locationUrl: event.locationUrl,
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
    final start = event.dateStart;
    final end = event.dateEnd;

    if (end == null) {
      return DateFormat(AppDateFormats.eventDateTime).format(start);
    }

    final isSameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    if (isSameDay) {
      final sameTime =
          start.hour == end.hour && start.minute == end.minute;
      if (sameTime) {
        return DateFormat(AppDateFormats.eventDateTime).format(start);
      }

      final datePart = DateFormat('MMM dd, yyyy').format(start);
      final startTime = DateFormat('HH:mm').format(start);
      final endTime = DateFormat('HH:mm').format(end);
      return '$datePart, $startTime - $endTime';
    }

    final startText = DateFormat(AppDateFormats.eventDateTime).format(start);
    final endText = DateFormat(AppDateFormats.eventDateTime).format(end);
    return '$startText - $endText';
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

class _LocationSection extends StatelessWidget {
  final String address;
  final String locationUrl;

  const _LocationSection({
    required this.address,
    required this.locationUrl,
  });

  Future<void> _openLocation(BuildContext context) async {
    if (locationUrl.isEmpty) return;

    final opened = await launchUrlString(
      locationUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.couldNotOpenPrefix} $locationUrl')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLink = locationUrl.isNotEmpty;
    final displayAddress = address.isNotEmpty ? address : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.space6),
          if (hasLink)
            InkWell(
              onTap: () => _openLocation(context),
              child: Text(
                displayAddress,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            Text(displayAddress),
        ],
      ),
    );
  }
}
