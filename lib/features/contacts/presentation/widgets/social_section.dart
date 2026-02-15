import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              icon: FontAwesomeIcons.instagram,
              color: AppColors.instagram,
              url: AppLinks.instagram,
              label: 'Instagram Account',
            ),
            SocialButton(
              icon: FontAwesomeIcons.facebookF,
              color: AppColors.facebook,
              url: AppLinks.facebook,
              label: 'Facebook Group',
            ),
            SocialButton(
              icon: FontAwesomeIcons.whatsapp,
              color: AppColors.whatsapp,
              url: AppLinks.whatsapp,
              label: 'WhatsApp Group',
            ),
          ],
        ),
      ],
    );
  }
}
