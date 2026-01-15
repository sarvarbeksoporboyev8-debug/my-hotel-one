import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: AppTypography.labelLarge.copyWith(
                  color: _isFocused
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              AppSpacing.vGapSm,
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: AppSpacing.borderRadiusMd,
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isFocused = hasFocus;
                    });
                    if (hasFocus) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  },
                  child: TextFormField(
                    controller: widget.controller,
                    obscureText: widget.isPassword && _obscureText,
                    keyboardType: widget.keyboardType,
                    validator: widget.validator,
                    enabled: widget.enabled,
                    maxLines: widget.isPassword ? 1 : widget.maxLines,
                    textInputAction: widget.textInputAction,
                    onFieldSubmitted: widget.onSubmitted,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      prefixIcon: widget.prefixIcon != null
                          ? Icon(
                              widget.prefixIcon,
                              color: _isFocused
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                              size: 22,
                            )
                          : null,
                      suffixIcon: widget.isPassword
                          ? IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                color: AppColors.textTertiary,
                                size: 22,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            )
                          : null,
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
}
