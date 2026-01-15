import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../auth/providers/auth_provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    
    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final user = context.read<AuthProvider>().user;
    final hasChanges = _nameController.text != (user?.name ?? '') ||
        _emailController.text != (user?.email ?? '') ||
        _phoneController.text != (user?.phone ?? '');
    
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty 
          ? null 
          : _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.tick_circle, color: Colors.white, size: 20),
              AppSpacing.hGapMd,
              Text(
                'Profile updated successfully',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
          margin: AppSpacing.screenPadding,
        ),
      );
      setState(() {
        _hasChanges = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.warning_2, color: Colors.white, size: 20),
              AppSpacing.hGapMd,
              Text(
                authProvider.error ?? 'Failed to update profile',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
          margin: AppSpacing.screenPadding,
        ),
      );
    }
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
        title: const Text('Personal Information'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.vGapLg,
                  _buildAvatarSection(authProvider),
                  AppSpacing.vGapXxxl,
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Iconsax.user,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.vGapXl,
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'Enter your email',
                    prefixIcon: Iconsax.sms,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.vGapXl,
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Phone Number (Optional)',
                    hint: 'Enter your phone number',
                    prefixIcon: Iconsax.call,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _hasChanges ? _saveChanges() : null,
                  ),
                  AppSpacing.vGapXxxl,
                  AnimatedOpacity(
                    opacity: _hasChanges ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: CustomButton(
                      text: 'Save Changes',
                      onPressed: _hasChanges ? _saveChanges : null,
                      isLoading: authProvider.isLoading,
                      icon: Iconsax.tick_circle,
                      iconOnRight: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection(AuthProvider authProvider) {
    final user = authProvider.user;
    
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 3,
                  ),
                  image: user?.avatar != null
                      ? DecorationImage(
                          image: NetworkImage(user!.avatar!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: user?.avatar == null
                    ? Center(
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name.substring(0, 1).toUpperCase()
                              : 'U',
                          style: AppTypography.displayMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // Photo picker would go here
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Photo upload coming soon',
                          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
                        margin: AppSpacing.screenPadding,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Iconsax.camera,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vGapMd,
          Text(
            'Tap to change photo',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
