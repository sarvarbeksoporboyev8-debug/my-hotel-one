import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum ButtonVariant { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool iconOnRight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.large,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.iconOnRight = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 18);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 18;
      case ButtonSize.large:
        return 20;
    }
  }

  Color get _backgroundColor {
    if (widget.onPressed == null) {
      return AppColors.textTertiary.withOpacity(0.3);
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color get _foregroundColor {
    if (widget.onPressed == null) {
      return AppColors.textTertiary;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.textOnPrimary;
      case ButtonVariant.secondary:
        return AppColors.textOnSecondary;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return AppColors.primary;
    }
  }

  Border? get _border {
    if (widget.variant == ButtonVariant.outline) {
      return Border.all(
        color: widget.onPressed == null
            ? AppColors.textTertiary
            : AppColors.primary,
        width: 1.5,
      );
    }
    return null;
  }

  List<BoxShadow>? get _shadow {
    if (widget.variant == ButtonVariant.primary && widget.onPressed != null) {
      return AppColors.buttonShadow;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.onPressed != null && !widget.isLoading
                ? (_) => _controller.forward()
                : null,
            onTapUp: widget.onPressed != null && !widget.isLoading
                ? (_) => _controller.reverse()
                : null,
            onTapCancel: widget.onPressed != null && !widget.isLoading
                ? () => _controller.reverse()
                : null,
            onTap: widget.isLoading ? null : widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.isFullWidth ? double.infinity : null,
              padding: _padding,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: AppSpacing.borderRadiusMd,
                border: _border,
                boxShadow: _shadow,
              ),
              child: Row(
                mainAxisSize:
                    widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      width: _iconSize,
                      height: _iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _foregroundColor,
                        ),
                      ),
                    )
                  else ...[
                    if (widget.icon != null && !widget.iconOnRight) ...[
                      Icon(
                        widget.icon,
                        size: _iconSize,
                        color: _foregroundColor,
                      ),
                      SizedBox(width: widget.size == ButtonSize.small ? 6 : 8),
                    ],
                    Text(
                      widget.text,
                      style: AppTypography.button.copyWith(
                        fontSize: _fontSize,
                        color: _foregroundColor,
                      ),
                    ),
                    if (widget.icon != null && widget.iconOnRight) ...[
                      SizedBox(width: widget.size == ButtonSize.small ? 6 : 8),
                      Icon(
                        widget.icon,
                        size: _iconSize,
                        color: _foregroundColor,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
