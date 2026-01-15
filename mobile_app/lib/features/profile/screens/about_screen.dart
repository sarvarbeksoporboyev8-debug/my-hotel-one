import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        title: const Text('About'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppSpacing.vGapXxl,
          _buildAppInfo(),
          AppSpacing.vGapXxxl,
          _buildSection('App Information', [
            _InfoItem('Version', '1.0.0'),
            _InfoItem('Build', '2024.01.15'),
            _InfoItem('Platform', 'Flutter'),
          ]),
          AppSpacing.vGapXxl,
          _buildSection('Legal', [
            _LinkItem('Terms of Service', Iconsax.document_text, () {}),
            _LinkItem('Privacy Policy', Iconsax.shield_tick, () {}),
            _LinkItem('Licenses', Iconsax.document, () {}),
          ]),
          AppSpacing.vGapXxl,
          _buildSection('Connect', [
            _LinkItem('Website', Iconsax.global, () {}),
            _LinkItem('Support', Iconsax.message_question, () {}),
            _LinkItem('Rate Us', Iconsax.star, () {}),
          ]),
          AppSpacing.vGapXxxl,
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.buttonShadow,
            ),
            child: const Icon(
              Icons.hotel_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          AppSpacing.vGapLg,
          Text(
            'SmartHotel',
            style: AppTypography.headlineMedium,
          ),
          AppSpacing.vGapXs,
          Text(
            'Find your perfect stay',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        AppSpacing.vGapMd,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            'Made with ❤️',
            style: AppTypography.bodySmall,
          ),
          AppSpacing.vGapXs,
          Text(
            '© 2024 SmartHotel. All rights reserved.',
            style: AppTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _LinkItem(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusLg,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            AppSpacing.hGapMd,
            Expanded(
              child: Text(label, style: AppTypography.bodyMedium),
            ),
            Icon(
              Iconsax.arrow_right_3,
              size: 18,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
