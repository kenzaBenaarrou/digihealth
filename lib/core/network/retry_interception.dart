import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;
  RetryInterceptor(this.dio,
      {this.maxRetries = 3, this.retryDelay = const Duration(seconds: 2)});
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on specific errors (timeouts, no internet)
    if (_shouldRetry(err)) {
      int retries = err.requestOptions.extra['retries'] ?? 0;

      if (retries < maxRetries) {
        err.requestOptions.extra['retries'] = retries + 1;

        // Wait before retrying
        await Future.delayed(retryDelay);

        try {
          // Clone the request and try again
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return super.onError(e, handler);
        }
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
