class LoginRequest {
  LoginRequest({
    this.email,
    this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json['email'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
      };

  final String? email;
  final String? password;
}

class RegisterRequest {
  RegisterRequest({
    this.username,
    this.email,
    this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
        username: json['username'] as String?,
        email: json['email'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'email': email,
        'password': password,
      };

  final String? username;
  final String? email;
  final String? password;
}

class AuthTokenResponse {
  AuthTokenResponse({
    required this.token,
    this.expiresAt,
    this.userId,
    this.email,
    this.username,
  });

  final String token;
  final DateTime? expiresAt;
  final int? userId;
  final String? email;
  final String? username;
}
