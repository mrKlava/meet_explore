import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class EventParticipationButton extends StatelessWidget {
  final bool isLoading;
  final bool isParticipating;
  final bool isAuthenticated;
  final bool isFull;
  final VoidCallback onAuthenticatedTap;
  final VoidCallback onGuestTap;

  const EventParticipationButton({
    super.key,
    required this.isLoading,
    required this.isParticipating,
    required this.isAuthenticated,
    required this.isFull,
    required this.onAuthenticatedTap,
    required this.onGuestTap,
  });

  @override
  Widget build(BuildContext context) {
    final canParticipate = !isFull || isParticipating;
    final isFullState = isFull && !isParticipating;

    final button = ElevatedButton.icon(
      onPressed: isLoading
          ? null
          : !canParticipate
              ? null
              : isAuthenticated
                  ? onAuthenticatedTap
                  : onGuestTap,
      icon: Icon(
        isParticipating
            ? Icons.cancel
            : isFull
                ? Icons.block
                : Icons.check_circle_outline,
      ),
      label: Text(
        isParticipating
            ? AppStrings.cancelParticipation
            : isFull
                ? AppStrings.eventFull
                : AppStrings.participate,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isParticipating
            ? AppColors.danger
            : isFull
                ? Colors.grey.withValues(alpha: 0.28)
                : Theme.of(context).colorScheme.primary,
        disabledBackgroundColor: isFullState
            ? Colors.grey.withValues(alpha: 0.28)
            : null,
        foregroundColor: isFullState ? Colors.black87 : AppColors.onPrimary,
        disabledForegroundColor:
            isFullState ? Colors.black87 : AppColors.onPrimary,
        padding:
            const EdgeInsets.symmetric(vertical: AppDimens.buttonVerticalPadding),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radius12),
        ),
        elevation: isFullState ? 0 : AppDimens.elevation6,
      ),
    );

    if (!isFullState) return button;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radius12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: button,
      ),
    );
  }
}
