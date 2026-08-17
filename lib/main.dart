import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/goal_repository.dart';
import 'data/repositories/reflection_repository.dart';
import 'ui/core/theme/app_colors.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/core/theme/app_typography.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/auth/views/login_view.dart';
import 'ui/features/creation/views/create_goal_sheet.dart';
import 'ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'ui/features/dashboard/views/dashboard_view.dart';
import 'ui/features/goal_detail/view_models/goal_detail_view_model.dart';
import 'ui/features/goal_detail/views/goal_detail_view.dart';
import 'ui/features/profile/views/profile_sheet.dart';
import 'ui/features/reflection/view_models/reflection_view_model.dart';
import 'ui/features/reflection/views/reflection_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const AchieveApp());
}

class AchieveApp extends StatelessWidget {
  const AchieveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IAuthRepository>(create: (_) => AuthRepository()),
        Provider<IGoalRepository>(create: (_) => GoalRepository()),
        Provider<IReflectionRepository>(create: (_) => ReflectionRepository()),
      ],
      child: MaterialApp(
        title: 'Achieve',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late AuthViewModel _authViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authRepo = Provider.of<IAuthRepository>(context, listen: false);
    _authViewModel = AuthViewModel(authRepository: authRepo);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authViewModel,
      builder: (context, _) {
        if (!_authViewModel.isAuthenticated) {
          return LoginView(viewModel: _authViewModel);
        }
        return AppRootNavigation(authViewModel: _authViewModel);
      },
    );
  }
}

class AppRootNavigation extends StatefulWidget {
  final AuthViewModel authViewModel;

  const AppRootNavigation({super.key, required this.authViewModel});

  @override
  State<AppRootNavigation> createState() => _AppRootNavigationState();
}

class _AppRootNavigationState extends State<AppRootNavigation> {
  int _currentIndex = 0;
  String? _selectedGoalId;

  late DashboardViewModel _dashboardViewModel;
  late ReflectionViewModel _reflectionViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final goalRepo = Provider.of<IGoalRepository>(context, listen: false);
    final reflRepo = Provider.of<IReflectionRepository>(context, listen: false);

    final currentUserId = widget.authViewModel.currentUser?.id ?? 'demo-user';
    final isDemo = widget.authViewModel.currentUser?.isGuest ?? (currentUserId == 'demo-user');
    goalRepo.setActiveUser(currentUserId, isDemo: isDemo);

    _dashboardViewModel = DashboardViewModel(repository: goalRepo);
    _reflectionViewModel = ReflectionViewModel(
      reflectionRepository: reflRepo,
      goalRepository: goalRepo,
    );
  }

  void _openCreateGoalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateGoalSheet(
        onGoalCreated: (newGoal) async {
          final goalRepo = Provider.of<IGoalRepository>(context, listen: false);
          await goalRepo.saveGoal(newGoal);
          await _dashboardViewModel.loadDashboard();
          await _reflectionViewModel.loadReflectionData();
        },
      ),
    );
  }

  void _openProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfileSheet(
        authViewModel: widget.authViewModel,
        dashboardViewModel: _dashboardViewModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedGoalId != null) {
      final goalRepo = Provider.of<IGoalRepository>(context, listen: false);
      return GoalDetailView(
        viewModel: GoalDetailViewModel(
          repository: goalRepo,
          goalId: _selectedGoalId!,
        ),
        onBack: () {
          setState(() => _selectedGoalId = null);
          _dashboardViewModel.loadDashboard();
        },
      );
    }

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardView(
            viewModel: _dashboardViewModel,
            onGoalSelected: (goal) {
              setState(() => _selectedGoalId = goal.id);
            },
            onNewGoalTap: _openCreateGoalSheet,
            onProfileTap: _openProfileSheet,
          ),
          ReflectionView(
            viewModel: _reflectionViewModel,
          ),
        ],
      ),
      bottomNavigationBar: _buildFrostedBottomNav(),
    );
  }

  Widget _buildFrostedBottomNav() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.canvas.withOpacity(0.85),
            border: const Border(
              top: BorderSide(color: AppColors.hairline, width: 0.8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.check_circle_outline,
                activeIcon: Icons.check_circle,
                label: 'Today',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.insights_outlined,
                activeIcon: Icons.insights,
                label: 'Reflection',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.textMuted;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _selectedGoalId = null;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.micro.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
