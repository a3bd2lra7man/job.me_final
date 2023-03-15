import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/home/messages/providers/chats_provider.dart';
import 'package:job_me/home/messages/ui/pages/chats_page.dart';
import 'package:provider/provider.dart';

class ChatIcon extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => ChatsProvider(context),
      child: const ChatIcon._(),
    );
  }

  const ChatIcon._({Key? key}) : super(key: key);

  @override
  State<ChatIcon> createState() => _ChatIconState();
}

class _ChatIconState extends State<ChatIcon> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatsProvider>().fetchNumberOfNewMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ChatsProvider>();
    return IconButton(
      onPressed: () {
        Get.to(() => ChatsPage.init(provider));
      },
      icon: Stack(
        children: [
          Icon(
            Icons.message_outlined,
            color: AppColors.black,
            size: 32,
          ),
          Visibility(
            visible: provider.numberOfNewMessages != 0,
            child: Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    provider.numberOfNewMessages.toString(),
                    style: TextStyle(color: AppColors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
