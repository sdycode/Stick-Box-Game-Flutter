import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stick_box/grid_page.dart';
import 'package:stick_box/home_screen.dart';
import 'package:stick_box/spash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stick Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
