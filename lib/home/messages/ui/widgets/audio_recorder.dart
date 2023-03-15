// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:get/get.dart';
// import 'package:job_me/_shared/extensions/context_extensions.dart';
// import 'package:job_me/_shared/themes/colors.dart';
// import 'package:job_me/_shared/themes/text_styles.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class AudioRecorder extends StatefulWidget {
//   final void Function(String path) onSend;
//   final Function onDoNotGivePermission;
//   final Function onRemoveVoice;
//
//   const AudioRecorder(
//       {Key? key, required this.onSend, required this.onDoNotGivePermission, required this.onRemoveVoice})
//       : super(key: key);
//
//   @override
//   State<AudioRecorder> createState() => _AudioRecorderState();
// }
//
// class _AudioRecorderState extends State<AudioRecorder> {
//   int _recordDuration = 0;
//   Timer? _timer;
//   final _audioRecorder = FlutterSoundRecorder();
//   final path = "note.mp4";
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await checkPermissionAndOpenTheRecorder(onSuccess: _startRecording);
//     });
//   }
//
//   Future<void> _startRecording() async {
//     try {
//       _audioRecorder
//           .startRecorder(
//         toFile: path,
//         codec: Codec.aacMP4,
//       )
//           .then((value) {
//         setState(() {});
//       });
//       _startTimer();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   Future<void> checkPermissionAndOpenTheRecorder({required Function onSuccess}) async {
//     if (!kIsWeb) {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         Get.bottomSheet(Container(
//           decoration: BoxDecoration(
//             borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
//             color: AppColors.white,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   // ignore: use_build_context_synchronously
//                   context.translate('need_mic_access'),
//                   style: AppTextStyles.headerBig,
//                 ),
//                 const SizedBox(
//                   height: 80,
//                 )
//               ],
//             ),
//           ),
//         ));
//         widget.onDoNotGivePermission();
//       } else {
//         await _audioRecorder.openRecorder();
//         await onSuccess();
//       }
//     }
//   }
//
//   Future<void> _stop() async {
//     _timer?.cancel();
//     _recordDuration = 0;
//     final path = await _audioRecorder.stopRecorder();
//     if (path != null) {
//       widget.onSend(path);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             IconButton(
//               onPressed: () => widget.onRemoveVoice(),
//               icon: const Icon(
//                 Icons.delete,
//                 color: Colors.red,
//               ),
//             ),
//             Text(
//               _recordDuration.toString(),
//               style: AppTextStyles.hint.copyWith(color: AppColors.white),
//             ),
//             IconButton(
//               onPressed: _stop,
//               icon: const Icon(
//                 Icons.send,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   _startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         _recordDuration += 1;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _recordDuration = 0;
//     _timer?.cancel();
//     _audioRecorder.closeRecorder();
//     super.dispose();
//   }
// }
