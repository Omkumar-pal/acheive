import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/apple_pill_button.dart';
import '../../../core/widgets/responsive_container.dart';
import '../view_models/auth_view_model.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  final AuthViewModel viewModel;

  const LoginView({
    super.key,
    required this.viewModel,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController(text: 'alex@achieve.app');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    widget.viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: ResponsiveContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App Icon / Logo
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: AppRadius.roundedLg,
                          border: Border.all(color: AppColors.hairline, width: 1),
                        ),
                        child: const Center(
                          child: Text('🎯', style: TextStyle(fontSize: 34)),
                        ),
                      ),
                      const SizedBox(height: 18),

                      const Text('Achieve', style: AppTypography.heroDisplay),
                      const SizedBox(height: 6),
                      Text(
                        'Turn long-term ambitions into daily momentum.',
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 32),

                      // Login Form Card
                      AppleCard(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sign In', style: AppTypography.tagline),
                            const SizedBox(height: 16),

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
                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              child: ApplePillButton(
                                text: widget.viewModel.isLoading ? 'Signing In...' : 'Sign In',
                                onPressed: widget.viewModel.isLoading ? null : _handleLogin,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Continue as Guest Button
                      ApplePillButton(
                        text: 'Continue as Guest',
                        icon: Icons.person_outline,
                        isSecondary: true,
                        onPressed: () => widget.viewModel.continueAsGuest(),
                      ),
                      const SizedBox(height: 20),

                      // Switch to Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?", style: AppTypography.caption),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegisterView(viewModel: widget.viewModel),
                                ),
                              );
                            },
                            child: Text(
                              'Create One',
                              style: AppTypography.captionStrong.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
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
