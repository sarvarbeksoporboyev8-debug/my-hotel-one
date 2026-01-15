import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../data/models/models.dart';
import '../providers/booking_provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: AppTypography.labelLarge,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(provider.bookings, 'upcoming'),
              _buildBookingsList(provider.bookings, 'completed'),
              _buildBookingsList([], 'cancelled'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, String type) {
    final filteredBookings = bookings.where((b) {
      if (type == 'upcoming') {
        return b.checkIn.isAfter(DateTime.now()) && b.status == 'Confirmed';
      } else if (type == 'completed') {
        return b.checkOut.isBefore(DateTime.now()) || b.status == 'Completed';
      } else {
        return b.status == 'Cancelled';
      }
    }).toList();

    if (filteredBookings.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.builder(
      padding: AppSpacing.screenPadding,
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        return _BookingCard(booking: filteredBookings[index]);
      },
    );
  }

  Widget _buildEmptyState(String type) {
    IconData icon;
    String title;
    String subtitle;

    switch (type) {
      case 'upcoming':
        icon = Iconsax.calendar;
        title = 'No upcoming bookings';
        subtitle = 'Your future reservations will appear here';
        break;
      case 'completed':
        icon = Iconsax.tick_circle;
        title = 'No completed bookings';
        subtitle = 'Your past stays will appear here';
        break;
      default:
        icon = Iconsax.close_circle;
        title = 'No cancelled bookings';
        subtitle = 'Cancelled reservations will appear here';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.textTertiary,
            ),
          ),
          AppSpacing.vGapXxl,
          Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.vGapSm,
          Text(
            subtitle,
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusXl,
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppSpacing.borderRadiusMd,
                  child: Image.network(
                    booking.hotel.images.first,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          booking.status,
                          style: AppTypography.labelSmall.copyWith(
                            color: _getStatusColor(booking.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AppSpacing.vGapSm,
                      Text(
                        booking.hotel.name,
                        style: AppTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppSpacing.vGapXs,
                      Text(
                        booking.room.name,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              children: [
                _buildDateInfo(
                  'Check-in',
                  dateFormat.format(booking.checkIn),
                  Iconsax.login,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                ),
                _buildDateInfo(
                  'Check-out',
                  dateFormat.format(booking.checkOut),
                  Iconsax.logout,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${booking.totalPrice.toInt()}',
                      style: AppTypography.priceSmall,
                    ),
                    Text(
                      '${booking.nights} nights',
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

  Widget _buildDateInfo(String label, String date, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        AppSpacing.hGapSm,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall,
            ),
            Text(
              date,
              style: AppTypography.labelLarge,
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }
}
