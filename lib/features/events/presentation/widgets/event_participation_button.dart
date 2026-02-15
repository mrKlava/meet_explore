import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class EventParticipationButton extends StatelessWidget {
  final bool isLoading;
  final bool isParticipating;
  final bool isAuthenticated;
  final VoidCallback onAuthenticatedTap;
  final VoidCallback onGuestTap;

  const EventParticipationButton({
    super.key,
    required this.isLoading,
    required this.isParticipating,
    required this.isAuthenticated,
    required this.onAuthenticatedTap,
    required this.onGuestTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : isAuthenticated
              ? onAuthenticatedTap
              : onGuestTap,
      icon: Icon(
        isParticipating ? Icons.cancel : Icons.check_circle_outline,
      ),
      label: Text(
        isParticipating
            ? AppStrings.cancelParticipation
            : AppStrings.participate,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isParticipating ? AppColors.danger : Theme.of(context).colorScheme.primary,
        foregroundColor: AppColors.onPrimary,
        padding:
            const EdgeInsets.symmetric(vertical: AppDimens.buttonVerticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
        ),
        elevation: AppDimens.elevation6,
      ),
    );
  }
}
