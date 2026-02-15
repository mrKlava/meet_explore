import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_state_views.dart';
import '../providers/about_provider.dart';
import '../widgets/about_content.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutAsync = ref.watch(aboutInfoProvider);

    return AppScaffold(
      title: AppStrings.aboutTitle,
      body: aboutAsync.when(
        loading: () => const AppLoadingView(),
        error: (error, _) =>
            AppErrorView(error: error, prefix: AppStrings.errorPrefix),
        data: (about) => AboutContent(about: about),
      ),
    );
  }
}
