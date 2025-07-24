import 'package:am_user/modals/job_model.dart';
import 'package:am_user/widgets/component/video_player_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../responsive/reponsive_layout.dart';

class JobListCard extends StatefulWidget {
  final JobModel item;

  const JobListCard({super.key, required this.item});

  @override
  State<JobListCard> createState() => _JobListCardState();
}

class _JobListCardState extends State<JobListCard> {

  @override

  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight;

    if (screenWidth >= 1024) {
      // Desktop
      imageHeight = 300;
    } else if (screenWidth >= 600) {
      // Tablet
      imageHeight = 200;
    } else {
      // Mobile
      imageHeight = 150;
    }

    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 1),
        color: Colors.white54,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VIDEO
          if (widget.item.images != null && widget.item.images!.isNotEmpty)
            Image.network(
              widget.item.images!,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
            ),

          if (widget.item.video != null && widget.item.video!.isNotEmpty)
            InlineVideoPlayer(videoUrl: widget.item.video!,),

          // TEXT overlay (if available)
          if (widget.item.name != null && widget.item.name!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  AutoSizeText(
                    widget.item.name!,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: Responsive.isMobile(context) ? 21 : 40,
                    ),
                    minFontSize: 10,
                    maxFontSize: 40,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6,),
          Align(alignment:Alignment.bottomRight,child: Text(widget.item.createdAt!,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400),))
        ],
      ),
    );
  }
}
