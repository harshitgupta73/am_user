import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';

class VideoThumbnailPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailPlayer({required this.videoUrl, File? videoImage});

  @override
  _VideoThumbnailPlayerState createState() => _VideoThumbnailPlayerState();
}

class _VideoThumbnailPlayerState extends State<VideoThumbnailPlayer> {
  late VideoPlayerController _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _videoController.play(); // ✅ auto-play
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return AspectRatio(
    //   aspectRatio: _showPlayer
    //       ? _videoController.value.aspectRatio
    //       : 16 / 9, // fallback if thumbnail doesn't give aspect
    //   child: _showPlayer
    //       ? _videoController.value.isInitialized
    //       ? Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       VideoPlayer(_videoController),
    //       if (!_videoController.value.isPlaying)
    //         IconButton(
    //           icon: Icon(Icons.play_circle, size: 64, color: Colors.white),
    //           onPressed: () {
    //             setState(() {
    //               _videoController.play();
    //             });
    //           },
    //         ),
    //     ],
    //   )
    //       : Center(child: CircularProgressIndicator())
    //       : Stack(
    //     fit: StackFit.expand,
    //     children: [
    //         Image.network(widget.videoUrl, fit: BoxFit.cover),
    //       Center(
    //         child: IconButton(
    //           icon: Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
    //           onPressed: () {
    //             setState(() {
    //               _showPlayer = true;
    //             });
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Center(
      child: _isInitialized
          ? AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
