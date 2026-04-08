class LoginResponseModel {
  final String? message;
  final Map<String, dynamic>? user;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  LoginResponseModel({
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ??
          (json['accessToken'] != null ? 'Login successful' : 'Login failed'),
      user: json['user'] ?? {},
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }
}
