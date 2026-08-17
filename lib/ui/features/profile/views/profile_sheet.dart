import 'package:flutter/material.dart';
import '../../../../domain/models/user.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_card.dart';
import '../../../core/widgets/apple_pill_button.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../dashboard/view_models/dashboard_view_model.dart';

class ProfileSheet extends StatelessWidget {
  final AuthViewModel authViewModel;
  final DashboardViewModel dashboardViewModel;

  const ProfileSheet({
    super.key,
    required this.authViewModel,
    required this.dashboardViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final user = authViewModel.currentUser;
    final userName = user?.name ?? 'Alex Rivera';
    final userEmail = user?.email ?? 'alex@achieve.app';
    final isGuest = user?.isGuest ?? false;
    final initials = userName.isNotEmpty
        ? userName.split(' ').map((n) => n[0]).take(2).join('').toUpperCase()
        : 'AR';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sheet handle
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.hairline,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 20),

          // User Avatar & Info
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0066CC), Color(0xFF5AC8FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(userName, style: AppTypography.displayMd),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userEmail,
                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
              ),
              if (isGuest) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.canvasParchment,
                    borderRadius: AppRadius.roundedPill,
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Text(
                    'Guest',
                    style: AppTypography.micro.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Account Metrics Card
          AppleCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatTile(
                  '${dashboardViewModel.goals.length}',
                  'Active Goals',
                  '🎯',
                ),
                Container(width: 1, height: 36, color: AppColors.hairline),
                _buildStatTile(
                  '${dashboardViewModel.currentStreak} Days',
                  'Streak',
                  '🔥',
                ),
                Container(width: 1, height: 36, color: AppColors.hairline),
                _buildStatTile(
                  '${dashboardViewModel.completedTodayCount}/${dashboardViewModel.totalTodayCount}',
                  "Today's Done",
                  '⚡',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            child: ApplePillButton(
              text: 'Log Out',
              icon: Icons.logout,
              isSecondary: true,
              onPressed: () async {
                Navigator.pop(context);
                await authViewModel.logout();
              },
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String value, String label, String emoji) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(value, style: AppTypography.bodyStrong.copyWith(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.micro.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
