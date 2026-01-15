import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../hotels/providers/hotel_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../providers/settings_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer4<AuthProvider, HotelProvider, BookingProvider, SettingsProvider>(
        builder: (context, authProvider, hotelProvider, bookingProvider, settingsProvider, child) {
          final user = authProvider.user;
          final isGuest = user == null;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              image: user?.avatar != null
                                  ? DecorationImage(
                                      image: NetworkImage(user!.avatar!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: user?.avatar == null
                                ? Center(
                                    child: Text(
                                      user?.name.substring(0, 1).toUpperCase() ?? 'G',
                                      style: AppTypography.displayMedium.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          AppSpacing.vGapMd,
                          Text(
                            user?.name ?? 'Guest',
                            style: AppTypography.headlineMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          AppSpacing.vGapXs,
                          Text(
                            user?.email ?? 'Sign in to access all features',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (!isGuest)
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Iconsax.edit, color: Colors.white, size: 20),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        Navigator.pushNamed(context, '/personal-info');
                      },
                    ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.vGapXxl,
                      if (isGuest) ...[
                        _buildGuestBanner(context),
                        AppSpacing.vGapXxl,
                      ] else ...[
                        _buildStatsRow(hotelProvider, bookingProvider),
                        AppSpacing.vGapXxl,
                        Text(
                          'Account',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        AppSpacing.vGapMd,
                        _buildMenuItem(
                          context: context,
                          icon: Iconsax.user,
                          title: 'Personal Information',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.pushNamed(context, '/personal-info');
                          },
                        ),
                        _buildMenuItem(
                          context: context,
                          icon: Iconsax.card,
                          title: 'Payment Methods',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.pushNamed(context, '/payment-methods');
                          },
                        ),
                        _buildMenuItem(
                          context: context,
                          icon: Iconsax.notification,
                          title: 'Notifications',
                          trailing: _buildSwitch(
                            settingsProvider.notificationsEnabled,
                            (value) {
                              HapticFeedback.selectionClick();
                              settingsProvider.setNotificationsEnabled(value);
                            },
                          ),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.pushNamed(context, '/notifications');
                          },
                        ),
                        _buildMenuItem(
                          context: context,
                          icon: Iconsax.heart,
                          title: 'Saved Hotels',
                          subtitle: '${hotelProvider.favorites.length} saved',
                          onTap: () async {
                            HapticFeedback.selectionClick();
                            await hotelProvider.loadFavorites();
                            if (context.mounted) {
                              Navigator.pushNamed(context, '/favorites');
                            }
                          },
                        ),
                        AppSpacing.vGapXxl,
                      ],
                      Text(
                        'Preferences',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.vGapMd,
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.language_square,
                        title: 'Language',
                        subtitle: settingsProvider.language,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pushNamed(context, '/language');
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.dollar_circle,
                        title: 'Currency',
                        subtitle: '${settingsProvider.currency} (${settingsProvider.currencySymbol})',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pushNamed(context, '/currency');
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.moon,
                        title: 'Dark Mode',
                        trailing: _buildSwitch(
                          settingsProvider.isDarkMode,
                          (value) {
                            HapticFeedback.selectionClick();
                            settingsProvider.setDarkMode(value);
                          },
                        ),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          settingsProvider.setDarkMode(!settingsProvider.isDarkMode);
                        },
                      ),
                      AppSpacing.vGapXxl,
                      Text(
                        'Support',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.vGapMd,
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.message_question,
                        title: 'Help Center',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          _showComingSoon(context, 'Help Center');
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.shield_tick,
                        title: 'Privacy Policy',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          _showComingSoon(context, 'Privacy Policy');
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.document_text,
                        title: 'Terms of Service',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          _showComingSoon(context, 'Terms of Service');
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Iconsax.info_circle,
                        title: 'About',
                        subtitle: 'Version 1.0.0',
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pushNamed(context, '/about');
                        },
                      ),
                      AppSpacing.vGapXxl,
                      if (isGuest)
                        _buildSignInButton(context)
                      else
                        _buildLogoutButton(context, authProvider),
                      AppSpacing.vGapXxxl,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: AppColors.buttonShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.user_add, color: Colors.white, size: 24),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign in for more',
                  style: AppTypography.titleMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                AppSpacing.vGapXs,
                Text(
                  'Save favorites, manage bookings, and more',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Iconsax.arrow_right_3,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(HotelProvider hotelProvider, BookingProvider bookingProvider) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              '${bookingProvider.bookings.length}',
              'Bookings',
              Iconsax.receipt_2,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.border,
          ),
          Expanded(
            child: _buildStatItem(
              '${hotelProvider.favorites.length}',
              'Saved',
              Iconsax.heart,
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.border,
          ),
          Expanded(
            child: _buildStatItem(
              '0',
              'Reviews',
              Iconsax.star,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        AppSpacing.vGapSm,
        Text(
          value,
          style: AppTypography.headlineMedium,
        ),
        Text(
          label,
          style: AppTypography.labelSmall,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark 
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium,
                  ),
                  if (subtitle != null) ...[
                    AppSpacing.vGapXs,
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, '/login');
      },
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: AppColors.buttonShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.login, color: Colors.white),
            AppSpacing.hGapMd,
            Text(
              'Sign In',
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Sign Out',
              style: AppTypography.headlineSmall,
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: AppTypography.bodyMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusLg,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  authProvider.logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        );
      },
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, color: AppColors.error),
            AppSpacing.hGapMd,
            Text(
              'Sign Out',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
