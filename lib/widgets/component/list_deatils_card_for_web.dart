import 'package:am_user/responsive/reponsive_layout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_widget/auto_size_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListDetailsCardForWeb extends StatefulWidget {
  String? id;
  String? image;
  String? name;
  String? work;
  String? contact;

  ListDetailsCardForWeb({
    super.key,
    this.id,
    required this.work,
    required this.name,
    required this.image,
    required this.contact,
  });

  @override
  State<ListDetailsCardForWeb> createState() => _ListDetailsCardForWebState();
}

class _ListDetailsCardForWebState extends State<ListDetailsCardForWeb> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 3,
      shadowColor: Colors.grey,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.black)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius:
                  Responsive.isDesktop(context)
                      ? 60
                      : Responsive.isTab(context)
                      ? 40
                      : 30,
              backgroundImage: NetworkImage(widget.image!),
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
                      child: Icon(
                        Icons.phone,
                        color: Colors.blue,
                        size: Responsive.isDesktop(context) ? 30 : 25,
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
                      child: Icon(
                        Icons.message,
                        color: Colors.green,
                        size: Responsive.isDesktop(context) ? 30 : 25,
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
}
