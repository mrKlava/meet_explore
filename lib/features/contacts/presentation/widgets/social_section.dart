import 'package:flutter/material.dart';
import 'package:meet_explore/features/contacts/presentation/widgets/social_button.dart';

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Connect with us:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            SocialButton(
              icon: Icons.camera_alt,
              color: Colors.purple,
              url: 'https://instagram.com/meetexplorepau',
            ),
            SocialButton(
              icon: Icons.facebook,
              color: Colors.blue,
              url: 'https://facebook.com/groups/meetexplorepau',
            ),
            SocialButton(
              icon: Icons.message,
              color: Colors.green,
              url: 'https://wa.me/1234567890',
            ),
          ],
        ),
      ],
    );
  }
}
