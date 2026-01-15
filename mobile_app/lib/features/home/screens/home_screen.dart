import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/hotel_card.dart';
import '../../hotels/providers/hotel_provider.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().loadHotels();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<HotelProvider>().loadHotels(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildCategories()),
              SliverToBoxAdapter(child: _buildPopularSection()),
              SliverToBoxAdapter(child: _buildNearbySection()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${auth.user?.name.split(' ').first ?? 'Guest'} 👋',
                      style: AppTypography.bodyLarge,
                    ),
                    AppSpacing.vGapXs,
                    Text(
                      'Find your perfect stay',
                      style: AppTypography.headlineMedium,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Badge(
                    smallSize: 8,
                    child: Icon(
                      Iconsax.notification,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/search'),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Row(
            children: [
              Icon(
                Iconsax.search_normal,
                color: AppColors.textTertiary,
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Text(
                  'Search hotels, cities...',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  Iconsax.setting_4,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Consumer<HotelProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.vGapXxl,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                'Categories',
                style: AppTypography.headlineSmall,
              ),
            ),
            AppSpacing.vGapMd,
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                        boxShadow: isSelected ? AppColors.buttonShadow : null,
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopularSection() {
    return Consumer<HotelProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.popularHotels.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xxl),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.vGapXxl,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Hotels',
                    style: AppTypography.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/hotels'),
                    child: Text(
                      'See All',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vGapMd,
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: provider.popularHotels.length,
                itemBuilder: (context, index) {
                  final hotel = provider.popularHotels[index];
                  return HotelCard(
                    hotel: hotel,
                    isCompact: true,
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
    );
  }

  Widget _buildNearbySection() {
    return Consumer<HotelProvider>(
      builder: (context, provider, child) {
        final hotels = provider.filteredHotels;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.vGapXxl,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Hotels',
                    style: AppTypography.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/hotels'),
                    child: Text(
                      'See All',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vGapMd,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: hotels.length > 3 ? 3 : hotels.length,
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
          ],
        );
      },
    );
  }
}
