import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../hotels/providers/hotel_provider.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    final bookingProvider = context.read<BookingProvider>();
    final hotelProvider = context.read<HotelProvider>();
    
    // Set default dates
    if (bookingProvider.checkIn == null) {
      bookingProvider.setCheckIn(DateTime.now().add(const Duration(days: 1)));
    }
    if (bookingProvider.checkOut == null) {
      bookingProvider.setCheckOut(DateTime.now().add(const Duration(days: 3)));
    }
    
    // Set first room if not selected
    if (bookingProvider.selectedRoom == null && hotelProvider.rooms.isNotEmpty) {
      bookingProvider.selectRoom(hotelProvider.rooms.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HotelProvider, BookingProvider>(
      builder: (context, hotelProvider, bookingProvider, child) {
        final hotel = hotelProvider.selectedHotel;

        if (hotel == null) {
          return const Scaffold(
            body: Center(child: Text('No hotel selected')),
          );
        }

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
            title: const Text('Book Your Stay'),
          ),
          body: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHotelSummary(hotel),
                AppSpacing.vGapXxl,
                _buildDateSelection(bookingProvider),
                AppSpacing.vGapXxl,
                _buildGuestSelection(bookingProvider),
                AppSpacing.vGapXxl,
                _buildRoomSelection(hotelProvider.rooms, bookingProvider),
                AppSpacing.vGapXxl,
                _buildPriceSummary(bookingProvider),
                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(hotel, bookingProvider),
        );
      },
    );
  }

  Widget _buildHotelSummary(hotel) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusMd,
            child: Image.network(
              hotel.images.first,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: AppTypography.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.vGapXs,
                Row(
                  children: [
                    Icon(Iconsax.location, size: 14, color: AppColors.textTertiary),
                    AppSpacing.hGapXs,
                    Expanded(
                      child: Text(
                        hotel.city,
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapXs,
                Row(
                  children: [
                    Icon(Iconsax.star1, size: 14, color: AppColors.rating),
                    AppSpacing.hGapXs,
                    Text(
                      '${hotel.rating} (${hotel.reviewCount} reviews)',
                      style: AppTypography.labelSmall,
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

  Widget _buildDateSelection(BookingProvider provider) {
    final dateFormat = DateFormat('EEE, MMM d');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Dates',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        Row(
          children: [
            Expanded(
              child: _DateCard(
                label: 'Check-in',
                date: provider.checkIn,
                icon: Iconsax.login,
                onTap: () => _selectDate(context, true, provider),
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: _DateCard(
                label: 'Check-out',
                date: provider.checkOut,
                icon: Iconsax.logout,
                onTap: () => _selectDate(context, false, provider),
              ),
            ),
          ],
        ),
        if (provider.nights > 0) ...[
          AppSpacing.vGapMd,
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.moon, size: 18, color: AppColors.primary),
                AppSpacing.hGapSm,
                Text(
                  '${provider.nights} night${provider.nights > 1 ? 's' : ''}',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn, BookingProvider provider) async {
    final initialDate = isCheckIn
        ? provider.checkIn ?? DateTime.now().add(const Duration(days: 1))
        : provider.checkOut ?? DateTime.now().add(const Duration(days: 3));

    final firstDate = isCheckIn
        ? DateTime.now()
        : provider.checkIn?.add(const Duration(days: 1)) ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      if (isCheckIn) {
        provider.setCheckIn(date);
      } else {
        provider.setCheckOut(date);
      }
    }
  }

  Widget _buildGuestSelection(BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guests',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Row(
            children: [
              Icon(Iconsax.user, color: AppColors.textSecondary),
              AppSpacing.hGapMd,
              Expanded(
                child: Text(
                  '${provider.guests} Guest${provider.guests > 1 ? 's' : ''}',
                  style: AppTypography.titleMedium,
                ),
              ),
              _CounterButton(
                icon: Iconsax.minus,
                onTap: provider.guests > 1
                    ? () => provider.setGuests(provider.guests - 1)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  '${provider.guests}',
                  style: AppTypography.headlineSmall,
                ),
              ),
              _CounterButton(
                icon: Iconsax.add,
                onTap: provider.guests < 10
                    ? () => provider.setGuests(provider.guests + 1)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoomSelection(List rooms, BookingProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Room',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        ...rooms.map((room) {
          final isSelected = provider.selectedRoom?.id == room.id;
          return GestureDetector(
            onTap: () => provider.selectRoom(room),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primarySurface : AppColors.surface,
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.textTertiary,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: AppTypography.titleMedium,
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          '${room.maxGuests} guests • ${room.size.toInt()} m² • ${room.bedType}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPriceSummary(BookingProvider provider) {
    if (provider.selectedRoom == null || provider.nights == 0) {
      return const SizedBox.shrink();
    }

    final roomPrice = provider.selectedRoom!.pricePerNight * provider.nights;
    final taxes = roomPrice * 0.12;
    final total = roomPrice + taxes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Summary',
          style: AppTypography.headlineSmall,
        ),
        AppSpacing.vGapMd,
        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Column(
            children: [
              _PriceRow(
                label: '${provider.selectedRoom!.name} x ${provider.nights} nights',
                value: '\$${roomPrice.toInt()}',
              ),
              AppSpacing.vGapMd,
              _PriceRow(
                label: 'Taxes & Fees',
                value: '\$${taxes.toInt()}',
              ),
              AppSpacing.vGapMd,
              const Divider(),
              AppSpacing.vGapMd,
              _PriceRow(
                label: 'Total',
                value: '\$${total.toInt()}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(hotel, BookingProvider provider) {
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
        child: CustomButton(
          text: 'Confirm Booking',
          onPressed: provider.selectedRoom != null && provider.nights > 0
              ? () async {
                  final success = await provider.createBooking(hotel);
                  if (success && mounted) {
                    Navigator.pushReplacementNamed(context, '/booking-success');
                  }
                }
              : null,
          isLoading: provider.isLoading,
          icon: Iconsax.tick_circle,
          iconOnRight: true,
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final VoidCallback onTap;

  const _DateCard({
    required this.label,
    required this.date,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textTertiary),
                AppSpacing.hGapSm,
                Text(
                  label,
                  style: AppTypography.labelMedium,
                ),
              ],
            ),
            AppSpacing.vGapSm,
            Text(
              date != null ? dateFormat.format(date!) : 'Select date',
              style: AppTypography.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? Colors.white : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? AppTypography.titleMedium : AppTypography.bodyMedium,
        ),
        Text(
          value,
          style: isTotal ? AppTypography.price : AppTypography.titleMedium,
        ),
      ],
    );
  }
}
