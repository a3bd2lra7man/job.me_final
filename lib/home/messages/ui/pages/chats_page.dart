import 'package:flutter/material.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/widgets/primary_app_bar.dart';
import 'package:job_me/home/messages/providers/chats_provider.dart';
import 'package:job_me/home/messages/ui/widgets/chat_entry_card.dart';
import 'package:job_me/home/messages/ui/widgets/chats_loader.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  static Widget init(ChatsProvider provider) {
    // provider.makeChatAsSeen();
    return ChangeNotifierProvider.value(value: provider, child: const ChatsPage._());
  }

  const ChatsPage._({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatsProvider>().fetchChats();
    });
  }

  // this function get called when user pop from inside screen balance and user info in some scenarios needs an update
  @override
  void didPopNext() {
    setState(() {});
    context.read<ChatsProvider>().currentChatRoom = null;
  }

  final _chatsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ChatsProvider>();
    return Scaffold(
      appBar: PrimaryAppBar(
        elevation: 0,
        title: context.translate('messages'),
        titleColor: AppColors.black,
      ),
      body: provider.isLoading
          ? const ChatsPageLoader()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              controller: _chatsScrollController,
              children: [
                const SizedBox(height: 16),
                ...provider.lastMessages.map((chat) => ChatEntryCard(message: chat)).toList(),
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}
