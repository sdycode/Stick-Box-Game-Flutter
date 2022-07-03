import 'package:flutter/material.dart';

enum WhichColor {
  vlineshow,
  vlinehide,
  hlineshow,
  hlinehide,
  dot,
  boxmarked,
  boxNotMarked
}

class C {
  static List<String> icons = [
    "assets/boy1.webp",
    "assets/girl1.webp",
    "assets/man1.webp",
    "assets/boy2.webp",
    "assets/girl2.webp",
    "assets/boy3.webp",
    "assets/man2.webp",
    "assets/girl3.webp",
    "assets/man3.webp",
    "assets/brain2.png"
  ];
  static List<Color> gridcolors = [
    Color.fromARGB(255, 248, 124, 15),
    Color.fromARGB(255, 6, 132, 48),
    Colors.pink,
    Color.fromARGB(255, 30, 47, 233),
    Color.fromARGB(255, 238, 192, 67),
    Color.fromARGB(255, 64, 113, 26),
  ];

  static List<String> gridimgs = [
    "assets/grid2.png",
    "assets/grid3.png",
    "assets/grid4.png",
    "assets/grid5.png",
    "assets/grid6.png",
    "assets/grid7.png"
  ];
  static String appsharelink =
      'https://play.google.com/store/apps/details?id=com.sdyapps22.stickbox';
  static String playstorelink =
      'https://play.google.com/store/apps/developer?id=Shubham+Yeole';
  static String linkedinlink =
      'https://www.linkedin.com/in/shubham-yeole-344307109/';
  static String youtubevideolink =
      "https://www.youtube.com/watch?v=-goel9qSKvE";
static String gitlink ="https://github.com/sdycode/Stick-Box-Game-Flutter";
  static Color p1color = Colors.pink;

  static Color p2color = Colors.orange;
  static Color linemarkedcolor = Colors.red;
  static Map<WhichColor, Color> colors = {
    WhichColor.vlinehide: Colors.grey.shade200,
    WhichColor.hlinehide: Colors.grey.shade200,
    WhichColor.vlineshow: Colors.pink,
    WhichColor.hlineshow: Color.fromARGB(255, 196, 143, 63),
    WhichColor.dot: Colors.black,
    WhichColor.boxmarked: Color.fromARGB(0, 216, 231, 236),
    WhichColor.boxNotMarked: Color.fromARGB(0, 239, 225, 242).withAlpha(0)
  };

  static String sharetext = "Play and Enjoy Stick Box Game !!!";

  
}
