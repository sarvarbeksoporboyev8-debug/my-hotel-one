import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<_PaymentMethod> _paymentMethods = [
    _PaymentMethod(
      id: '1',
      type: 'visa',
      lastFour: '4242',
      expiryDate: '12/25',
      isDefault: true,
    ),
    _PaymentMethod(
      id: '2',
      type: 'mastercard',
      lastFour: '8888',
      expiryDate: '06/26',
      isDefault: false,
    ),
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
        title: const Text('Payment Methods'),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppSpacing.vGapLg,
          Text(
            'Saved Cards',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.vGapMd,
          ..._paymentMethods.map((method) => _buildPaymentCard(method)),
          AppSpacing.vGapXxl,
          _buildAddCardButton(),
          AppSpacing.vGapXxxl,
          _buildSecurityNote(),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(_PaymentMethod method) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: method.isDefault ? AppColors.primarySurface : AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusLg,
        border: method.isDefault
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                method.type == 'visa' ? 'VISA' : 'MC',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: method.type == 'visa' 
                      ? const Color(0xFF1A1F71) 
                      : const Color(0xFFEB001B),
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
                  '•••• •••• •••• ${method.lastFour}',
                  style: AppTypography.titleMedium,
                ),
                AppSpacing.vGapXs,
                Text(
                  'Expires ${method.expiryDate}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          if (method.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                'Default',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          else
            PopupMenuButton<String>(
              icon: Icon(Iconsax.more, color: AppColors.textTertiary),
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              onSelected: (value) {
                HapticFeedback.lightImpact();
                if (value == 'default') {
                  setState(() {
                    for (var m in _paymentMethods) {
                      m.isDefault = m.id == method.id;
                    }
                  });
                } else if (value == 'remove') {
                  setState(() {
                    _paymentMethods.removeWhere((m) => m.id == method.id);
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'default',
                  child: Row(
                    children: [
                      Icon(Iconsax.tick_circle, size: 20),
                      AppSpacing.hGapMd,
                      Text('Set as default'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Iconsax.trash, size: 20, color: AppColors.error),
                      AppSpacing.hGapMd,
                      Text('Remove', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showAddCardSheet();
      },
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(Iconsax.add, color: AppColors.primary, size: 20),
            ),
            AppSpacing.hGapMd,
            Text(
              'Add New Card',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(Iconsax.shield_tick, color: AppColors.info, size: 24),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your payment info is secure',
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
                AppSpacing.vGapXs,
                Text(
                  'We use industry-standard encryption to protect your data.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXxl),
          ),
        ),
        padding: EdgeInsets.only(
          left: AppSpacing.xxl,
          right: AppSpacing.xxl,
          top: AppSpacing.xxl,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSpacing.vGapXxl,
            Text(
              'Add New Card',
              style: AppTypography.headlineMedium,
            ),
            AppSpacing.vGapMd,
            Text(
              'This is a demo. No real card data is stored.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            AppSpacing.vGapXxl,
            CustomButton(
              text: 'Add Demo Card',
              onPressed: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _paymentMethods.add(_PaymentMethod(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    type: _paymentMethods.length % 2 == 0 ? 'visa' : 'mastercard',
                    lastFour: '${1000 + _paymentMethods.length}',
                    expiryDate: '12/27',
                    isDefault: false,
                  ));
                });
                Navigator.pop(context);
              },
              icon: Iconsax.card_add,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethod {
  final String id;
  final String type;
  final String lastFour;
  final String expiryDate;
  bool isDefault;

  _PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFour,
    required this.expiryDate,
    required this.isDefault,
  });
}
