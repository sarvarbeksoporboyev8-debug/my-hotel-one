import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/hotel_card.dart';
import '../providers/hotel_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  final List<String> _recentSearches = [
    'New York',
    'Miami Beach',
    'Luxury Hotels',
    'San Francisco',
  ];

  final List<String> _popularDestinations = [
    'Paris',
    'Tokyo',
    'Dubai',
    'London',
    'Bali',
    'Maldives',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
        title: _buildSearchField(),
      ),
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (_searchController.text.isEmpty) {
            return _buildSuggestions();
          }

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.searchResults.isEmpty) {
            return _buildNoResults();
          }

          return ListView.builder(
            padding: AppSpacing.screenPadding,
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final hotel = provider.searchResults[index];
              return HotelCard(
                hotel: hotel,
                onTap: () {
                  provider.selectHotel(hotel.id);
                  Navigator.pushNamed(context, '/hotel-details');
                },
                onFavorite: () => provider.toggleFavorite(hotel.id),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Search hotels, cities...',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Iconsax.close_circle, size: 20),
                onPressed: () {
                  _searchController.clear();
                  context.read<HotelProvider>().searchHotels('');
                  setState(() {});
                },
              )
            : null,
      ),
      style: AppTypography.bodyLarge,
      onChanged: (value) {
        context.read<HotelProvider>().searchHotels(value);
        setState(() {});
      },
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: AppTypography.titleMedium,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Clear',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.vGapMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _recentSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    context.read<HotelProvider>().searchHotels(search);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                        AppSpacing.hGapSm,
                        Text(
                          search,
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            AppSpacing.vGapXxl,
          ],
          Text(
            'Popular Destinations',
            style: AppTypography.titleMedium,
          ),
          AppSpacing.vGapMd,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: _popularDestinations.length,
            itemBuilder: (context, index) {
              final destination = _popularDestinations[index];
              return GestureDetector(
                onTap: () {
                  _searchController.text = destination;
                  context.read<HotelProvider>().searchHotels(destination);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Icon(
                          Iconsax.location,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      AppSpacing.hGapMd,
                      Expanded(
                        child: Text(
                          destination,
                          style: AppTypography.labelLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.search_status,
            size: 64,
            color: AppColors.textTertiary,
          ),
          AppSpacing.vGapLg,
          Text(
            'No results found',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.vGapSm,
          Text(
            'Try searching for something else',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}
