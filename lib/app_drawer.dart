import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stick_box/constants.dart';
import 'package:stick_box/sizes.dart';

// import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../constants/colors.dart';
// import '../constants/constants.dart';
// import '../constants/sizes.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  double w = Sizes().sw;
  double iconH = 0.045;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Sizes().sw * 0.7,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          color: Colors.transparent,
          image: DecorationImage(
              image: AssetImage('assets/drbg1.jpg'), fit: BoxFit.cover),
        ),
        margin: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top * 2,
            bottom: MediaQuery.of(context).viewPadding.top * 2),
        // color: Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: Drawer(
            // backgroundColor: Colors.white,
            child: Container(
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover),
              ),
              child: ListView(
                children: [
                  // Align(
                  //     alignment: Alignment.topRight,
                  //     child: InkWell(
                  //         onTap: () {
                  //           Navigator.pop(context);
                  //         },
                  //         child: Container(
                  //            margin: EdgeInsets.all(10),
                  //           child: Icon(Icons.close, size:sh * 0.04)))),
                  SizedBox(
                    height: Sizes().sh * 0.1,
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.appsharelink);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/starr.png',
                        width: w * 0.1,
                      ),
                      title: Text(
                        'Rate Us',
                        style:
                            TextStyle(color: Colors.black, fontSize: w * 0.06),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.playstorelink);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/playstore.png',
                        width: w * 0.1,
                      ),
                      title: Text(
                        'More Apps',
                        style:
                            TextStyle(color: Colors.black, fontSize: w * 0.06),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.linkedinlink);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/linkedin.png',
                        width: w * 0.1,
                      ),
                      title: Text(
                        'Linked In',
                        style:
                            TextStyle(color: Colors.black, fontSize: w * 0.06),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.youtubevideolink);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/youtube.png',
                        width: w * 0.1,
                      ),
                      title: Text(
                        'YouTube',
                        style:
                            TextStyle(color: Colors.black, fontSize: w * 0.06),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(C.gitlink);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/git.png',
                        width: w * 0.1,
                      ),
                      title: Text(
                        'Github',
                        style:
                            TextStyle(color: Colors.black, fontSize: w * 0.06),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () async {
                      Directory? directory =
                          await getExternalStorageDirectory();
                      ByteData byteData =
                          await rootBundle.load('assets/homepageimage.jpg');
                      Uint8List rawPath = byteData.buffer.asUint8List();
                      // File file = File.fromRawPath(rawPath);
                      File file = File(directory!.path+"/shareimge.png");
                      file.writeAsBytesSync(byteData.buffer.asUint8List());
                      Share.shareFiles([file.path], subject: C.appsharelink, text:C.sharetext+"\n\n" +C.appsharelink);
                    },
                    child: ListTile(
                      leading: Image.asset(
                        'assets/share.png',
                        color: Colors.deepPurple,
                        width: w * 0.1,
                      ),
                      title: Text(
                        'Share',
                        style:
                            TextStyle(color: Colors.black, fontSize: w * 0.06),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
