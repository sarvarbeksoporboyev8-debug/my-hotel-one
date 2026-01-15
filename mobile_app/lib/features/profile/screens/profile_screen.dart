import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../hotels/providers/hotel_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, HotelProvider>(
        builder: (context, authProvider, hotelProvider, child) {
          final user = authProvider.user;

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
                            user?.email ?? '',
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
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Iconsax.edit, color: Colors.white, size: 20),
                    ),
                    onPressed: () {},
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
                      _buildStatsRow(hotelProvider),
                      AppSpacing.vGapXxl,
                      Text(
                        'Account',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.vGapMd,
                      _buildMenuItem(
                        icon: Iconsax.user,
                        title: 'Personal Information',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.card,
                        title: 'Payment Methods',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.notification,
                        title: 'Notifications',
                        trailing: _buildSwitch(true),
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.heart,
                        title: 'Saved Hotels',
                        onTap: () async {
                          await hotelProvider.loadFavorites();
                          if (context.mounted) {
                            Navigator.pushNamed(context, '/favorites');
                          }
                        },
                      ),
                      AppSpacing.vGapXxl,
                      Text(
                        'Preferences',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      AppSpacing.vGapMd,
                      _buildMenuItem(
                        icon: Iconsax.language_square,
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.dollar_circle,
                        title: 'Currency',
                        subtitle: 'USD (\$)',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.moon,
                        title: 'Dark Mode',
                        trailing: _buildSwitch(false),
                        onTap: () {},
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
                        icon: Iconsax.message_question,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.shield_tick,
                        title: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.document_text,
                        title: 'Terms of Service',
                        onTap: () {},
                      ),
                      _buildMenuItem(
                        icon: Iconsax.info_circle,
                        title: 'About',
                        subtitle: 'Version 1.0.0',
                        onTap: () {},
                      ),
                      AppSpacing.vGapXxl,
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

  Widget _buildStatsRow(HotelProvider hotelProvider) {
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
              '12',
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
              '8',
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
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
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

  Widget _buildSwitch(bool value) {
    return Switch(
      value: value,
      onChanged: (v) {},
      activeColor: AppColors.primary,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return InkWell(
      onTap: () {
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
