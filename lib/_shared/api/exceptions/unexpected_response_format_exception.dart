
import 'api_exception.dart';

class UnexpectedResponseFormatException extends APIException {
  static const String _userReadableMessage = 'Internal_Error';
  static const _internalMessage = "The response is in an unexpected format.";

  UnexpectedResponseFormatException() : super(_userReadableMessage, _internalMessage);
}
