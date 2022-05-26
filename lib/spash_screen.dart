import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stick_box/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // audioCache.load('win.mp3');
    // audioCache.play('win.mp3');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    audioPlayer.release();
    audioCache.clearAll();
  }

  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then(
      (value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      },
    );
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: Duration(seconds: 2),
              tween: Tween<double>(begin: 1.0, end: 1.6),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                      // height: w * 0.4,
                      child: Column(
                    children: [
                      Container(
                          height: w * 0.25,
                          child: Image.asset('assets/flutterlogo.png')),
                      RichText(
                        text: TextSpan(
                          text: 'made with  ',
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.white60,
                              fontSize: w * 0.02),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Flutter',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white60,
                                  fontSize: w * 0.03),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      // color: Colors.amber,
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
