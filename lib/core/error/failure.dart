sealed class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  ServerFailure(super.message, {this.statusCode});
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
