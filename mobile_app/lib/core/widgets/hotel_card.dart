import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/models.dart';
import '../theme/theme.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isCompact;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.onTap,
    required this.onFavorite,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard();
    }
    return _buildFullCard();
  }

  Widget _buildFullCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusXl,
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(height: 180),
            Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          hotel.category,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Iconsax.star1,
                        size: 16,
                        color: AppColors.rating,
                      ),
                      AppSpacing.hGapXs,
                      Text(
                        hotel.rating.toString(),
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${hotel.reviewCount})',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  AppSpacing.vGapSm,
                  Text(
                    hotel.name,
                    style: AppTypography.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.vGapXs,
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 14,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.hGapXs,
                      Expanded(
                        child: Text(
                          '${hotel.city}, ${hotel.country}',
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGapMd,
                  Row(
                    children: [
                      if (hotel.discount > 0) ...[
                        Text(
                          '\$${hotel.originalPrice.toInt()}',
                          style: AppTypography.bodyMedium.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        AppSpacing.hGapSm,
                      ],
                      Text(
                        '\$${hotel.pricePerNight.toInt()}',
                        style: AppTypography.price,
                      ),
                      Text(
                        ' /night',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusXl,
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(height: 140),
            Padding(
              padding: AppSpacing.cardPaddingSmall,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: AppTypography.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.vGapXs,
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      AppSpacing.hGapXs,
                      Expanded(
                        child: Text(
                          hotel.city,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Iconsax.star1,
                        size: 12,
                        color: AppColors.rating,
                      ),
                      AppSpacing.hGapXs,
                      Text(
                        hotel.rating.toString(),
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGapSm,
                  Row(
                    children: [
                      Text(
                        '\$${hotel.pricePerNight.toInt()}',
                        style: AppTypography.priceSmall,
                      ),
                      Text(
                        ' /night',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({required double height}) {
    return Stack(
      children: [
        Hero(
          tag: 'hotel-image-${hotel.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
            child: CachedNetworkImage(
              imageUrl: hotel.images.first,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.surfaceVariant,
                highlightColor: AppColors.surface,
                child: Container(
                  height: height,
                  color: AppColors.surfaceVariant,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: height,
                color: AppColors.surfaceVariant,
                child: const Icon(Iconsax.image, size: 40),
              ),
            ),
          ),
        ),
        Positioned(
          top: AppSpacing.md,
          right: AppSpacing.md,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onFavorite();
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppColors.softShadow,
              ),
              child: Icon(
                hotel.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                size: 20,
                color: hotel.isFavorite ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        if (hotel.discount > 0)
          Positioned(
            top: AppSpacing.md,
            left: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                '-${hotel.discount}%',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
