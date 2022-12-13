import 'package:flutter/material.dart';

class AppColors{

  MaterialColor get getMaterialColor{
        Map<int, Color> color =
{
50:const Color.fromRGBO(4,131,184, .1),
100:const Color.fromRGBO(4,131,184, .2),
200:const Color.fromRGBO(4,131,184, .3),
300:const Color.fromRGBO(4,131,184, .4),
400:const Color.fromRGBO(4,131,184, .5),
500:const Color.fromRGBO(4,131,184, .6),
600:const Color.fromRGBO(4,131,184, .7),
700:const Color.fromRGBO(4,131,184, .8),
800:const Color.fromRGBO(4,131,184, .9),
900:const Color.fromRGBO(4,131,184, 1),
};
     MaterialColor myColor = MaterialColor(0xffFD0070, color);
     return myColor;
  }
  
  final white = const Color(0xffffeded);
  final white40 = const Color(0x66ffeded);
  final black = const Color(0xff000000);
  final darkGrey = const Color(0xff4D4D4D);
  final primaryColor = const Color(0xffFD0070);
  final primaryColor50 = const Color(0xffBA0051);
  final secondaryColor = const Color(0xff750033);
  final unSelectedGrey = const Color(0xffadadad);
  final textGrey = const Color(0xff4D4D4D);
  final bjpOrange = const Color(0xffFC8200);

  const AppColors();

}