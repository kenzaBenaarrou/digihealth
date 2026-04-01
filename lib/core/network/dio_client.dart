import 'package:digihealth/core/network/retry_interception.dart';
import 'package:digihealth/features/authentication/data/auth_local_datasource.dart';
import 'package:digihealth/features/authentication/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  dio.interceptors.addAll([
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // You can add authorization headers or other custom logic here
        final token = await ref.read(authLocalDataSourceProvider).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          ref.read(authNotifierProvider.notifier).logout();
        }
        return handler.next(e);
      },
    ),
    RetryInterceptor(dio),
  ]);
  return dio;
});
