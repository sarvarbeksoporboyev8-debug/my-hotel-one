import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../providers/hotel_provider.dart';

class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.arrow_left, size: 20),
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: false,
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
            return Column(
              children: [
                _buildCategoryFilter(provider),
                const Expanded(
                  child: HotelListSkeleton(itemCount: 4),
                ),
              ],
            );
          }

          final hotels = provider.filteredHotels;

          return Column(
            children: [
              _buildActiveFilters(context, provider),
              _buildCategoryFilter(provider),
              Expanded(
                child: hotels.isEmpty
                    ? EmptyState.noSearchResults(
                        onClear: () => provider.clearFilters(),
                      )
                    : ListView.builder(
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
                            onFavorite: () {
                              HapticFeedback.lightImpact();
                              provider.toggleFavorite(hotel.id);
                            },
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

  Widget _buildActiveFilters(BuildContext context, HotelProvider provider) {
    final hasFilters = provider.hasActiveFilters;
    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          if (provider.priceRange != null)
            _FilterChip(
              label: '\$${provider.priceRange!.start.toInt()}-\$${provider.priceRange!.end.toInt()}',
              onRemove: () => provider.setPriceRange(null),
            ),
          if (provider.minRating != null) ...[
            AppSpacing.hGapSm,
            _FilterChip(
              label: '${provider.minRating!.toStringAsFixed(1)}+ ★',
              onRemove: () => provider.setMinRating(null),
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: () => provider.clearFilters(),
            child: Text(
              'Clear all',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
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
            onTap: () {
              HapticFeedback.selectionClick();
              provider.setCategory(category);
            },
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

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          AppSpacing.hGapXs,
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Iconsax.close_circle5,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late RangeValues _priceRange;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    final provider = context.read<HotelProvider>();
    _priceRange = provider.priceRange ?? const RangeValues(0, 1000);
    _minRating = provider.minRating ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
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
                      _priceRange = const RangeValues(0, 1000);
                      _minRating = 1.0;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<HotelProvider>();
                    // Only set filters if they're not at default values
                    if (_priceRange.start > 0 || _priceRange.end < 1000) {
                      provider.setPriceRange(_priceRange);
                    } else {
                      provider.setPriceRange(null);
                    }
                    if (_minRating > 1.0) {
                      provider.setMinRating(_minRating);
                    } else {
                      provider.setMinRating(null);
                    }
                    Navigator.pop(context);
                  },
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
