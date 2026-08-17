import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/apple_pill_button.dart';
import '../../../core/widgets/responsive_container.dart';
import '../view_models/auth_view_model.dart';

class RegisterView extends StatefulWidget {
  final AuthViewModel viewModel;

  const RegisterView({
    super.key,
    required this.viewModel,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final success = await widget.viewModel.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ResponsiveContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Create Account', style: AppTypography.heroDisplay),
                      const SizedBox(height: 6),
                      Text(
                        'Start tracking your personal milestones today.',
                        style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 28),

                      AppleCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.viewModel.errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.statusBehind.withOpacity(0.1),
                                  borderRadius: AppRadius.roundedSm,
                                ),
                                child: Text(
                                  widget.viewModel.errorMessage!,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.statusBehind,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Your Full Name',
                                prefixIcon: const Icon(Icons.person_outline, size: 18),
                                filled: true,
                                fillColor: AppColors.canvasParchment,
                                border: OutlineInputBorder(
                                  borderRadius: AppRadius.roundedSm,
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: const Icon(Icons.mail_outline, size: 18),
                                filled: true,
                                fillColor: AppColors.canvasParchment,
                                border: OutlineInputBorder(
                                  borderRadius: AppRadius.roundedSm,
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, size: 18),
                                filled: true,
                                fillColor: AppColors.canvasParchment,
                                border: OutlineInputBorder(
                                  borderRadius: AppRadius.roundedSm,
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              child: ApplePillButton(
                                text: widget.viewModel.isLoading
                                    ? 'Creating Account...'
                                    : 'Create Account',
                                onPressed: widget.viewModel.isLoading
                                    ? null
                                    : _handleRegister,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
