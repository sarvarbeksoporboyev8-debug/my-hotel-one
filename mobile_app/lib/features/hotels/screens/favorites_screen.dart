import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../providers/hotel_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HotelProvider>().loadFavorites();
    });
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
        title: const Text('Saved Hotels'),
      ),
      body: Consumer<HotelProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: AppSpacing.lg),
              child: HotelListSkeleton(itemCount: 3),
            );
          }

          final favorites = provider.favorites;

          if (favorites.isEmpty) {
            return EmptyState.noFavorites(
              onExplore: () => Navigator.pop(context),
            );
          }

          return ListView.builder(
            padding: AppSpacing.screenPadding,
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final hotel = favorites[index];
              return HotelCard(
                hotel: hotel,
                onTap: () {
                  provider.selectHotel(hotel.id);
                  Navigator.pushNamed(context, '/hotel-details');
                },
                onFavorite: () {
                  HapticFeedback.lightImpact();
                  provider.toggleFavorite(hotel.id);
                  // Reload favorites to update the list
                  provider.loadFavorites();
                },
              );
            },
          );
        },
      ),
    );
  }

}
