import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';
import '../providers/hotel_provider.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({super.key});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HotelProvider>(
      builder: (context, provider, child) {
        final hotel = provider.selectedHotel;

        if (hotel == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildImageGallery(hotel, provider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(hotel, provider),
                      AppSpacing.vGapXxl,
                      _buildDescription(hotel),
                      AppSpacing.vGapXxl,
                      _buildAmenities(hotel),
                      AppSpacing.vGapXxl,
                      _buildRooms(provider.rooms),
                      AppSpacing.vGapXxl,
                      _buildReviews(provider.reviews, hotel),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(hotel),
        );
      },
    );
  }

  Widget _buildImageGallery(Hotel hotel, HotelProvider provider) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppColors.softShadow,
            ),
            child: const Icon(Iconsax.arrow_left, color: AppColors.textPrimary),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => provider.toggleFavorite(hotel.id),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.softShadow,
              ),
              child: Icon(
                hotel.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                color: hotel.isFavorite ? AppColors.error : AppColors.textPrimary,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.softShadow,
              ),
              child: const Icon(Iconsax.share, color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: hotel.images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: hotel.images[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: hotel.images.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Hotel hotel, HotelProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.vGapLg,
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
            Icon(Iconsax.star1, size: 18, color: AppColors.rating),
            AppSpacing.hGapXs,
            Text(
              hotel.rating.toString(),
              style: AppTypography.titleMedium,
            ),
            Text(
              ' (${hotel.reviewCount} reviews)',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
        AppSpacing.vGapMd,
        Text(
          hotel.name,
          style: AppTypography.displaySmall,
        ),
        AppSpacing.vGapSm,
        Row(
          children: [
            Icon(Iconsax.location, size: 16, color: AppColors.textTertiary),
            AppSpacing.hGapXs,
            Expanded(
              child: Text(
                '${hotel.address}, ${hotel.city}, ${hotel.country}',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(Hotel hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        Text(
          hotel.description,
          style: AppTypography.bodyMedium.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildAmenities(Hotel hotel) {
    final amenityIcons = {
      'Free WiFi': Iconsax.wifi,
      'Pool': Iconsax.drop,
      'Spa': Iconsax.lovely,
      'Gym': Iconsax.weight,
      'Restaurant': Iconsax.reserve,
      'Bar': Iconsax.coffee,
      'Room Service': Iconsax.box,
      'Parking': Iconsax.car,
      'Beach Access': Iconsax.sun_1,
      'Water Sports': Iconsax.ship,
      'Business Center': Iconsax.briefcase,
      'Concierge': Iconsax.user,
      'Fireplace': Iconsax.flash,
      'Ski Storage': Iconsax.box_1,
      'Hot Tub': Iconsax.drop,
      'Hiking': Iconsax.routing,
      'Butler Service': Iconsax.user_tick,
      'Fine Dining': Iconsax.reserve,
      'Library': Iconsax.book,
      'Garden': Iconsax.tree,
      'Valet': Iconsax.car,
      'Breakfast': Iconsax.coffee,
      'Laundry': Iconsax.box_tick,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: hotel.amenities.map((amenity) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    amenityIcons[amenity] ?? Iconsax.tick_circle,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  AppSpacing.hGapSm,
                  Text(
                    amenity,
                    style: AppTypography.labelMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRooms(List<Room> rooms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Rooms',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        ...rooms.map((room) => _RoomCard(
          room: room,
          onSelect: () {
            Navigator.pushNamed(context, '/booking', arguments: room);
          },
        )),
      ],
    );
  }

  Widget _buildReviews(List<Review> reviews, Hotel hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: AppTypography.headlineSmall,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vGapMd,
        ...reviews.take(3).map((review) => _ReviewCard(review: review)),
      ],
    );
  }

  Widget _buildBottomBar(Hotel hotel) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: AppTypography.bodySmall,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
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
            AppSpacing.hGapXxl,
            Expanded(
              child: CustomButton(
                text: 'Book Now',
                onPressed: () {
                  Navigator.pushNamed(context, '/booking');
                },
                icon: Iconsax.calendar_tick,
                iconOnRight: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onSelect;

  const _RoomCard({
    required this.room,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
            child: CachedNetworkImage(
              imageUrl: room.images.first,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: AppSpacing.cardPaddingSmall,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: AppTypography.titleLarge,
                ),
                AppSpacing.vGapSm,
                Row(
                  children: [
                    _buildRoomInfo(Iconsax.user, '${room.maxGuests} Guests'),
                    AppSpacing.hGapLg,
                    _buildRoomInfo(Iconsax.ruler, '${room.size.toInt()} m²'),
                    AppSpacing.hGapLg,
                    _buildRoomInfo(Iconsax.lamp, room.bedType),
                  ],
                ),
                AppSpacing.vGapMd,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${room.pricePerNight.toInt()}',
                          style: AppTypography.priceSmall,
                        ),
                        Text(
                          '/night',
                          style: AppTypography.labelSmall,
                        ),
                      ],
                    ),
                    CustomButton(
                      text: 'Select',
                      onPressed: onSelect,
                      size: ButtonSize.small,
                      isFullWidth: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        AppSpacing.hGapXs,
        Text(text, style: AppTypography.labelSmall),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(review.userAvatar),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTypography.titleMedium,
                    ),
                    Text(
                      _formatDate(review.date),
                      style: AppTypography.labelSmall,
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: review.rating,
                itemBuilder: (context, _) => const Icon(
                  Iconsax.star1,
                  color: AppColors.rating,
                ),
                itemCount: 5,
                itemSize: 14,
              ),
            ],
          ),
          AppSpacing.vGapMd,
          Text(
            review.comment,
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    if (diff < 30) return '${diff ~/ 7} weeks ago';
    return '${diff ~/ 30} months ago';
  }
}
