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
    await Future.delayed(const Duration(milliseconds: 300));
    final isDemo = email.toLowerCase().contains('alex') || email.toLowerCase().contains('demo');
    final userId = isDemo ? 'demo-user' : 'usr-${DateTime.now().millisecondsSinceEpoch}';

    _currentUser = User(
      id: userId,
      name: isDemo ? 'Alex Rivera' : email.split('@').first,
      email: email,
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: isDemo,
    );
    return _currentUser!;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final userId = 'usr-${DateTime.now().millisecondsSinceEpoch}';

    _currentUser = User(
      id: userId,
      name: name,
      email: email,
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      isGuest: false,
    );
    return _currentUser!;
  }

  @override
  Future<User> continueAsGuest() async {
    _currentUser = User(
      id: 'demo-user',
      name: 'Guest User',
      email: 'guest@achieve.app',
      isGuest: true,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}
