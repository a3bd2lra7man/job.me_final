
import '../../exceptions/app_exception.dart';

export 'http_exception.dart';
export 'malformed_response_exception.dart';
export 'network_failure_exception.dart';
export 'server_sent_exception.dart';

class APIException extends AppException {
  final dynamic responseData;

  APIException(
    String userReadableMessage,
    String internalErrorMessage, {
    this.responseData,
  }) : super(userReadableMessage, internalErrorMessage);

}
