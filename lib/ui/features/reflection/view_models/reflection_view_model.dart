import 'package:flutter/foundation.dart';
import '../../../../data/repositories/goal_repository.dart';
import '../../../../data/repositories/reflection_repository.dart';
import '../../../../domain/models/consistency_day.dart';
import '../../../../domain/models/goal.dart';
import '../../../../domain/models/weekly_reflection.dart';
import '../../../../domain/use_cases/ai_reflection_service.dart';

class ReflectionViewModel extends ChangeNotifier {
  final IReflectionRepository _reflectionRepository;
  final IGoalRepository _goalRepository;
  final AiReflectionService _aiReflectionService;

  WeeklyReflection? _reflection;
  List<Goal> _goals = [];
  List<ConsistencyDay> _consistencyDays = [];
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isGeneratingAi = false;
  String? _lastAiInsight;

  ReflectionViewModel({
    required IReflectionRepository reflectionRepository,
    required IGoalRepository goalRepository,
    AiReflectionService aiReflectionService = const AiReflectionService(),
  })  : _reflectionRepository = reflectionRepository,
        _goalRepository = goalRepository,
        _aiReflectionService = aiReflectionService {
    loadReflectionData();
  }

  WeeklyReflection? get reflection => _reflection;
  List<Goal> get goals => _goals;
  List<ConsistencyDay> get consistencyDays => _consistencyDays;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isGeneratingAi => _isGeneratingAi;
  String? get lastAiInsight => _lastAiInsight;

  Future<void> loadReflectionData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reflection = await _reflectionRepository.getLatestReflection();
      _goals = await _goalRepository.getGoals();
      _consistencyDays = await _goalRepository.getConsistencyHistory();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateReflection({
    String? whatWentWell,
    String? whatWasDifficult,
    String? nextWeekFocus,
  }) async {
    if (_reflection == null) return;
    _isSaving = true;
    notifyListeners();

    try {
      final updated = _reflection!.copyWith(
        whatWentWell: whatWentWell,
        whatWasDifficult: whatWasDifficult,
        nextWeekFocus: nextWeekFocus,
      );
      await _reflectionRepository.saveReflection(updated);
      _reflection = updated;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> generateWithAi() async {
    if (_reflection == null) return;
    _isGeneratingAi = true;
    notifyListeners();

    try {
      final aiResult = await _aiReflectionService.generateReflection(
        goals: _goals,
        recentDays: _consistencyDays,
        currentReflection: _reflection!,
      );

      _lastAiInsight = aiResult.keyInsight;

      final updated = _reflection!.copyWith(
        whatWentWell: aiResult.whatWentWell,
        whatWasDifficult: aiResult.whatWasDifficult,
        nextWeekFocus: aiResult.nextWeekFocus,
      );

      await _reflectionRepository.saveReflection(updated);
      _reflection = updated;
    } finally {
      _isGeneratingAi = false;
      notifyListeners();
    }
  }
}
