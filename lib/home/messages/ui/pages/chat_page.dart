import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/api/entities/image_file.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/image_picker.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/home/messages/models/chat.dart';
import 'package:job_me/home/messages/providers/chats_provider.dart';
import 'package:job_me/home/messages/ui/widgets/message_card.dart';
import 'package:job_me/home/messages/ui/widgets/chats_loader.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Message message;

  static Widget init(ChatsProvider provider, Message lastMessage) {
    return ChangeNotifierProvider.value(value: provider, child: ChatScreen._(message: lastMessage));
  }

  const ChatScreen._({Key? key, required this.message}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messagesScrollController = ScrollController();
  final _messageTextController = TextEditingController();
  ImageFile? imageFile;

  // String? audioFile;
  // bool isRecording = false;
  // String? audioPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatsProvider>().makeMessageAsSeenAndFetchOldMessages(widget.message);
      _messagesScrollController.addListener(() {
        if (_messagesScrollController.position.pixels == _messagesScrollController.position.maxScrollExtent) {
          context.read<ChatsProvider>().getNextMessages();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ChatsProvider>();

    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints(maxWidth: context.width),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageFile != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 16)),
                    Expanded(
                      flex: 2,
                      child: Text(
                        imageFile!.name.length > 10 ? "${imageFile!.name.substring(0, 10)} ..." : imageFile!.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Expanded(
                      child: IconButton(
                        onPressed: () => setState(() {
                          imageFile = null;
                        }),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      await pickImage((image) {
                        imageFile = image;
                        setState(() {});
                      });
                    },
                    icon: const Icon(
                      Icons.attach_file,
                    ),
                  ),
                  // if (!isRecording)
                  //   IconButton(
                  //       onPressed: () async {
                  //         isRecording = true;
                  //         setState(() {});
                  //       },
                  //       icon: const Icon(Icons.mic)),
                  Expanded(
                    child: Stack(
                      children: [
                        TextField(
                          controller: _messageTextController,
                          maxLines: 20,
                          minLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                        // if (isRecording)
                        //   AudioRecorder(
                        //     onRemoveVoice: () {
                        //       isRecording = false;
                        //       setState(() {});
                        //     },
                        //     onDoNotGivePermission: () {
                        //       isRecording = false;
                        //       setState(() {});
                        //     },
                        //     onSend: (s) async {
                        //       isRecording = false;
                        //       audioPath = s;
                        //       var file = File(s);
                        //       var bytes = await file.readAsBytes();
                        //       var string = base64.encode(bytes);
                        //       audioFile = string;
                        //       setState(() {});
                        //       sendMessage(provider);
                        //     },
                        //   ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await sendMessage(provider);
                    },
                    icon: provider.isSendinMessageLoading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: AppColors.primary,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('messages'),
        titleColor: AppColors.black,
      ),
      body: provider.isFetchChatRoomMessagesLoading
          ? const ChatsPageLoader()
          : Column(
              children: [
                Visibility(
                  visible: provider.isPaginationLoading,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: context.height * .1),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedList(
                    controller: _messagesScrollController,
                    reverse: true,
                    itemBuilder: (_, index, __) => MessageCard(
                      message: provider.currentChatRoom!.messages[index],
                    ),
                    initialItemCount: provider.currentChatRoom?.messages.length ?? 0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: context.height * .1),
                )
              ],
            ),
    );
  }

  Future sendMessage(ChatsProvider provider) async {
    if (_messageTextController.text.isNotEmpty || imageFile != null) {
      var isSuccess = await provider.addNewMessage(
          _messageTextController.text.isEmpty ? null : _messageTextController.text, imageFile, null);
      if (isSuccess != null && isSuccess) {
        _messageTextController.clear();
        imageFile = null;
        // audioFile = null;
        // isRecording = false;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
