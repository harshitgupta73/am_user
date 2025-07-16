import 'package:am_user/widgets/constants/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListDetailsCard extends StatefulWidget {
  String? image;
  String? name;
  String? work;

   ListDetailsCard({super.key,required this.work, required this.name, required this.image});

  @override
  State<ListDetailsCard> createState() => _ListDetailsCardState();
}

class _ListDetailsCardState extends State<ListDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow:[
          BoxShadow(
            color: Colors.white60,
            blurRadius: 5,
            spreadRadius:1,
            offset: Offset(1, 2)
          ),
        ]
      ),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.image!),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name!,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),
              Text(widget.work!),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:Colors.deepPurple,
              shape: BoxShape.circle
            ),
            child:Icon(Icons.phone,color: CupertinoColors.white,),
          )
          

        ],
      ),
    );
  }
}
