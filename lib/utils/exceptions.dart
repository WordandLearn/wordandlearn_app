class HttpFetchException implements Exception {
  final String message;
  final int statusCode;
  HttpFetchException(this.message, this.statusCode);
}
