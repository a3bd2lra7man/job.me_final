
import 'api_exception.dart';

class MalformedResponseException extends APIException {
  static const String _userReadableMessage = 'Internal_Error';
  static const _internalMessage = "API response is malformed. status and data fields may be missing or may have wrong values.";

  MalformedResponseException() : super(_userReadableMessage, _internalMessage);
}
