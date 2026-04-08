import 'package:digihealth/features/authentication/presentation/screen/auth_screen.dart';
import 'package:digihealth/features/authentication/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(
      authNotifierProvider,
      (_, __) => notifyListeners(),
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  return GoRouter(
      refreshListenable: notifier,
      initialLocation: '/auth',
      redirect: (context, state) {
        final authStatus = ref.read(authNotifierProvider);
        final isLoggingIn = state.matchedLocation == '/auth';
        if (authStatus == AuthStatus.unknown ||
            authStatus == AuthStatus.loading) {
          return null;
        }
        if (authStatus == AuthStatus.unauthenticated && !isLoggingIn) {
          return '/auth';
        }
        if (authStatus == AuthStatus.authenticated && isLoggingIn) {
          return '/dashboard';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const AuthScreen(),
        ),
      ]);
});
