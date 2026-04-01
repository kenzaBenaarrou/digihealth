import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_provider.g.dart';

enum AuthStatus { authenticated, unauthenticated, loading, error, unknown }

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthStatus build() {
    return AuthStatus.unknown;
  }

  Future<void> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      state = AuthStatus.authenticated;
    } catch (e) {
      state = AuthStatus.error;
    }
  }
  void logout() {
    state = AuthStatus.unauthenticated;
  }
}
