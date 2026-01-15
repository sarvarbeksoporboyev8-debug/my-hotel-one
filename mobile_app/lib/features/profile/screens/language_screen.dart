import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../providers/settings_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const List<_Language> _languages = [
    _Language('English', 'en', '🇺🇸'),
    _Language('Spanish', 'es', '🇪🇸'),
    _Language('French', 'fr', '🇫🇷'),
    _Language('German', 'de', '🇩🇪'),
    _Language('Italian', 'it', '🇮🇹'),
    _Language('Portuguese', 'pt', '🇵🇹'),
    _Language('Chinese', 'zh', '🇨🇳'),
    _Language('Japanese', 'ja', '🇯🇵'),
    _Language('Korean', 'ko', '🇰🇷'),
    _Language('Arabic', 'ar', '🇸🇦'),
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
        title: const Text('Language'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: AppSpacing.screenPadding,
            children: [
              AppSpacing.vGapLg,
              Text(
                'Select Language',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              AppSpacing.vGapMd,
              ..._languages.map((language) => _buildLanguageItem(
                context,
                language,
                settings.language == language.name,
                () {
                  HapticFeedback.selectionClick();
                  settings.setLanguage(language.name);
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

  Widget _buildLanguageItem(
    BuildContext context,
    _Language language,
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
            Text(
              language.flag,
              style: const TextStyle(fontSize: 24),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: AppTypography.titleMedium.copyWith(
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  Text(
                    language.code.toUpperCase(),
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
        color: AppColors.warningLight,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(Iconsax.info_circle, color: AppColors.warning, size: 20),
          AppSpacing.hGapMd,
          Expanded(
            child: Text(
              'Language changes will apply to the app interface. Some content may remain in English.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Language {
  final String name;
  final String code;
  final String flag;

  const _Language(this.name, this.code, this.flag);
}
