final class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
    required this.token,
  });

  final String userId;
  final String email;
  final String token;
}
