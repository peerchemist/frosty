/// Exception with a message given by [toString].
class MessageException(final String message) implements Exception {
  @override
  String toString() => "$runtimeType: $message";
}
