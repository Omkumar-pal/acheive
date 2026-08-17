import '../../domain/models/weekly_reflection.dart';
import 'mock_data.dart';

abstract class IReflectionRepository {
  Future<WeeklyReflection> getLatestReflection();
  Future<void> saveReflection(WeeklyReflection reflection);
}

class ReflectionRepository implements IReflectionRepository {
  WeeklyReflection _latestReflection = MockData.getLatestReflection();

  @override
  Future<WeeklyReflection> getLatestReflection() async {
    return _latestReflection;
  }

  @override
  Future<void> saveReflection(WeeklyReflection reflection) async {
    _latestReflection = reflection;
  }
}
