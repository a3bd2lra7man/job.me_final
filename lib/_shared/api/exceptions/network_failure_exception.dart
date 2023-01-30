
import 'api_exception.dart';

class NetworkFailureException extends APIException {
  static const String _userReadableMessage = 'no_internet';
  static const _internalMessage = "There is an issue with the network connection";

  NetworkFailureException() : super(_userReadableMessage, _internalMessage);
}
