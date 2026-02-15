import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/features/auth/presentation/providers/auth_provider.dart';
import 'package:meet_explore/routes/app_routes.dart';

import '../constants/app_constants.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final isAuthenticated = authState.when(
      data: (user) => user != null,
      loading: () => false,
      error: (_, _) => false,
    );

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.drawerHeader),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(alignment: Alignment.bottomLeft, child: null),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text(AppStrings.drawerEvents),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.events);
            },
          ),
          if (isAuthenticated)
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: const Text(AppStrings.drawerParticipating),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.participatingEvents,
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.drawerAbout),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.about);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text(AppStrings.drawerContacts),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.contacts);
            },
          ),
          const Spacer(),
          ListTile(
            leading: Icon(isAuthenticated ? Icons.logout : Icons.login),
            title: Text(
              isAuthenticated
                  ? AppStrings.drawerLogout
                  : AppStrings.drawerSignIn,
            ),
            onTap: () async {
              Navigator.pop(context);
              if (isAuthenticated) {
                await ref.read(authRepositoryProvider).signOut();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, AppRoutes.events);
              } else {
                Navigator.pushNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
    );
  }
}
