import 'package:flutter/material.dart';
import 'package:meet_explore/core/widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image header
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/600/200?random=11',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Welcome to Meet & Explore Pau!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Paragraph
            const Text(
              'This app is designed to help people in and around Pau '
              'connect, discover local events, and make new friends. '
              'Whether you enjoy outdoor activities, music nights, theater, '
              'or casual meetups, there is something for everyone!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/600/250?random=12',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // More text
            const Text(
              'Our goal is to create a friendly community where you can '
              'participate in local events, learn new skills, and have fun. '
              'Stay tuned for updates and new features coming soon!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Footer image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/600/200?random=13',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
