import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/core/widgets/app_drawer.dart';
import 'package:meet_explore/core/widgets/app_state_views.dart';
import 'package:meet_explore/features/about/presentation/widgets/about_content.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/about_provider.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutAsync = ref.watch(aboutInfoProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(AppStrings.aboutTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: aboutAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(error: error, prefix: AppStrings.errorPrefix),
        data: (about) => AboutContent(about: about),
      ),
    );
  }
}
