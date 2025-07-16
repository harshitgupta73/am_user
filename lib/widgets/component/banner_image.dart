

import 'package:flutter/material.dart';
import 'dart:async';
import '../../responsive/reponsive_layout.dart';


class BannerImageWidget extends StatefulWidget {
  const BannerImageWidget({super.key});

  @override
  State<BannerImageWidget> createState() => _BannerImageWidgetState();
}


class _BannerImageWidgetState extends State<BannerImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.white,
      semanticContainer: true,
      surfaceTintColor: Colors.white,
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21)
      ),
      margin: EdgeInsets.only(
        left: 5,
        right: 5,
        top: Responsive.isDesktop(context) ? 10 : 0,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Image.network(
          "https://i.ytimg.com/vi/1sJerhckt4Q/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLD25bk8p33u_M2wfVR_-xtknxbK_g",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

