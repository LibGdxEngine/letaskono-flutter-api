class SignupException implements Exception {
  final String message;
  final bool isEmailConfirmed;

  SignupException(this.message,this.isEmailConfirmed);

  @override
  String toString() {
    // Replace "Exception" with "Error"
    return "$message";
  }
}
