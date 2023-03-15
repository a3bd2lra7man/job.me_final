import 'dart:async';

import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/home/messages/constants/messages_urls.dart';
import 'package:job_me/home/messages/models/chat.dart';
import 'package:job_me/home/messages/models/chat_room.dart';
import 'package:http/http.dart' as http;

class NewMessageAdder {
  final API _networkAdapter = API();
  bool isLoading = false;

  NewMessageAdder();

  Future<Message> addMessage(ChatRoom chatRoom, String? text, ImageFile? image, String? audioFile) async {
    isLoading = true;
    var url = ChatsUrls.sendMessageUrl();
    var apiRequest = APIRequest(url);
    var map = <String, dynamic>{};
    map["receiverId"] = chatRoom.otherUserId.toString();
    map['adsId'] = chatRoom.jobId.toString();
    if (text != null) {
      map['text'] = text;
    }
    if (image != null) {
      var photoToUpload = await http.MultipartFile.fromPath('medias[]', image.name, filename: image.name);
      map['photo'] = photoToUpload;
    }
    if (audioFile != null) {
      map['audio'] = audioFile;
    }
    apiRequest.addParameters(map);
    try {
      var apiResponse = await _networkAdapter.postWithFormData(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<Message> _processResponse(APIResponse apiResponse) async {
    //returning empty list if the response is from another session
    if (apiResponse.data == null) throw UnknownException();
    if (apiResponse.data['Result'] == null) throw UnknownException();

    try {
      var chat = Message.fromJson(apiResponse.data['Result']);
      return chat;
    } catch (e) {
      throw UnknownException();
    }
  }
}
