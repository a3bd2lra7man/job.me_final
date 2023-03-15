import 'package:job_me/home/messages/models/chat.dart';

class ChatRoom {
  late int totalMessagesInTheChatRoom;
  List<Message> messages = [];

  bool isAllRemoteMessagesInMemory() {
    return messages.length == totalMessagesInTheChatRoom;
  }

  int get otherUserId {
    return messages[0].otherUserId;
  }

  int get jobId {
    return messages[0].jobId;
  }

  ChatRoom.fromJson(Map map) {
    totalMessagesInTheChatRoom = map['total'];
    messages = (map['data'] as List).map((e) => Message.fromJson(e)).toList();
  }
}
