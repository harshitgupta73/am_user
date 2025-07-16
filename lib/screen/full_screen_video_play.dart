import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsStyleVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ReelsStyleVideoPlayer({super.key, required this.videoUrl});

  @override
  State<ReelsStyleVideoPlayer> createState() => _ReelsStyleVideoPlayerState();
}

class _ReelsStyleVideoPlayerState extends State<ReelsStyleVideoPlayer> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? GestureDetector(
        onTap: togglePlayPause,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            if (!isPlaying)
              const Icon(
                Icons.play_arrow,
                size: 80,
                color: Colors.black,
              ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
