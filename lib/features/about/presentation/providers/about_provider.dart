import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/about_repository_impl.dart';
import '../../domain/entities/about_info.dart';
import '../../domain/repositories/about_repository.dart';

final aboutRepositoryProvider = Provider<AboutRepository>((ref) {
  return AboutRepositoryImpl();
});

final aboutInfoProvider = FutureProvider<AboutInfo>((ref) async {
  final repository = ref.read(aboutRepositoryProvider);
  return repository.getAboutInfo();
});
