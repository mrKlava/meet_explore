import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/features/auth/presentation/providers/auth_provider.dart';
import 'package:meet_explore/routes/app_routes.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    // Determine if user is signed in
    final isAuthenticated = authState.when(
      data: (user) => user != null,
      loading: () => false,
      error: (_, _) => false,
    );

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawer_header.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(alignment: Alignment.bottomLeft, child: null),
          ),

          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.events);
            },
          ),

          if (isAuthenticated)
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: const Text('Participating'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.participatingEvents,
                );
              },
            ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.about);
            },
          ),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.contacts);
            },
          ),

          const Spacer(),

          ListTile(
            leading: Icon(isAuthenticated ? Icons.logout : Icons.login),
            title: Text(isAuthenticated ? 'Logout' : 'Sign In'),
            onTap: () async {
              Navigator.pop(context); // close drawer first
              if (isAuthenticated) {
                await ref.read(authRepositoryProvider).signOut();
                if (!context.mounted) return;
                // optional: navigate to events screen
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

