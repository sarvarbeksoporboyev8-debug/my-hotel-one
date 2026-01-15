import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/settings_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.arrow_left, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: AppSpacing.screenPadding,
            children: [
              AppSpacing.vGapLg,
              _buildMasterToggle(context, settings),
              AppSpacing.vGapXxl,
              AnimatedOpacity(
                opacity: settings.notificationsEnabled ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !settings.notificationsEnabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Types',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.vGapMd,
                      _buildToggleItem(
                        icon: Iconsax.notification,
                        title: 'Push Notifications',
                        subtitle: 'Receive alerts on your device',
                        value: settings.pushNotifications,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          settings.setPushNotifications(value);
                        },
                      ),
                      _buildToggleItem(
                        icon: Iconsax.sms,
                        title: 'Email Notifications',
                        subtitle: 'Receive updates via email',
                        value: settings.emailNotifications,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          settings.setEmailNotifications(value);
                        },
                      ),
                      _buildToggleItem(
                        icon: Iconsax.discount_shape,
                        title: 'Promotional Offers',
                        subtitle: 'Get notified about deals and discounts',
                        value: settings.promoNotifications,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          settings.setPromoNotifications(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.vGapXxxl,
              _buildInfoCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMasterToggle(BuildContext context, SettingsProvider settings) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: settings.notificationsEnabled
            ? AppColors.primaryGradient
            : null,
        color: settings.notificationsEnabled ? null : AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: settings.notificationsEnabled
                  ? Colors.white.withOpacity(0.2)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              settings.notificationsEnabled
                  ? Iconsax.notification_bing5
                  : Iconsax.notification_bing,
              color: settings.notificationsEnabled
                  ? Colors.white
                  : AppColors.textTertiary,
              size: 24,
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Notifications',
                  style: AppTypography.titleMedium.copyWith(
                    color: settings.notificationsEnabled
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                AppSpacing.vGapXs,
                Text(
                  settings.notificationsEnabled
                      ? 'You\'ll receive notifications'
                      : 'Notifications are disabled',
                  style: AppTypography.bodySmall.copyWith(
                    color: settings.notificationsEnabled
                        ? Colors.white.withOpacity(0.8)
                        : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: settings.notificationsEnabled,
            onChanged: (value) {
              HapticFeedback.mediumImpact();
              settings.setNotificationsEnabled(value);
            },
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                AppSpacing.vGapXs,
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(Iconsax.info_circle, color: AppColors.textTertiary, size: 20),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(
              'You can change these settings anytime. We respect your preferences.',
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
