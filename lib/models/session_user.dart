class SessionUser {
  const SessionUser({
    required this.id,
    this.email,
    this.username,
  });

  final int id;
  final String? email;
  final String? username;
}
