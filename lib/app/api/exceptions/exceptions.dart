/// [AppException] Exceptions for the data layer
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic response;

  const AppException({required this.message, this.statusCode, this.response});

  @override
  String toString() => 'AppException: $message (code: $statusCode)';
}

/// [ServerException] represents server-side errors (5xx status codes).
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode, super.response,});
}

/// [NetworkException] represents connectivity issues such as no internet
/// or timeouts (e.g., `SocketException`, timeout errors).
class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

/// [UnknownException] represents errors that are unexpected or undefined,
/// often when there's no status code or error type available.
class UnknownException extends AppException {
  const UnknownException({required super.message, super.statusCode});
}

/// [BadRequestException] represents 400-level errors where the request
/// sent to the server was invalid (e.g., validation failed).
class BadRequestException extends AppException {
  const BadRequestException({required super.message, super.statusCode, super.response,});
}

/// [UnauthorizedException] represents 401 errors indicating the user is not authenticated.
class UnauthorizedException extends AppException {
  const UnauthorizedException({required super.message, super.statusCode,
    super.response,
  });
}

/// [ForbiddenException] represents 403 errors where the user is authenticated
/// but not authorized to access the resource.
class ForbiddenException extends AppException {
  const ForbiddenException({required super.message, super.statusCode,
    super.response,
  });
}

/// [NotFoundException] represents 404 errors when a resource could not be found.
class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.statusCode});
}

/// [TypeException] is used when there's a mismatch or unexpected type during runtime,
class TypeException extends AppException {
  const TypeException({required super.message, super.statusCode});
}

/// [TokenException] is used when there's a mismatch or unexpected type during runtime,
class TokenException extends AppException {
  const TokenException({required super.message, super.statusCode});
}

/// [ValidationException] is used when there's a mismatch or unexpected type during runtime,
class ValidationException extends AppException {
  ValidationException({required super.message, super.statusCode});
}
/// [LocalStorageException] is used when there's a mismatch or unexpected type during runtime,
class LocalStorageException extends AppException {
  const LocalStorageException({required super.message, super.statusCode});
}
/// [AuthException] is used when there's a mismatch or unexpected type during runtime,
class AuthException extends AppException {
  const AuthException({required super.message, super.statusCode,
    super.response,
  });
}
