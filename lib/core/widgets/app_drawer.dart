import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final isUser = authService.isSignedIn;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawer_header.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: null
              // child: Text(
              //   'Meet & Explore Pau',
              //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //   ),
            ),
          ),

          // Events
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/events');
            },
          ),

          // Participating (only for authenticated users)
          if (isUser)
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: const Text('Participating'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/events-participating');
              },
            ),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about');
            },
          ),

          // Contacts
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contacts');
            },
          ),

          const Spacer(),

          // Auth action (Sign In or Logout)
          ListTile(
            leading: Icon(isUser ? Icons.logout : Icons.login),
            title: Text(isUser ? 'Logout' : 'Sign In'),
            onTap: () async {
              if (isUser) {
                // Logout
                await authService.signOut();
                Navigator.pushReplacementNamed(context, '/events');
              } else {
                // Navigate to login
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
