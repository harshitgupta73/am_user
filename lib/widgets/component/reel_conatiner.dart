import 'package:am_user/screen/full_screen_video_play.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelContainer extends StatefulWidget {
  final String videoUrl;

  ReelContainer({required this.videoUrl});

  @override
  _ReelContainerState createState() => _ReelContainerState();
}

class _ReelContainerState extends State<ReelContainer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Video background
        _controller.value.isInitialized
            ? SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        )
            : Center(child: CircularProgressIndicator()),



      ],
    );
  }
}