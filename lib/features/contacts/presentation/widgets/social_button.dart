import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/constants/app_constants.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String url;

  const SocialButton({
    super.key,
    required this.icon,
    required this.color,
    required this.url,
  });

  Future<void> _launch(String url, BuildContext context) async {
    try {
      if (!await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.couldNotOpenPrefix} $url')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.errorPrefix}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launch(url, context),
      borderRadius: BorderRadius.circular(AppDimens.radius50),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.space12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppDimens.space4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.onPrimary,
          size: AppDimens.icon28,
        ),
      ),
    );
  }
}
