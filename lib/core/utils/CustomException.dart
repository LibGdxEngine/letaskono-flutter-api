class Customexception implements Exception {
  final String message;

  Customexception(this.message);

  @override
  String toString() {
    // Replace "Exception" with "Error"
    return "$message";
  }
}