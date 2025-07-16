import 'package:flutter/cupertino.dart';

class Responsive{
 static  bool isMobile (BuildContext context) => MediaQuery.of(context).size.width<600;
 static bool isTab (BuildContext context) => MediaQuery.of(context).size.width>600;
 static bool isDesktop (BuildContext context) => MediaQuery.of(context).size.width>900;
}