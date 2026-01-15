import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/hotel_card.dart';
import '../providers/hotel_provider.dart';

class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});

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
        title: const Text('All Hotels'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.filter, size: 20),
            ),
            onPressed: () => _showFilterSheet(context),
          ),
          AppSpacing.hGapSm,
        ],
      ),
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.hotels.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final hotels = provider.filteredHotels;

          if (hotels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.building,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  AppSpacing.vGapLg,
                  Text(
                    'No hotels found',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildCategoryFilter(provider),
              Expanded(
                child: ListView.builder(
                  padding: AppSpacing.screenPadding,
                  itemCount: hotels.length,
                  itemBuilder: (context, index) {
                    final hotel = hotels[index];
                    return HotelCard(
                      hotel: hotel,
                      onTap: () {
                        provider.selectHotel(hotel.id);
                        Navigator.pushNamed(context, '/hotel-details');
                      },
                      onFavorite: () => provider.toggleFavorite(hotel.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter(HotelProvider provider) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          final isSelected = category == provider.selectedCategory;
          return GestureDetector(
            onTap: () => provider.setCategory(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                category,
                style: AppTypography.labelLarge.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  RangeValues _priceRange = const RangeValues(50, 500);
  double _minRating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxl),
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
            'Filter Hotels',
            style: AppTypography.headlineMedium,
          ),
          AppSpacing.vGapXxl,
          Text(
            'Price Range',
            style: AppTypography.titleMedium,
          ),
          AppSpacing.vGapMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.toInt()}',
                style: AppTypography.bodyMedium,
              ),
              Text(
                '\$${_priceRange.end.toInt()}',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surfaceVariant,
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          AppSpacing.vGapXl,
          Text(
            'Minimum Rating',
            style: AppTypography.titleMedium,
          ),
          AppSpacing.vGapMd,
          Row(
            children: [
              Icon(Iconsax.star1, color: AppColors.rating, size: 20),
              AppSpacing.hGapSm,
              Text(
                _minRating.toStringAsFixed(1),
                style: AppTypography.bodyMedium,
              ),
              Expanded(
                child: Slider(
                  value: _minRating,
                  min: 1,
                  max: 5,
                  divisions: 8,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.surfaceVariant,
                  onChanged: (value) {
                    setState(() {
                      _minRating = value;
                    });
                  },
                ),
              ),
            ],
          ),
          AppSpacing.vGapXxl,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _priceRange = const RangeValues(50, 500);
                      _minRating = 4.0;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
