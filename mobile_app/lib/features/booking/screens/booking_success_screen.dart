import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../providers/booking_provider.dart';

class BookingSuccessScreen extends StatefulWidget {
  const BookingSuccessScreen({super.key});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    
    // Haptic feedback on success
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final booking = provider.currentBooking;
        final dateFormat = DateFormat('EEE, MMM d, yyyy');

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.buttonShadow,
                          ),
                          child: const Icon(
                            Iconsax.tick_circle5,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  AppSpacing.vGapXxl,
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Booking Confirmed!',
                          style: AppTypography.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vGapMd,
                        Text(
                          'Your reservation has been successfully made.\nWe\'ve sent the details to your email.',
                          style: AppTypography.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapXxxl,
                  if (booking != null)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: AppSpacing.borderRadiusXl,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: AppSpacing.borderRadiusMd,
                                  child: Image.network(
                                    booking.hotel.images.first,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                AppSpacing.hGapMd,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                            AppSpacing.vGapLg,
                            const Divider(),
                            AppSpacing.vGapLg,
                            _buildInfoRow(
                              Iconsax.calendar,
                              'Check-in',
                              dateFormat.format(booking.checkIn),
                            ),
                            AppSpacing.vGapMd,
                            _buildInfoRow(
                              Iconsax.calendar_1,
                              'Check-out',
                              dateFormat.format(booking.checkOut),
                            ),
                            AppSpacing.vGapMd,
                            _buildInfoRow(
                              Iconsax.user,
                              'Guests',
                              '${booking.guests} Guest${booking.guests > 1 ? 's' : ''}',
                            ),
                            AppSpacing.vGapMd,
                            _buildInfoRow(
                              Iconsax.receipt,
                              'Booking ID',
                              booking.id.substring(0, 12).toUpperCase(),
                            ),
                            AppSpacing.vGapLg,
                            const Divider(),
                            AppSpacing.vGapLg,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Paid',
                                  style: AppTypography.titleMedium,
                                ),
                                Text(
                                  '\$${booking.totalPrice.toInt()}',
                                  style: AppTypography.price,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        CustomButton(
                          text: 'View My Bookings',
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            provider.clearBookingData();
                            // Navigate to MainScreen with Bookings tab (index 2)
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/main',
                              (route) => false,
                              arguments: 2,
                            );
                          },
                          icon: Iconsax.receipt_2,
                        ),
                        AppSpacing.vGapMd,
                        CustomButton(
                          text: 'Back to Home',
                          variant: ButtonVariant.outline,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            provider.clearBookingData();
                            // Navigate to MainScreen with Home tab (index 0)
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/main',
                              (route) => false,
                              arguments: 0,
                            );
                          },
                          icon: Iconsax.home,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapXxl,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        AppSpacing.hGapMd,
        Text(
          label,
          style: AppTypography.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.labelLarge,
        ),
      ],
    );
  }
}
