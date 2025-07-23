import 'dart:io';

import 'package:am_user/modals/job_model.dart';
import 'package:am_user/widgets/component/reel_conatiner.dart';
import 'package:am_user/widgets/component/video_player_page.dart';
import 'package:am_user/widgets/component/video_player_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

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

    // final Timestamp timestamp = widget.item.createdAt!;
    // final DateTime dateTime = timestamp.toDate();
    // final String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);

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
    return Card(
      elevation: 2,
      shadowColor: Colors.white,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VIDEO
            if (widget.item.images != null && widget.item.images!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
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
              ),

            if (widget.item.video != null && widget.item.video!.isNotEmpty)
              InlineVideoPlayer(videoUrl: widget.item.video!,height: imageHeight,),

            // TEXT overlay (if available)
            if (widget.item.name != null && widget.item.name!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    AutoSizeText(
                      widget.item.name!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.isMobile(context) ? 21 : 40,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      minFontSize: 10,
                      maxFontSize: 40,
                      maxLines: 1,
                    ),


                  ],
                ),
              ),
            const SizedBox(height: 10,),
            Text(widget.item.createdAt!,style: TextStyle(color: Colors.white38),)
          ],
        ),
      ),
    );
  }
}
