import '../../domain/models/user.dart';

abstract class IAuthRepository {
  Future<User?> getCurrentUser();
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<User> continueAsGuest();
  Future<void> logout();
}

class AuthRepository implements IAuthRepository {
  User? _currentUser;

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = User(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first.replaceFirst(
          email[0], email[0].toUpperCase()),
      email: email,
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: false,
    );
    return _currentUser!;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 450));
    _currentUser = User(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: false,
    );
    return _currentUser!;
  }

  @override
  Future<User> continueAsGuest() async {
    _currentUser = User.guest();
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
