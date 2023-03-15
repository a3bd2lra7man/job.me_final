import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:job_me/home/messages/models/chat.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';

// import 'package:pusher_client/pusher_client.dart';
import 'dart:developer';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class NotificationEvent {}

class MessageEvent {
  Message message;

  MessageEvent(this.message);
}

abstract class NotificationListener {
  void onNewNotification(NotificationEvent notificationEvent);
}

abstract class MessagesListener {
  void onNewMessage(MessageEvent messageEvent);
}

class RealTimeProvider extends ChangeNotifier {
  List<NotificationListener> notificationListeners = [];
  List<MessagesListener> messagesListeners = [];

  RealTimeProvider() {
    initiateRealTimeListening();
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
    String token = UserRepository().getUserToken()!;

    var authUrl = "https://apiv2.jobme.me/api/broadcasting/auth";
    var result = await post(
      Uri.parse(authUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: 'socket_id=$socketId&channel_name=$channelName',
    );

    log(result.body);

    return jsonDecode(result.body);
  }

  void initiateRealTimeListening() async {
    if (!UserRepository().isUserLoggedIn()) return;
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: "0d0226fa92c6e39deb2c",
        cluster: "mt1",
        useTLS: true,
        onAuthorizer: onAuthorizer,
      );
      var userId = UserRepository().getUser().id;
      await pusher.subscribe(
          channelName: 'private-messages.$userId',
          onEvent: (event) {
            if (event.eventName == 'private-chat-event') {
              var message = Message.fromJson((json.decode(event.data) as Map)['message']);
              onNewMessage(MessageEvent(message));
            }
          });
      await pusher.subscribe(
          channelName: 'private-notifications.$userId',
          onEvent: (event) {
            onNewNotification(NotificationEvent());
          });
      await pusher.connect();
    } catch (_) {}
  }

  void addNewNotificationListener(NotificationListener listener) {
    notificationListeners.add(listener);
  }

  void addNewMessagesListener(MessagesListener listener) {
    messagesListeners.add(listener);
  }

  void removeNotificationListener(NotificationListener listener) {
    notificationListeners.remove(listener);
  }

  void removeMessagesListener(MessagesListener listener) {
    messagesListeners.remove(listener);
  }

  void onNewNotification(NotificationEvent notificationEvent) {
    for (var element in notificationListeners) {
      element.onNewNotification(notificationEvent);
    }
  }

  void onNewMessage(MessageEvent messageEvent) {
    for (var element in messagesListeners) {
      element.onNewMessage(messageEvent);
    }
  }
}
