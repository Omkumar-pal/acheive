import 'package:flutter/foundation.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../domain/models/user.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({required IAuthRepository authRepository})
      : _authRepository = authRepository {
    _checkCurrentUser();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _checkCurrentUser() async {
    _currentUser = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.trim().isEmpty || password.trim().isEmpty) {
        throw Exception('Please enter email and password.');
      }
      _currentUser = await _authRepository.login(email.trim(), password);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
        throw Exception('Please fill in all fields.');
      }
      _currentUser = await _authRepository.register(
        name.trim(),
        email.trim(),
        password,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> continueAsGuest() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _authRepository.continueAsGuest();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }
}
