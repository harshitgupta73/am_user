import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            // margin: EdgeInsets.symmetric(vertical: 200),
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              alignment: Alignment.center,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Row(
                    children: [
                      Text(" Enter OTP ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 21),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  CustomTextField(
                    label: 'OTP',
                    inputType: TextInputType.number,
                  ),

                  SizedBox(height: 20,),
                  CustomButton(backgroundColor: backgroundColor,label: "Verify OTP", onPressed: () {
                    context.go(RoutsName.dashBord);
                  },),
                  SizedBox(height: 10,),



                ],
              ),

            ),
          ),
        ),
      ),



    );
  }
}
