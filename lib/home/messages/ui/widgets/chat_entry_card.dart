import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/extensions/context_extensions.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/home/messages/models/chat.dart';
import 'package:job_me/home/messages/providers/chats_provider.dart';
import 'package:job_me/home/messages/ui/pages/chat_page.dart';
import 'package:provider/provider.dart';

class ChatEntryCard extends StatelessWidget {
  final Message message;

  const ChatEntryCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ChatsProvider>();
    return GestureDetector(
      onTap: () {
        Get.to(ChatScreen.init(provider, message));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          height: 100,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: message.otherUserImage != null
                      ? CachedNetworkImage(
                          imageUrl: message.otherUserImage!,
                          height: 80,
                          width: 80,
                          placeholder: (_, __) => Image.asset(
                            'assets/images/unknown_person.png',
                            height: 80,
                            width: 80,
                          ),
                        )
                      : Image.asset(
                          'assets/images/img_2.png',
                          height: 80,
                          width: 80,
                        ),
                ),
                const SizedBox(
                  height: 64,
                  child: VerticalDivider(
                    width: 2,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.senderName,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getChatMessage(message, context),
                        style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey, height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${DateTime.parse(message.sendTime).day}/${DateTime.parse(message.sendTime).month}",
                          style: AppTextStyles.title.copyWith(height: 1),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${DateTime.parse(message.sendTime).year}",
                          style: AppTextStyles.title.copyWith(height: 1),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getChatMessage(Message message, BuildContext context) {
    if (message.text != null) return message.text!;
    if (message.medias.isNotEmpty && message.medias[0].isPicture()) return context.translate('picture');
    return context.translate('audio');
  }
}
