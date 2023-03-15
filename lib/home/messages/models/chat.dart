import 'dart:developer';

import 'package:job_me/_shared/api/constants/base_url.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

class Media {
  bool isPicture() {
    return this is MessagePicture;
  }
}

class MessageAudio extends Media {
  final String url;

  MessageAudio(this.url);
}

class MessagePicture extends Media {
  final String _url;

  MessagePicture(this._url);

  String get image {
    if (_url.startsWith('http')) return _url;
    return "${BaseUrls.staticUrl()}/$_url";
  }
}

class Message {
  late int id;
  late bool isSeen;
  late String? text;
  late int _senderId;
  late int _receiverId;
  late int jobId;
  late String senderName;
  late String sendTime;
  List<Media> medias = [];

  late String? _senderImage;

  String? get senderImage {
    if (_senderImage == null) return _senderImage;
    if (_senderImage!.startsWith('http')) return _senderImage;
    return "${BaseUrls.staticUrl()}/${_senderImage!}";
  }

  late String? _receiverImage;

  String? get receiverImage {
    if (_receiverImage == null) return _receiverImage;
    if (_receiverImage!.startsWith('http')) return _receiverImage;
    return "${BaseUrls.staticUrl()}/${_receiverImage!}";
  }

  int get otherUserId {
    var currentUserId = UserRepository().getUser().id;
    return _senderId == currentUserId ? _receiverId : _senderId;
  }

  String? get otherUserImage {
    var currentUserId = UserRepository().getUser().id;
    return _senderId == currentUserId ? receiverImage : senderImage;
  }
  Message.fromJson(Map map) {
    id = map['id'];
    isSeen = map['seen'] == null
        ? true
        : map['seen'] == 0
            ? false
            : true;
    text = map['text'];
    _senderId = map['sender_id'];
    _receiverId = map['receiver_id'];
    jobId = map['ads_jobs_id'];
    senderName = map['sender']['fullname'];
    _senderImage = map['sender']['photo'];
    _receiverImage = map['receiver']['photo'];
    sendTime = map['created_at'];
    if (map['medias'] != null) {
      for (var media in map['medias']) {
        if (isAudio(media)) {
          medias.add(MessageAudio(media['url']));
        } else {
          log("4");
          medias.add(MessagePicture(media['url']));
        }
      }
    }
  }

  bool isAudio(Map media) {
    return (media['url'] ?? "").toString().length > 50;
  }

  String toReadableDate() {
    var dateTime = DateTime.parse(sendTime).toLocal();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} : ${dateTime.hour}:${dateTime.minute}';
  }
}
