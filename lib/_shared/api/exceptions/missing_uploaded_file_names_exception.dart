
import 'api_exception.dart';

class MissingUploadedFileNamesException extends APIException {
  static const String _userReadableMessage = 'Internal_Error';
  static const _internalMessage = "File upload did not return any file names";

  MissingUploadedFileNamesException() : super(_userReadableMessage, _internalMessage);
}
