import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/settings_provider.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  static const List<_Currency> _currencies = [
    _Currency('USD', 'US Dollar', '\$'),
    _Currency('EUR', 'Euro', '€'),
    _Currency('GBP', 'British Pound', '£'),
    _Currency('JPY', 'Japanese Yen', '¥'),
    _Currency('AUD', 'Australian Dollar', 'A\$'),
    _Currency('CAD', 'Canadian Dollar', 'C\$'),
    _Currency('CHF', 'Swiss Franc', 'CHF'),
    _Currency('CNY', 'Chinese Yuan', '¥'),
    _Currency('INR', 'Indian Rupee', '₹'),
    _Currency('SGD', 'Singapore Dollar', 'S\$'),
  ];

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
        title: const Text('Currency'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: AppSpacing.screenPadding,
            children: [
              AppSpacing.vGapLg,
              Text(
                'Select Currency',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              AppSpacing.vGapMd,
              ..._currencies.map((currency) => _buildCurrencyItem(
                context,
                currency,
                settings.currency == currency.code,
                () {
                  HapticFeedback.selectionClick();
                  settings.setCurrency(currency.code);
                },
              )),
              AppSpacing.vGapXxl,
              _buildInfoCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrencyItem(
    BuildContext context,
    _Currency currency,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surfaceVariant,
          borderRadius: AppSpacing.borderRadiusMd,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Center(
                child: Text(
                  currency.symbol,
                  style: AppTypography.headlineSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.code,
                    style: AppTypography.titleMedium.copyWith(
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  Text(
                    currency.name,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
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
              'Prices will be displayed in your selected currency. Actual charges may vary based on exchange rates.',
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Currency {
  final String code;
  final String name;
  final String symbol;

  const _Currency(this.code, this.name, this.symbol);
}
