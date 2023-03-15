import 'dart:async';
import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/messages/constants/messages_urls.dart';
import 'package:job_me/home/messages/models/chat.dart';
import 'package:job_me/home/messages/models/chat_room.dart';

class ChatRoomMessagesFetcher {
  final API _api;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isLoading = false;
  bool didReachEnd = false;
  int _currentPage = 0;

  ChatRoomMessagesFetcher() : _api = API();

  Future<ChatRoom> getChatRoom(Message message) async {
    resetPagination();
    var url = ChatsUrls.getChatRoomMessages(message.jobId, message.otherUserId, _currentPage);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _api.get(apiRequest);
      _isLoading = false;
      return _processChatRoomResponse(apiResponse);
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<ChatRoom> getNextMessagesForChatRoom(ChatRoom chatRoom) async {
    var url = ChatsUrls.getChatRoomMessages(chatRoom.jobId, chatRoom.otherUserId, _currentPage);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);

    _isLoading = true;
    try {
      var apiResponse = await _api.get(apiRequest);
      _isLoading = false;
      var newChatRoom = await _processChatRoomResponse(apiResponse);
      chatRoom.messages.addAll(newChatRoom.messages);
      return chatRoom;
    } on APIException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<ChatRoom> _processChatRoomResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<ChatRoom>().future;
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();
    if (apiResponse.data['Result']['data'] == null) throw UnknownException();
    if (apiResponse.data['Result']['total'] == null) throw UnknownException();

    try {
      var chatRoom = ChatRoom.fromJson(apiResponse.data['Result']);
      _updatePaginationData(chatRoom.messages.length);
      return chatRoom;
    } catch (e) {
      throw UnknownException();
    }
  }

  bool get isLoading => _isLoading;

  void _updatePaginationData(int length) {
    if (length == 0) {
      didReachEnd = true;
    } else {
      _currentPage += 1;
    }
  }

  void resetPagination() {
    didReachEnd = false;
    _currentPage = 0;
  }
}
