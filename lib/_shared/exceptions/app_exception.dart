abstract class AppException implements Exception {

  final String userReadableMessage;
  final String internalMessage;

  AppException(this.userReadableMessage, this.internalMessage);
}
