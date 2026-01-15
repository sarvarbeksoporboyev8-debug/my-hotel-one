import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  // Preset empty states
  factory EmptyState.noFavorites({VoidCallback? onExplore}) {
    return EmptyState(
      icon: Iconsax.heart,
      title: 'No saved hotels yet',
      subtitle: 'Start exploring and save hotels you love',
      actionText: 'Explore Hotels',
      onAction: onExplore,
    );
  }

  factory EmptyState.noBookings({VoidCallback? onExplore}) {
    return EmptyState(
      icon: Iconsax.calendar,
      title: 'No bookings yet',
      subtitle: 'Your upcoming trips will appear here',
      actionText: 'Book a Hotel',
      onAction: onExplore,
    );
  }

  factory EmptyState.noSearchResults({VoidCallback? onClear}) {
    return EmptyState(
      icon: Iconsax.search_normal,
      title: 'No results found',
      subtitle: 'Try adjusting your search or filters',
      actionText: 'Clear Filters',
      onAction: onClear,
    );
  }

  factory EmptyState.noNotifications() {
    return const EmptyState(
      icon: Iconsax.notification,
      title: 'No notifications',
      subtitle: 'You\'re all caught up!',
    );
  }

  factory EmptyState.error({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Iconsax.warning_2,
      title: 'Something went wrong',
      subtitle: 'Please try again later',
      actionText: 'Retry',
      onAction: onRetry,
    );
  }

  factory EmptyState.noConnection({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Iconsax.wifi_square,
      title: 'No internet connection',
      subtitle: 'Check your connection and try again',
      actionText: 'Retry',
      onAction: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.vGapXxl,
            Text(
              title,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.vGapSm,
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              AppSpacing.vGapXxl,
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
