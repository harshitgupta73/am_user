import 'package:am_user/widgets/component/custom_buttom.dart';
import 'package:am_user/widgets/component/custome_textfield.dart';
import 'package:am_user/widgets/constants/const.dart';
import 'package:am_user/widgets/routs/routs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AdLoginScreen extends StatefulWidget {
  const AdLoginScreen({super.key});

  @override
  State<AdLoginScreen> createState() => _AdLoginScreenState();
}

class _AdLoginScreenState extends State<AdLoginScreen> {


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
                      Text(" Login ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 21),),
                    ],
                  ),
                  SizedBox(height: 20,),

                  ClipRRect(
                    child: Image.asset("assets/images/amuserlogo.png",height: 150,fit: BoxFit.cover,),
                  ),

                  Text("Ready to Connect",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),),
                  SizedBox(height: 20,),

                  CustomTextField(
                    label: 'Contact No',
                    inputType: TextInputType.number,
                  ),

                  SizedBox(height: 20,),
                  CustomButton(backgroundColor: backgroundColor,label: "Login", onPressed: () {
                    context.go(RoutsName.otpScreen);
                  },),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("I have,t Account? Register",style: TextStyle(color: Colors.white),)
                    ],
                  )


                ],
              ),

            ),
          ),
        ),
      ),



    );
  }
}
