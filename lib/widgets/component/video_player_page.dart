// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:video_compress/video_compress.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:typed_data';
//
// class VideoThumbnailPage extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoThumbnailPage({required this.videoUrl, File? videoImage});
//
//   @override
//   _VideoThumbnailPlayerState createState() => _VideoThumbnailPlayerState();
// }
//
// class _VideoThumbnailPlayerState extends State<VideoThumbnailPage> {
//   late VideoPlayerController _videoController;
//   bool _isInitialized = false;
//   bool _showPlayer = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _isInitialized = true;
//         });
//         _videoController.play(); // ✅ auto-play
//       });
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: _showPlayer
//           ? _videoController.value.aspectRatio
//           : 16 / 9, // fallback if thumbnail doesn't give aspect
//       child: _showPlayer
//           ? _videoController.value.isInitialized
//           ? Stack(
//         alignment: Alignment.center,
//         children: [
//           VideoPlayer(_videoController),
//           if (!_videoController.value.isPlaying)
//             IconButton(
//               icon: Icon(Icons.play_circle, size: 64, color: Colors.white),
//               onPressed: () {
//                 setState(() {
//                   _showPlayer= true;
//                   _videoController.play();
//                 });
//               },
//             ),
//         ],
//       )
//           : Center(child: CircularProgressIndicator())
//           : Stack(
//         fit: StackFit.expand,
//         children: [
//             Image.network(widget.videoUrl, fit: BoxFit.cover),
//           Center(
//             child: IconButton(
//               icon: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
//               onPressed: () {
//                 setState(() {
//                   _showPlayer = true;
//                   _videoController.play();
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//     // return Center(
//     //   child: _isInitialized
//     //       ? AspectRatio(
//     //     aspectRatio: _videoController.value.aspectRatio,
//     //     child: VideoPlayer(_videoController),
//     //   )
//     //       : const Center(child: CircularProgressIndicator()),
//     // );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'dart:typed_data';
//
// class VideoThumbnailPage extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoThumbnailPage({required this.videoUrl});
//
//   @override
//   _VideoThumbnailPlayerState createState() => _VideoThumbnailPlayerState();
// }
//
// class _VideoThumbnailPlayerState extends State<VideoThumbnailPage> {
//   bool _showPlayer = false;
//   late VideoPlayerController _videoController;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }
//
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: _showPlayer
//           ? _videoController.value.aspectRatio
//           : 16 / 9, // fallback if thumbnail doesn't give aspect
//       child: _showPlayer
//           ? _videoController.value.isInitialized
//           ? Stack(
//         alignment: Alignment.center,
//         children: [
//           VideoPlayer(_videoController),
//           if (!_videoController.value.isPlaying)
//             IconButton(
//               icon: Icon(Icons.play_circle, size: 64, color: Colors.white),
//               onPressed: () {
//                 setState(() {
//                   _videoController.play();
//                 });
//               },
//             ),
//         ],
//       )
//           : Center(child: CircularProgressIndicator())
//           : Stack(
//         fit: StackFit.expand,
//         children: [
//             Container(color: Colors.black12),
//           Center(
//             child: IconButton(
//               icon: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
//               onPressed: () {
//                 setState(() {
//                   _showPlayer = true;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class InlineVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double height;

  const InlineVideoPlayer({
    required this.videoUrl,
    required this.height,
  });

  @override
  _InlineVideoPlayerState createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo() {
    setState(() {
      _isPlaying = true;
    });
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPlaying) {
      return GestureDetector(
        onTap: _playVideo,
        child: Container(
          height: widget.height,
          color: Colors.black54,
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      );
    } else {
      return _initialized
          ? Container(
        height: widget.height,
        color: Colors.black,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            if (!_controller.value.isPlaying)
              Center(
                child: IconButton(
                  icon: Icon(Icons.play_arrow, size: 40, color: Colors.white),
                  onPressed: () {
                    _controller.play();
                  },
                ),
              ),
          ],
        ),
      )
          : Container(
        height: widget.height,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
  }
}

