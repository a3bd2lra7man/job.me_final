import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';
import 'package:job_me/_shared/api/exceptions/server_sent_exception.dart';
import 'package:job_me/_shared/exceptions/app_exception.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/widgets/snack_bar.dart';
import 'package:job_me/home/_shared/providers/real_time_provider.dart';
import 'package:job_me/home/messages/exceptions/no_other_messages.dart';
import 'package:job_me/home/messages/models/chat.dart';
import 'package:job_me/home/messages/models/chat_room.dart';
import 'package:job_me/home/messages/services/chat_room_messages_fetcher.dart';
import 'package:job_me/home/messages/services/chat_seen_informer.dart';
import 'package:job_me/home/messages/services/chats_fetcher.dart';
import 'package:job_me/home/messages/services/new_message_adder.dart';
import 'package:job_me/home/messages/services/number_of_new_messages_fetcher.dart';
import 'package:provider/provider.dart';

class ChatsProvider extends ChangeNotifier implements MessagesListener {
  BuildContext context;

  ChatsProvider(this.context) {
    context.read<RealTimeProvider>().addNewMessagesListener(this);
  }

  ChatRoom? currentChatRoom;

  List<Message> _lastMessages = [];

  List<Message> get lastMessages => _lastMessages;

  bool isLoading = false;
  bool isPaginationLoading = false;
  bool isSendinMessageLoading = false;
  bool isFetchChatRoomMessagesLoading = false;

  num numberOfNewMessages = 0;

  final _chatsFetcher = ChatsFetcher();
  final _newMessagesNumberFetcher = NumberOfNewMessagesFetcher();
  final _chatsSeenInformer = ChatSeenInformer();
  final chatRoomFetcher = ChatRoomMessagesFetcher();
  final _newMessageAdder = NewMessageAdder();

  Future fetchNumberOfNewMessages({bool notify = true}) async {
    if (notify) {
      isLoading = true;
      notifyListeners();
    }

    try {
      numberOfNewMessages = await _newMessagesNumberFetcher.fetchNewMessagesNumber();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }

    if (notify) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future fetchChats({bool notify = true}) async {
    if (notify) {
      isLoading = true;
      notifyListeners();
    }

    try {
      _lastMessages = await _chatsFetcher.fetchChats();
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }

    if (notify) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future makeMessageAsSeenAndFetchOldMessages(Message message) async {
    numberOfNewMessages = 0;
    currentChatRoom = null;
    isFetchChatRoomMessagesLoading = true;
    notifyListeners();

    try {
      await _chatsSeenInformer.makeMessagesAsSeen(message.otherUserId);
      currentChatRoom = await chatRoomFetcher.getChatRoom(message);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isFetchChatRoomMessagesLoading = false;
    notifyListeners();
    fetchNumberOfNewMessages(notify: false);
  }

  Future getNextMessages() async {
    isPaginationLoading = true;
    notifyListeners();

    try {
      if (chatRoomFetcher.didReachEnd) throw NoOtherMessages();
      currentChatRoom = await chatRoomFetcher.getNextMessagesForChatRoom(currentChatRoom!);
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    }
    isPaginationLoading = false;
    notifyListeners();
  }

  Future addNewMessage(String? message, ImageFile? file, String? audioFile) async {
    isSendinMessageLoading = true;
    notifyListeners();

    try {
      var newMessage = await _newMessageAdder.addMessage(currentChatRoom!, message, file, audioFile);
      currentChatRoom!.messages = [newMessage, ...currentChatRoom!.messages];
      isSendinMessageLoading = false;
      notifyListeners();
      fetchChats();
      return true;
    } on ServerSentException catch (e) {
      showSnackBar(body: json.encode(e.errorResponse));
    } on AppException catch (e) {
      showSnackBar(body: context.translate(e.userReadableMessage));
    } catch (_) {}
    isSendinMessageLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    context.read<RealTimeProvider>().removeMessagesListener(this);
    super.dispose();
  }

  @override
  void onNewMessage(MessageEvent messageEvent) async {
    if (currentChatRoom != null) {
      if (currentChatRoom!.otherUserId == messageEvent.message.otherUserId) {
        currentChatRoom!.messages = [messageEvent.message, ...currentChatRoom!.messages];
        notifyListeners();
      }
    } else {
      await fetchChats(notify: false);
      await fetchNumberOfNewMessages();
      notifyListeners();
    }
  }
}
