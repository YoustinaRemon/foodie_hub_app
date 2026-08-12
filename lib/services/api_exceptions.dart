class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'A network error occurred. Please check your connection.']);
}

class ServerException extends ApiException {
  ServerException([super.message = 'The server encountered an error. Please try again later.']);
}

class InvalidResponseException extends ApiException {
  InvalidResponseException([super.message = 'The data received from the server was invalid.']);
}
