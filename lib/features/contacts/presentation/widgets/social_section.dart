import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import 'social_button.dart';

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.connectWithUs,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimens.space12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialButton(
              icon: Icons.camera_alt,
              color: AppColors.instagram,
              url: AppLinks.instagram,
            ),
            SocialButton(
              icon: Icons.facebook,
              color: AppColors.facebook,
              url: AppLinks.facebook,
            ),
            SocialButton(
              icon: Icons.message,
              color: AppColors.whatsapp,
              url: AppLinks.whatsapp,
            ),
          ],
        ),
      ],
    );
  }
}
