/// A utility class for handling HTTP status codes.
class HttpUtil {
  // This class is not meant to be instantiated.
  HttpUtil._();

  // --- Success (2xx) ---
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;

  // --- Client Error (4xx) ---
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int requestTimeout = 408;
  static const int tooManyRequests = 429;

  // --- Server Error (5xx) ---
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;

  // --- Custom Messages ---
  static const String noInternetConnection = "No Internet connection";

  /// Checks if the status code is a success (2xx).
  static bool isSuccess(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  /// Checks if the status code is a client error (4xx).
  static bool isClientError(int? statusCode) {
    return statusCode != null && statusCode >= 400 && statusCode < 500;
  }

  /// Checks if the status code is a server error (5xx).
  static bool isServerError(int? statusCode) {
    return statusCode != null && statusCode >= 500 && statusCode < 600;
  }
}
