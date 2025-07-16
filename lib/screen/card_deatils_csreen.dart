import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../modals/driver_modal.dart';

class CardDetailsScreen extends StatefulWidget {
  final DriverModal driver;

  const CardDetailsScreen({super.key, required this.driver});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  VideoPlayerController? _activeController;
  int? _activeIndex;
  bool isVideo = false;
  bool isPost = true;

  // Dummy data for videos & posts
  final List<String> videos = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  final List<String> postImages = [
    'https://picsum.photos/id/1015/200/200',
    'https://picsum.photos/id/1016/200/200',
    'https://picsum.photos/id/1018/200/200',
    'https://picsum.photos/id/1020/200/200',
    'https://picsum.photos/id/1024/200/200',
    'https://picsum.photos/id/1027/200/200',
  ];

  @override
  void dispose() {
    _disposeActiveController();
    super.dispose();
  }

  void _disposeActiveController() {
    _activeController?.dispose();
    _activeController = null;
    _activeIndex = null;
  }

  Future<void> _initializeAndPlay(int index) async {
    _disposeActiveController();
    final url = videos[index];
    final controller = VideoPlayerController.network(url);
    try {
      await controller.initialize();
      controller.play();
      setState(() {
        _activeController = controller;
        _activeIndex = index;
      });
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  Widget _buildVideoCard(int index) {
    final isActive = _activeIndex == index && _activeController != null;

    return GestureDetector(
      onTap: () {
        if (isActive) {
          setState(() {
            _activeController!.value.isPlaying
                ? _activeController!.pause()
                : _activeController!.play();
          });
        } else {
          _initializeAndPlay(index);
        }
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isActive && _activeController!.value.isInitialized
            ? Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _activeController!.value.aspectRatio,
              child: VideoPlayer(_activeController!),
            ),
            if (!_activeController!.value.isPlaying)
              const Icon(Icons.play_circle, size: 60, color: Colors.white),
          ],
        )
            : const Center(
          child: Icon(Icons.play_circle_outline,
              size: 50, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.driver;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Details'),
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver Info
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: d.driverImage != null && d.driverImage!.isNotEmpty
                      ? NetworkImage(d.driverImage!)
                      : const AssetImage("assets/images/default_profile.png")
                  as ImageProvider,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.driverName ?? '-',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text("Contact: ${d.driverContact ?? '-'}",
                          style: const TextStyle(color: Colors.white)),
                      Text("Gender: ${d.gender ?? '-'}",
                          style: const TextStyle(color: Colors.white)),
                      Text("Country: ${d.stateValue ?? '-'}",
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Owner Info
            Text("Owner Name: ${d.vehicleOwnerName ?? '-'}",
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text("Owner Address: ${d.driverAddress ?? '-'}",
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            Text("Vehicle No: ${d.vehicleNo ?? '-'}",
                style: const TextStyle(color: Colors.white)),

            const Divider(height: 30, color: Colors.white54),

            // Document Images - Driving Licence
            _buildImage(d.drivingLicence, "Driving Licence"),

            const Divider(height: 30, color: Colors.white54),

            // Toggle Tabs for Videos or Posts
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPost = true;
                        isVideo = false;
                        _disposeActiveController();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isPost ? Colors.white12 : Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                      const Text("Posts", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPost = false;
                        isVideo = true;
                        _disposeActiveController();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isVideo ? Colors.white12 : Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                      const Text("Videos", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Show Posts or Videos
            isVideo
                ? Column(
              children: List.generate(videos.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildVideoCard(index),
                );
              }),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: postImages.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(postImages[index], fit: BoxFit.cover),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? url, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 6),
        if (url != null && url.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          const Text("No Image Available", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 12),
      ],
    );
  }
}
