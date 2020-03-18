abstract class CustomException implements Exception {
  final String message;

  CustomException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}

class ServerException extends CustomException {
  final String message;

  ServerException([this.message]);
}

class CacheException extends CustomException {
  final String message;

  CacheException([this.message]);
}

class DuplicateException extends CustomException {
  final String message;

  DuplicateException([this.message]);
}

class ConnectionException extends CustomException {
  final String message;

  ConnectionException([this.message]);
}

class AuthenticationException extends CustomException {
  final String message;

  AuthenticationException([this.message]);
}