class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? token;
  final bool isGuest;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.token,
    this.isGuest = false,
  });

  factory User.guest() {
    return const User(
      id: 'guest-1',
      name: 'Achiever',
      email: 'guest@achieve.app',
      isGuest: true,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? token,
    bool? isGuest,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      token: token ?? this.token,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
