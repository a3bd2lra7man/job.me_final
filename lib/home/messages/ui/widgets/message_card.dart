import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/_shared/themes/text_styles.dart';
import 'package:job_me/_shared/widgets/image_previewr.dart';
import 'package:job_me/home/messages/models/chat.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.message.senderImage != null
                        ? CachedNetworkImage(
                            imageUrl: widget.message.senderImage!,
                            height: 40,
                            width: 40,
                            placeholder: (_, __) => Image.asset(
                              'assets/images/unknown_person.png',
                              height: 40,
                              width: 40,
                            ),
                          )
                        : Image.asset(
                            'assets/images/img_2.png',
                            height: 40,
                            width: 40,
                          ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.width * .6,
                        child: Text(
                          widget.message.senderName,
                          style: AppTextStyles.bodyMedium.copyWith(height: 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.message.toReadableDate(),
                        style: AppTextStyles.hint.copyWith(color: AppColors.darkGrey, height: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              if (widget.message.text != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.message.text!,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                ),
              ...[
                ...widget.message.medias
                    .map<Widget>((e) => e.isPicture()
                        ? GestureDetector(
                            onTap: () {
                              Get.to(ImagePreviewer(
                                url: e.image,
                                title: "",
                              ));
                            },
                            child: Container(
                              width: context.width * .7,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage((e as MessagePicture).image)),
                              ),
                            ),
                          )
                        // : const SizedBox())
                        : const SizedBox())
                    .toList()
              ],
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
