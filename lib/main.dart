import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:stick_box/ads/interstitial_ad.dart';
import 'package:stick_box/customshape.dart';
import 'package:stick_box/grid_page.dart';
import 'package:stick_box/home_screen.dart';
import 'package:stick_box/provder.dart';
import 'package:stick_box/shared.dart';
import 'package:stick_box/spash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  // final RequestConfiguration requestConfiguration =
  //     RequestConfiguration(tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no);
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  // InterstitialAdsAdmob.instance;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    
    statusBarColor: Colors.transparent, // status bar color
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Shared.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> vp())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stick Box',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
