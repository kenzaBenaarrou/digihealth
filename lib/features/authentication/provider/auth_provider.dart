import 'package:digihealth/features/authentication/data/models/user_model.dart';
import 'package:digihealth/features/dashboard/provider/filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repository/auth_repository_impl.dart';
part 'auth_provider.g.dart';

// final authNotifierProvider = NotifierProvider<AuthNotifier,AuthState>(() => AuthNotifier());
class AuthState {
  final String? token;
  final String? errorMessage;
  final AuthStatus status;
  final UserModel? user;

  AuthState({
    this.token,
    this.errorMessage,
    this.status = AuthStatus.unknown,
    this.user,
  });

  AuthState copyWith({
    String? token,
    String? errorMessage,
    AuthStatus? status,
    UserModel? user,
  }) {
    return AuthState(
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

enum AuthStatus { authenticated, unauthenticated, loading, error, unknown }

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final response =
          await ref.read(authRepositoryProvider).login(email, password);
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
          status: AuthStatus.authenticated,
          token: response.accessToken,
          user: UserModel.fromJson(response.user ?? {}));

      // Automatically fetch filter data after successful login
      print('✅ Login successful, fetching filter data...');
      ref.read(filterProvider.notifier).fetchFilterData().then((_) {
        print('✅ Filter data fetched successfully after login');
      }).catchError((error) {
        // Log error but don't fail login if filter fetch fails
        print('⚠️ Warning: Failed to fetch filter data after login: $error');
      });
    } catch (e) {
      state =
          state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

@riverpod
class KeepSessionActive extends _$KeepSessionActive {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}
