part of "../api_client.dart";

/// [ExceptionHandler] is responsible for interpreting and converting
/// API and network errors into application-level exceptions.
class ExceptionHandler {
  // Private constructor to prevent instantiation.
  ExceptionHandler._();

  /// [handleErrorStatus] converts a Dio [Response] with an error HTTP status
  /// into a specific [AppException] based on the status code.
  ///
  /// Throws appropriate exceptions like [BadRequestException], [UnauthorizedException], etc.
  /// Returns a [ServerException] for generic server errors (2xx edge cases).
  static Exception handleErrorStatus(Response<dynamic> response) {
    final int? statusCode = response.statusCode;

    // Handle case when no status code is returned.
    if (statusCode == null) {
      throw const UnknownException(message: "No status code returned");
    }

    // Map HTTP status codes to appropriate exceptions.
    switch (statusCode) {
      case 400:
        throw BadRequestException(
          message: "Bad request",
          statusCode: statusCode,
          response: response.data,
        );
      case 401:
        throw UnauthorizedException(
          message: "Unauthorized access",
          statusCode: statusCode,
          response: response.data,
        );
      case 403:
        throw ForbiddenException(
          message: "Forbidden",
          statusCode: statusCode,
          response: response.data,
        );
      case 404:
        throw NotFoundException(
          message: "Resource not found",
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: "Server error",
          statusCode: statusCode,
          response: response.data,
        );
      default:
        if (statusCode < 200 || statusCode >= 499) {
          throw UnknownException(message: "Unexpected error: $statusCode");
        } else {
          return ServerException(
            message: "Server Exception",
            statusCode: statusCode,
            response: response.data,
          );
        }
    }
  }

  /// [handleDioError] analyzes a [DioException] and maps it to a custom [AppException].
  ///
  /// Handles:
  /// - Network and timeout errors as [NetworkException]
  /// - Dio responses with status codes as specific exceptions
  /// - Unknown or unhandled errors as [UnknownException]
  static Exception handleDioError(DioException error) {
    // Handle internet-related exceptions.
    if (error.error is SocketException ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkException(message: "No internet connection");
    }

    // Handle timeout-related exceptions.
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkException(message: "Connection timeout");
    }

    final Response<dynamic>? response = error.response;
    final int? statusCode = response?.statusCode;

    // Handle unknown server error when status code is absent.
    if (statusCode == null) {
      return const UnknownException(
        message: "Unknown server error with no status code",
      );
    }

    // Map HTTP status codes to appropriate exceptions.
    switch (statusCode) {
      case 400:
        final String? message =
            (response?.data as Map<String, dynamic>?)?['message'] as String?;
        throw BadRequestException(
          message: message ?? "Bad Request",
          statusCode: statusCode,
          response: response?.data,
        );
      case 401:
        final String? message =
            (response?.data as Map<String, dynamic>?)?['message'] as String?;
        throw UnauthorizedException(
          message: message ?? "Unauthorized access",
          statusCode: statusCode,
          response: response?.data,
        );
      case 403:
        final String? message =
            (response?.data as Map<String, dynamic>?)?['message'] as String?;
        throw ForbiddenException(
          message: message ?? "Forbidden",
          statusCode: statusCode,
          response: response?.data,
        );
      case 404:
        final String? message =
            (response?.data as Map<String, dynamic>?)?['message'] as String?;
        throw NotFoundException(
          message: message ?? "Resource not found",
          statusCode: statusCode,
        );
      case 409:
        final String? message =
            (response?.data as Map<String, dynamic>?)?['message'] as String?;
        throw NotFoundException(
          message: message ?? "Conflict Error",
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(
          message: "Server error occurred",
          statusCode: statusCode,
          response: response?.data,
        );
      default:
        if (statusCode < 200 || statusCode >= 300) {
          return UnknownException(
            message: "Unexpected status statusCode: $statusCode",
          );
        }
        return ServerException(
          message: "Server error occurred",
          statusCode: statusCode,
          response: response?.data,
        );
    }
  }

  static String errorMessage(dynamic e) {
    if (e is ServerException) {
      return e.message;
    } else if (e is NetworkException) {
      return e.message;
    } else if (e is UnknownException) {
      return e.message;
    } else if (e is BadRequestException) {
      return e.message;
    } else if (e is UnauthorizedException) {
      return e.message;
    } else if (e is ForbiddenException) {
      return e.message;
    } else if (e is NotFoundException) {
      return e.message;
    } else if (e is TypeException) {
      return e.message;
    } else if (e is TokenException) {
      return e.message;
    } else if (e is ValidationException) {
      return e.message;
    } else if (e is LocalStorageException) {
      return e.message;
    } else if (e is AuthException) {
      return e.message;
    } else if (e is Exception) {
      return e.toString();
    } else {
      return "An unexpected error occurred";
    }
  }

  static AppException handleException(dynamic e) {
    if (e is ServerException) {
      return e;
    } else if (e is NetworkException) {
      return e;
    } else if (e is UnknownException) {
      return e;
    } else if (e is BadRequestException) {
      return e;
    } else if (e is UnauthorizedException) {
      return e;
    } else if (e is ForbiddenException) {
      return e;
    } else if (e is NotFoundException) {
      return e;
    } else if (e is TypeException) {
      return e;
    } else if (e is TokenException) {
      return e;
    } else if (e is ValidationException) {
      return e;
    } else if (e is LocalStorageException) {
      return e;
    } else if (e is AuthException) {
      return e;
    } else if (e is Exception) {
      return UnknownException(message: e.toString());
    } else {
      return const UnknownException(message: "An unexpected error occurred");
    }
  }
}
