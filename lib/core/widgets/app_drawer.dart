import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/events');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_added_outlined),
            title: const Text('Participating'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/events-participating');
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
        ],
      ),
    );
  }
}
