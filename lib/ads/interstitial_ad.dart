// /*
// * Add below in pubspec.yaml
// * google_mobile_ads: ^0.13.2
// * shared_preferences: ^2.0.6
// *
// *
// * AndroidManifest.xml
// * <meta-data
// *     android:name="com.google.android.gms.ads.APPLICATION_ID"
// *     android:value="ca-app-pub-3940256099942544~3347511713"/>
// * Dont forget to replace actual appid in above tag
// *
// * android/app/src/build.gradle
// * minSdkVersion 19
// *
// *
// * ios/Runner/Info.plist
// * <key>GADApplicationIdentifier</key>
// *       <string>ca-app-pub-3940256099942544~1458002511</string>
// *        <key>SKAdNetworkItems</key>
// *         <array>
// *           <dict>
// *             <key>SKAdNetworkIdentifier</key>
// *             <string>cstr6suwn9.skadnetwork</string>
// *           </dict>
// *         </array>
// * Dont forget to replace actual appid in above string tag
// *
// *
// * Call instance once only in main.dart main method
// * InterstitialAdsAdmob.instance;
// *
// * To show Interstitial Ads
// * InterstitialAdsAdmob.instance.showInterstitialAd();
// *
// * _interstitialTimer() Method
// * you can change duration/interval between interstitial ads
// * currently given 15sec
// *
// * */

// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'ads_unitid.dart';

// class InterstitialAdsAdmob {
//   static final InterstitialAdsAdmob _singleton = InterstitialAdsAdmob._init();

//   static InterstitialAdsAdmob get instance => _singleton;

//   factory InterstitialAdsAdmob() {
//     return _singleton;
//   }

//   InterstitialAdsAdmob._init() {
//     _createInterstitialAd();
//   }

//   InterstitialAd? _interstitialAd;
//   int _numInterstitialLoadAttempts = 0;
//   static const int _maxFailedLoadAttempts = 3;
//   bool _showAd = false;


  
//   InterstitialAd? _exitInterstitialAd;
//   int _numExitInterstitialLoadAttempts = 0;
//   static const int _maxExitFailedLoadAttempts = 3;

//   static final AdRequest _request = AdRequest(
//     nonPersonalizedAds: false,
//   );

//   void _createInterstitialAd([context]) {
//     print('_createInterstitialAd adcalled ');
//     _showAd = false;
//     _interstitialTimer();
//     InterstitialAd.load(
//         adUnitId: AdsUnitID.interstitialAdUnitId,
//         request: _request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             print('$ad loaded inter');
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('InterstitialAd failed to load: $error.');
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;

//             if (_numInterstitialLoadAttempts <= _maxFailedLoadAttempts) {
//               _createInterstitialAd(context);
//             }
//           },
//         ));
//   }

//   void _createExitInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: AdsUnitID.exitinterstitialAdUnitId,
//         request: _request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             print('$ad exit loaded');
//             _exitInterstitialAd = ad;
//             _numExitInterstitialLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('Exit InterstitialAd failed to load: $error.');
//             _numExitInterstitialLoadAttempts += 1;
//             _exitInterstitialAd = null;
//             if (_numExitInterstitialLoadAttempts <=
//                 _maxExitFailedLoadAttempts) {
//               _createExitInterstitialAd();
//             }
//           },
//         ));
//   }

 
// // int i, BuildContext context, Products products
//   void showInterstitialAd() {
//     print('showInterstitialAd adcalled');
//     if (_interstitialAd == null) {
//       _createInterstitialAd();
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }

//     if (!_showAd) return;

//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) {
       

//         print('ad onAdShowedFullScreenContent.');
//       },
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
      

//         ad.dispose();
//         _createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');

//         ad.dispose();
//         _createInterstitialAd();
//       },
//     );
//     _interstitialAd!.show();

//     _interstitialAd = null;
//   }

  
//   void showExitInterstitialAd() {
//     if (_exitInterstitialAd == null) {
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }

//     _exitInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) {
//         print('exit ad onAdShowedFullScreenContent.  open ad called');
        
//       },
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
      
//         print('$ad exit onAdDismissedFullScreenContent.  open ad called');
//         ad.dispose();
//         _createExitInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('$ad exit onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createExitInterstitialAd();
//       },
//     );
//     _exitInterstitialAd!.show();
//     _exitInterstitialAd = null;
//   }

 

//   void _interstitialTimer() {
//     Future.delayed(const Duration(milliseconds: 4000), () {
//       _showAd = true;
//     });
//   }
// }
