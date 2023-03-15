import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_me/_shared/themes/colors.dart';
import 'package:job_me/home/notifications/providers/notifications_provider.dart';
import 'package:job_me/home/notifications/ui/screens/notifications_screen.dart';
import 'package:provider/provider.dart';

class NotificationsIcon extends StatefulWidget {
  static Widget init() {
    return ChangeNotifierProvider(
      create: (context) => NotificationsProvider(context),
      child: const NotificationsIcon._(),
    );
  }

  const NotificationsIcon._({Key? key}) : super(key: key);

  @override
  State<NotificationsIcon> createState() => _NotificationsIconState();
}

class _NotificationsIconState extends State<NotificationsIcon> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NotificationsProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<NotificationsProvider>();
    return IconButton(
      onPressed: (){
        Get.to(()=>NotificationsScreen.init(provider));
      },
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_none_outlined,
            color: AppColors.black,
            size: 32,
          ),
          Visibility(
            visible: provider.unSeenNotifications.isNotEmpty,
            child: Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    provider.unSeenNotificationCount,
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
