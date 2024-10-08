class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    // Replace "Exception" with "Error"
    return "$message";
  }
}
