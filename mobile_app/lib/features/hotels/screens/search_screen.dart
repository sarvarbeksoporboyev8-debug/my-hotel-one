import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../providers/hotel_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 10;

  List<String> _recentSearches = [];

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
    _loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList(_recentSearchesKey) ?? [];
    });
  }

  Future<void> _addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    // Remove if already exists to avoid duplicates
    _recentSearches.remove(query);
    // Add to beginning
    _recentSearches.insert(0, query);
    // Keep only max items
    if (_recentSearches.length > _maxRecentSearches) {
      _recentSearches = _recentSearches.sublist(0, _maxRecentSearches);
    }
    await prefs.setStringList(_recentSearchesKey, _recentSearches);
    setState(() {});
  }

  Future<void> _removeRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    await prefs.setStringList(_recentSearchesKey, _recentSearches);
    setState(() {});
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
    setState(() {
      _recentSearches = [];
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
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        context.read<HotelProvider>().searchHotels(value);
        setState(() {});
      },
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          HapticFeedback.selectionClick();
          _addRecentSearch(value.trim());
        }
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
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _clearRecentSearches();
                  },
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
                    HapticFeedback.selectionClick();
                    _searchController.text = search;
                    context.read<HotelProvider>().searchHotels(search);
                    setState(() {});
                  },
                  onLongPress: () {
                    HapticFeedback.mediumImpact();
                    _showRemoveDialog(search);
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
                  HapticFeedback.selectionClick();
                  _searchController.text = destination;
                  _addRecentSearch(destination);
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
    return EmptyState.noSearchResults(
      onClear: () {
        _searchController.clear();
        context.read<HotelProvider>().searchHotels('');
        setState(() {});
      },
    );
  }

  void _showRemoveDialog(String search) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from history?'),
        content: Text('Remove "$search" from your recent searches?'),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _removeRecentSearch(search);
              Navigator.pop(context);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
