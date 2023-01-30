
import 'api_exception.dart';

class NoAccessTokenException extends APIException {
  static const String _userReadableMessage ='Internal_Error';
  static const _internalMessage = "This should not happened developer should not try to get access token before saving a one";

  NoAccessTokenException() : super(_userReadableMessage, _internalMessage, responseData: {});
}
