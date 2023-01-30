
class ServerSentException  implements Exception{
   dynamic errorResponse;

  ServerSentException({required this.errorResponse});
}
