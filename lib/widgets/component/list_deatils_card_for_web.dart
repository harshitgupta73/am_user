import 'package:am_user/modals/all_user_modal.dart';
import 'package:am_user/responsive/reponsive_layout.dart';
import 'package:am_user/widgets/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controller/controllers.dart';
import '../../screen/card_deatils_csreen.dart';
import '../routs/routs.dart';

class ListDetailsCardForWeb extends StatefulWidget {
  String? id;
  String? image;
  String? name;
  String? work;
  String? contact;
  double? distance;

  ListDetailsCardForWeb({
    super.key,
    this.id,
    required this.work,
    required this.name,
    required this.image,
    required this.contact,
    required this.distance,
  });

  @override
  State<ListDetailsCardForWeb> createState() => _ListDetailsCardForWebState();
}

class _ListDetailsCardForWebState extends State<ListDetailsCardForWeb> {

  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 3,
      shadowColor: Colors.grey,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CardDetailsScreen(
                          users: AllUserModal(
                            name: widget.name!,
                            contact: widget.contact!,
                            type: widget.work!,
                            id: widget.id!,
                            image: widget.image,
                          ),
                        ),
                  ),
                );
              },
              child: CircleAvatar(
                radius:
                    Responsive.isDesktop(context)
                        ? 60
                        : Responsive.isTab(context)
                        ? 40
                        : 30,
                backgroundImage: NetworkImage(widget.image!),
              ),
            ),
            SizedBox(
              width:
                  Responsive.isMobile(context)
                      ? size.width / 50
                      : size.width / 70,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      widget.name!,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Responsive.isMobile(context) ? 21 : 40,
                      ),
                      minFontSize: 10,
                      maxFontSize: 40,
                      maxLines: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          (widget.work ?? "")
                              .split(',')
                              .map((e) => e.trim())
                              .take(2)
                              .join(", "),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                Responsive.isTab(context)
                                    ? 20
                                    : Responsive.isMobile(context)
                                    ? 15
                                    : 40,
                          ),
                          minFontSize: 10,
                          maxFontSize: 40,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Responsive.isDesktop(context) && size.width > 1200 ||
                                Responsive.isMobile(context)
                            ? AutoSizeText(
                              widget.contact!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    Responsive.isTab(context)
                                        ? 20
                                        : Responsive.isMobile(context)
                                        ? 14
                                        : 40,
                              ),
                              minFontSize: 10,
                              maxFontSize: 40,
                              maxLines: 1,
                            )
                            : Container(),
                        Responsive.isDesktop(context) && size.width > 1200 ||
                            Responsive.isMobile(context)
                            ? AutoSizeText(
                          readableDistance(widget.distance!),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:
                            Responsive.isTab(context)
                                ? 20
                                : Responsive.isMobile(context)
                                ? 14
                                : 40,
                          ),
                          minFontSize: 10,
                          maxFontSize: 40,
                          maxLines: 1,
                        )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius:
                        Responsive.isDesktop(context)
                            ? size.height / 35
                            : size.height / 45,

                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Utils().dialNumber(widget.contact!, context);
                        },
                        icon: Icon(
                          Icons.phone,
                          color: Colors.blue,
                          size: Responsive.isDesktop(context) ? 30 : 25,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius:
                        Responsive.isDesktop(context)
                            ? size.height / 35
                            : size.height / 45,

                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          context.push(
                            '${RoutsName.chatScreen}?currentUserId=${FirebaseAuth.instance.currentUser!.uid}&targetUserId=${widget.id}&targetUserName=${Uri.encodeComponent(widget.name!)}',
                          );
                        },
                        child: Icon(
                          Icons.message,
                          color: Colors.green,
                          size: Responsive.isDesktop(context) ? 30 : 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String readableDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return "${(distanceInKm * 1000).toStringAsFixed(0)} meters";
    } else {
      return "${distanceInKm.toStringAsFixed(2)} km";
    }
  }
}
