import 'package:digihealth/core/error/failure.dart';
import 'package:dio/dio.dart';

class ErrorHandle {
  ErrorHandle._();
  static Failure handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(
            'No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure('Unauthorized. Please log in again.');
        }
        if (statusCode == 404) {
          return ServerFailure('Requested resource not found.',
              statusCode: 404);
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerFailure('Server is down. Please try again later.',
              statusCode: statusCode);
        }

        return ServerFailure(
            error.response?.data['message'] ??
                'An unexpected server error occurred.',
            statusCode: statusCode);
      case DioExceptionType.cancel:
        return NetworkFailure('Request was cancelled. Please try again.');
      default:
        return UnknownFailure('An unknown error occurred. Please try again.');
    }
  }
}
