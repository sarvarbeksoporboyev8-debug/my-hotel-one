import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/theme.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : AppColors.surfaceVariant,
      highlightColor: isDark ? Colors.grey[700]! : AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class HotelCardSkeleton extends StatelessWidget {
  final bool isCompact;

  const HotelCardSkeleton({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactSkeleton(context);
    }
    return _buildFullSkeleton(context);
  }

  Widget _buildFullSkeleton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(
            height: 180,
            borderRadius: AppSpacing.radiusXl,
          ),
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SkeletonLoader(width: 60, height: 20),
                    const Spacer(),
                    const SkeletonLoader(width: 80, height: 16),
                  ],
                ),
                AppSpacing.vGapSm,
                const SkeletonLoader(width: double.infinity, height: 24),
                AppSpacing.vGapXs,
                const SkeletonLoader(width: 150, height: 16),
                AppSpacing.vGapMd,
                const SkeletonLoader(width: 100, height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSkeleton(BuildContext context) {
    return Container(
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
          const SkeletonLoader(
            height: 140,
            borderRadius: AppSpacing.radiusXl,
          ),
          Padding(
            padding: AppSpacing.cardPaddingSmall,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(width: double.infinity, height: 18),
                AppSpacing.vGapXs,
                const SkeletonLoader(width: 100, height: 14),
                AppSpacing.vGapSm,
                const SkeletonLoader(width: 80, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HotelListSkeleton extends StatelessWidget {
  final int itemCount;
  final bool isCompact;

  const HotelListSkeleton({
    super.key,
    this.itemCount = 3,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return SizedBox(
        height: 260,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: itemCount,
          itemBuilder: (context, index) => const HotelCardSkeleton(isCompact: true),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: itemCount,
      itemBuilder: (context, index) => const HotelCardSkeleton(),
    );
  }
}

class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonLoader(
                width: 80,
                height: 80,
                borderRadius: AppSpacing.radiusMd,
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(width: double.infinity, height: 18),
                    AppSpacing.vGapSm,
                    const SkeletonLoader(width: 120, height: 14),
                    AppSpacing.vGapSm,
                    const SkeletonLoader(width: 80, height: 20),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vGapMd,
          const Divider(),
          AppSpacing.vGapMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonLoader(width: 100, height: 16),
              const SkeletonLoader(width: 80, height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SkeletonLoader(
          width: 80,
          height: 80,
          borderRadius: 40,
        ),
        AppSpacing.vGapMd,
        const SkeletonLoader(width: 150, height: 24),
        AppSpacing.vGapSm,
        const SkeletonLoader(width: 200, height: 16),
      ],
    );
  }
}
