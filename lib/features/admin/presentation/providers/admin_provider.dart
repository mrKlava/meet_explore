import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../events/domain/entities/event.dart';
import '../../../events/presentation/providers/events_provider.dart';

final adminEventsProvider = FutureProvider<List<Event>>((ref) async {
  final isAdmin = ref.watch(isAdminProvider);
  if (!isAdmin) return [];

  return ref.read(eventRepositoryProvider).fetchAllEventsForAdmin();
});
