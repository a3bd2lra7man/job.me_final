// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sound/flutter_sound.dart';
//
// class AudioMessagePlayer extends StatefulWidget {
//   final String audioUrl;
//
//   const AudioMessagePlayer({Key? key, required this.audioUrl}) : super(key: key);
//
//   @override
//   _AudioMessagePlayerState createState() => _AudioMessagePlayerState();
// }
//
// class _AudioMessagePlayerState extends State<AudioMessagePlayer> {
//   Duration position = Duration.zero;
//   Duration duration = Duration.zero;
//   var player = FlutterSoundPlayer();
//   bool isPlaying = false;
//   bool isStopped = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return !isPlaying
//         ? IconButton(
//             onPressed: () async {
//               if (Platform.isAndroid) {
//                 var dataBuffer = base64.decode(widget.audioUrl.split('base64,')[1]);
//                 await player.openPlayer();
//                 await player.setSubscriptionDuration(const Duration(milliseconds: 10));
//                 player.onProgress?.listen((event) {
//                   setState(() {
//                     isPlaying = true;
//                     position = event.position;
//                     duration = event.duration;
//                     if(position.inSeconds == duration.inSeconds){
//                         isPlaying = false;
//                     }
//                   });
//                 });
//                 player.startPlayer(fromDataBuffer: dataBuffer);
//               } else if (Platform.isIOS) {
//                 const platform = MethodChannel('play_audio');
//                 try {
//                   await platform.invokeMethod('any_name', widget.audioUrl.split('base64,')[1]);
//                 } on PlatformException catch (e) {
//                   print("Failed to execute native code: '${e.message}'.");
//                 }
//               }
//
//             },
//             icon: const Icon(Icons.play_arrow))
//         : Row(
//             children: [
//               Expanded(
//                   child: Slider(
//                       min: 0,
//                       max: duration.inSeconds.toDouble(),
//                       value: position.inSeconds.toDouble(),
//                       onChanged: (_) {})),
//               isStopped
//                   ? IconButton(
//                       onPressed: () async {
//                         setState(() {
//                           isStopped = false;
//                         });
//                         player.resumePlayer();
//                       },
//                       icon: const Icon(Icons.play_arrow))
//                   : IconButton(
//                       onPressed: () {
//                         setState(() {
//                           isStopped = true;
//                         });
//                         player.pausePlayer();
//                       },
//                       icon: const Icon(Icons.pause)),
//             ],
//           );
//   }
// }
