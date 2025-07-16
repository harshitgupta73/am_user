import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/const.dart';

class CustomSearchbar extends StatefulWidget {
  final VoidCallback? onTap;
  final TextEditingController controller;
  final String? label;
  const CustomSearchbar({super.key,
    required this.controller,
    this.label,
    this.onTap,

  });

  @override
  State<CustomSearchbar> createState() => _CustomSearchbarState();
}

class _CustomSearchbarState extends State<CustomSearchbar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    shadowColor: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(21)
    ),
      child: Container(
        padding: EdgeInsets.only(left: 20,right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: searchBoxColor
        ),
        child: TextFormField(
          onTap: widget.onTap,
          controller: widget.controller,
          style: TextStyle(color: customTextColor),
          decoration: InputDecoration(
            label: Text(widget.label!),
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search,color: Colors.white,),

          ),
        ),
      ),
    );
  }
}
