
import 'api_exception.dart';

class FileDownloadException extends APIException {
  static const String _userReadableMessage = 'Internal_Error';

  FileDownloadException(String errorMessage) : super(_userReadableMessage, errorMessage, responseData: {});
}
