import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class Sizes extends StatelessWidget {
  Sizes({Key? key}) : super(key: key);
  double sw = ui.window.physicalSize.width / ui.window.devicePixelRatio;
  double sh = ui.window.physicalSize.height / ui.window.devicePixelRatio;
  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    sw = w; 
    sh =h; 

    return Container();
  }
}