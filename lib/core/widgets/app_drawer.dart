import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meet_explore/features/auth/presentation/providers/auth_controller.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // Determine if user is signed in
    final isUser = authState.when(
      data: (user) => user != null,
      loading: () => false,
      error: (_, __) => false,
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
              Navigator.pushReplacementNamed(context, '/events');
            },
          ),

          if (isUser)
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: const Text('Participating'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/events-participating',
                );
              },
            ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about');
            },
          ),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contacts');
            },
          ),

          const Spacer(),

          ListTile(
            leading: Icon(isUser ? Icons.logout : Icons.login),
            title: Text(isUser ? 'Logout' : 'Sign In'),
            onTap: () async {
              if (isUser) {
                await ref.read(authControllerProvider.notifier).signOut();
                // No Navigator call here
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
