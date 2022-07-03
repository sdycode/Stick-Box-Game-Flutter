import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/app_drawer.dart';
import 'package:stick_box/customshape.dart';
import 'package:stick_box/grid_page.dart';
import 'package:stick_box/provder.dart';

import 'comp_gridPage.dart';
import 'constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TextEditingController p1controller = TextEditingController(text: 'Player 1');
  TextEditingController p2controller = TextEditingController(text: 'Player 2');

  TextEditingController compcontroller =
      TextEditingController(text: 'Computer');
  late vp p;
  List<int> boxesinrow = [9, 17, 25, 33, 41, 49, 57, 65, 73];
  int whichGridNo = 0;
  int playerNo = 0;
  int p1no = 0;
  int p2no = 4;
  bool isSingle = true;
  String p1name = 'Player 1';
  String p2name = 'Computer';
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  List<double> offs = [0, 31];
  late Animation<double> lanimation;
  late AnimationController lcontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioCache.load('tap2.mp3');
    lcontroller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    lanimation = Tween<double>(begin: -300, end: 0).animate(lcontroller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    lcontroller.forward();
    // gridController = ScrollController()
    //   ..addListener(() {
    //     setState(() {
    //        offs[0]= offs[1];
    //       offs[1]= gridController.offset;

    //        if((offs[0]-offs[1]).abs() >5){
    //          whichGridNo = (gridController.offset / (100 +whichGridNo*5)).toInt();
    //       // ${gridController.position}
    //        print("offset  ${whichGridNo}  = ${gridController.offset}  --");
    //     //
    //     //    print("offset =    ${gridController.offset}  =====  ${(offs[0]-offs[1]).abs()}   ");
    //      }

    //     });
    //     // if(gridController.offset)
    //     // print("offset  ${gridController.position} = ${gridController.offset}  -- ${gridController.}");
    //     // setState(() {
    //     //   print('offf ${gridController.offset}');
    //     //   // _offset = gridController.offset;
    //     // });
    //     //  if(gridController.position )

    //     //
    //   });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    audioPlayer.release();
  }

  double cellw = 5;
  double hlinew = 50;
  double hlineh = 5;
  double vlinew = 5;
  double vlineh = 50;
  double box = 50;
  List<Offset> hPoints = [];
  List<Offset> vPoints = [];
  ScrollController gridController = ScrollController();
  double t = 24;
  double circleh = 0.065;
  double circlehinner = 0.06;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    t = MediaQuery.of(context).viewPadding.top;
    p = Provider.of<vp>(context);

    // h = h - t;
    print('offff  ---------------------${w * 0.9}');
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: AppDrawer(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.white,
        //   onPressed: () {

        // },
        // child: Image.asset('assets/menu.png'), ),
        body: Container(
          height: h,
          width: w,
          //
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.all(w*0.02),
                      margin:
                          EdgeInsets.only(top: t + w * 0.02, right: w * 0.02),
                      child: Image.asset(
                        'assets/menudots.png',
                        height: w * 0.08,
                      ))),
            ),
            Column(
              children: [
                SizedBox(
                  height: t,
                ),
                Spacer(),
                // Stack(
                //   children: [
                //     Container(
                //       width: double.infinity,
                //       child: Image,
                //     ),
                //   ],
                // )
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(lanimation.value, 0),
                      child: Image.asset(
                        'assets/stick.png',
                        height: h * 0.1,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-lanimation.value, 0),
                      child: Image.asset(
                        'assets/box.png',
                        height: h * 0.1,
                      ),
                    ),
                    // TweenAnimationBuilder(curve: Curves.bounceOut,
                    //     builder:
                    //         (BuildContext context, Offset? value, Widget? child) {
                    //       return Transform.translate(offset: value!,

                    //        child: Image.asset(
                    //       'assets/stick.png',
                    //       height: h * 0.1,
                    //     )
                    //       ,);
                    //     },
                    //     duration: Duration(milliseconds: 1200),
                    //     tween: Tween<Offset>(begin: Offset(-100,0), end: Offset.zero ),
                    //     ),
                    // TweenAnimationBuilder(
                    //   curve: Curves.bounceOut,
                    //     builder:
                    //         (BuildContext context, Offset? value, Widget? child) {
                    //       return Transform.translate(offset: value!,

                    //        child: Image.asset(
                    //       'assets/box.png',
                    //       height: h * 0.1,
                    //     )
                    //       ,);
                    //     },
                    //     duration: Duration(milliseconds: 1200),
                    //     tween: Tween<Offset>(begin: Offset(100,0), end: Offset.zero ),
                    //     ),
                  ],
                ),
                Spacer(),

                Container(
                    height: w * 0.2 * 2 - t,
                    width: w,
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //     image: AssetImage(
                        // 'assets/frame3.png',
                        //     ),
                        //     fit: BoxFit.fill)
                        //  color: Colors.pink.shade100,
                        ),

                    // padding: EdgeInsets.all(w * 0.18),
                    padding: EdgeInsets.only(
                        // left: w * 0.06,
                        // right: w * 0.06,
                        top: w * 0.005,
                        bottom: w * 0.005),
                    child: Center(
                      child: CarouselSlider.builder(
                        itemBuilder:
                            (BuildContext context, int i, int realIndex) {
                          // whichGridNo = (i - 1) % 6;
                          // print('whichg  $whichGridNo');
                          // double wi = w * 0.9;
                          // int gridno = i + 1;
                          // double boxsize =
                          //     (((wi) ~/ boxesinrow[i + 1]) * boxesinrow[i + 1])
                          //         .toDouble();

                          // cellw = boxsize / boxesinrow[gridno];
                          // print('boxx $i -  $boxsize  $cellw');
                          // hlinew = cellw * 7;
                          // hlineh = cellw;
                          // vlinew = cellw;
                          // vlineh = cellw * 7;
                          // box = cellw * 7;

                          // List<int> hx = List.generate(i + 1, (d) {
                          //   return d;
                          // });
                          // List<int> hy = List.generate(i + 2, (d) {
                          //   return d;
                          // });
                          // hPoints.clear();
                          // vPoints.clear();
                          // for (int j = 0; j < i + 3; j++) {
                          //   for (int k = 0; k < i + 2; k++) {
                          //     hPoints.add(
                          //         Offset(cellw + 8 * cellw * k, 8 * cellw * j));
                          //     vPoints.add(
                          //         Offset(8 * cellw * j, cellw + 8 * cellw * k));
                          //     if (i == 0) {
                          //       // print("poinss $hPoints");
                          //     }
                          //   }
                          // }

                          // print('hx $hx  , $hy');
                          return InkWell(
                            onTap: () {
                              setState(() {
                                whichGridNo = i;
                                // gridno = i + 1;
                                // boxsize = (((wi) ~/ boxesinrow[i + 1]) *
                                //         boxesinrow[i + 1])
                                //     .toDouble();
                                // cellw = boxsize / boxesinrow[gridno];
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (c) => ShapeScreen(hPoints,
                                //             vPoints, cellw, cellw * 7, i + 1)));
                              });
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: ((context) => GridPage(i + 1))));
                            },
                            child:
                                // Container(
                                //   height: boxsize,
                                //   width: boxsize,
                                //   color: Colors.pink.shade200.withAlpha(250),
                                //   child: myWrapGrid(boxsize, (i +1) * 2 + 3, i+1),
                                // ),

                                Transform.scale(
                              scale: whichGridNo == i ? 1.1 : 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: whichGridNo == i
                                        ? Border.all(width: 2)
                                        : null),
                                margin: EdgeInsets.all(w * 0.04),
                                padding: EdgeInsets.all(w * 0.011),
                                child: Image.asset(
                                  C.gridimgs[i],
                                  color: C.gridcolors[i],
                                ),
                                // grid(i, w * 0.20)

                                // Center(4
                                //   child: Text('${i + 2} x ${i + 2} '),
                                // ),
                              ),
                            ),
                          );
                        },
                        itemCount: 6,
                        options: CarouselOptions(
                            pauseAutoPlayOnManualNavigate: true,
                            pauseAutoPlayOnTouch: true,
                            onPageChanged: (d, s) {
                              setState(() {
                                whichGridNo = d;
                                print('whichbg page $whichGridNo');
                              });
                            },
                            enlargeCenterPage: true,
                            autoPlay: false,
                            viewportFraction: 0.55),
                      ),
                    )
                    // GridView.builder(
                    //     controller: gridController,
                    //     findChildIndexCallback: (j) {
                    //       print("printttt grid $j");
                    //     },
                    //     // padding: EdgeInsets.all(0),
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: 6,
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //             crossAxisCount: 1),
                    //     itemBuilder: (c, i) {

                    //     }),

                    ),
                Spacer(),
                Container(
                  height: h * circleh * 1.2,
                  width: w,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: C.icons.length - 1,
                      itemBuilder: (c, i) {
                        return InkWell(
                          onTap: () {
                            lcontroller.reset();
                            lcontroller.stop();
                            lcontroller.forward();
                            audioCache.play('boxmarked.mp3');
                            setState(() {
                              if (playerNo == 0 && p2no != i) {
                                p1no = i;
                              }
                              if (playerNo == 1 && p1no != i) {
                                p2no = i;
                              }
                            });
                          },
                          child: Container(
                              // color:   Colors.red.withAlpha(i*10+50),
                              padding: EdgeInsets.all(h * circleh * 0.1),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(h * circleh * 0.8),
                                child: Image.asset(C.icons[i]),
                              )
                              //  CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   radius: h * circleh*0.8,
                              //   backgroundImage: AssetImage(C.icons[i]),
                              // ),
                              ),
                        );
                      }),
                ),
                Spacer(),
                isSingle
                    ? 
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                       
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: h * circleh,
                                backgroundColor: playerNo == 0
                                    ? Colors.black
                                    : Colors.grey.shade200,
                                child: InkWell(
                                  radius: h * circleh,
                                  onTap: () {
                                    setState(() {
                                      playerNo = 0;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: h * circlehinner,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      C.icons[p1no],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(h * 0.02),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(h * 0.02 * 0),
                                  child: Container(
                                    height: h * circlehinner,
                                    width: w * 0.4,
                                    child:
                                        Image.asset('assets/player1nobg.webp'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: h * circleh,
                                    backgroundColor: Colors.black,
                                    child: CircleAvatar(
                                      radius: h * circleh * 0.97,
                                      backgroundColor: Colors.white,
                                      // backgroundImage: AssetImage(
                                      //   C.icons.last,
                                      // ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          h * circleh * 0.95,
                                        ),
                                        child: Container(
                                          height: h * circleh * 2 * 0.95,
                                          width: h * circleh * 2 * 0.95,
                                          padding: EdgeInsets.all(h * 0.01),
                                          child: Image.asset(
                                            C.icons.last,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(h * 0.02),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(h * 0.02 * 0),
                                  child: Container(
                                    height: h * circlehinner,
                                    width: w * 0.4,
                                    child: Image.asset('assets/comp.png'),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                       
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    playerNo = 0;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: h * circleh,
                                  backgroundColor: playerNo == 0
                                      ? Colors.black
                                      : Colors.grey.shade200,
                                  child: CircleAvatar(
                                    radius: h * circlehinner,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      C.icons[p1no],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(h * 0.02),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(h * 0.02 * 0),
                                  child: Container(
                                    height: h * circlehinner,
                                    width: w * 0.4,
                                    child:
                                        Image.asset('assets/player1nobg.webp'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    playerNo = 1;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: h * circleh,
                                  backgroundColor: playerNo != 0
                                      ? Colors.black
                                      : Colors.grey.shade200,
                                  child: CircleAvatar(
                                    radius: h * circlehinner,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(
                                      C.icons[p2no],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(h * 0.02),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(h * 0.02 * 0),
                                  child: Container(
                                    height: h * circlehinner,
                                    width: w * 0.4,
                                    child:
                                        Image.asset('assets/player2nobg.webp'),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSingle = true;
                          playerNo = 0;
                          audioCache.play('smalltap.mp3');
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(w * 0.04),
                            border: isSingle
                                ? Border.all(width: 2, color: Colors.orange)
                                : null,
                            boxShadow: isSingle
                                ? [
                                    BoxShadow(
                                        color: Colors.deepOrange,
                                        offset: Offset(0.5, 0.51),
                                        spreadRadius: 1,
                                        blurRadius: 1.5)
                                  ]
                                : []),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(w * 0.04),
                          child: Image.asset(
                            'assets/single.gif',
                            width: w * 0.36,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSingle = false;
                          audioCache.play('smalltap.mp3');
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(w * 0.04),
                            border: !isSingle
                                ? Border.all(width: 2, color: Colors.orange)
                                : null,
                            boxShadow: !isSingle
                                ? [
                                    BoxShadow(
                                        color: Colors.deepOrange,
                                        offset: Offset(0.5, 0.51),
                                        spreadRadius: 1,
                                        blurRadius: 1.5)
                                  ]
                                : []),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(w * 0.04),
                            child: Image.asset(
                              'assets/two.gif',
                              width: w * 0.36,
                            )),
                      ),
                    )
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    audioCache.play('tap2.mp3');
                    double wi = w * 0.9;
                    int i = whichGridNo;
                    // whichGridNo = i;
                    double boxsize =
                        (((wi) ~/ boxesinrow[i + 1]) * boxesinrow[i + 1])
                            .toDouble();
                    int gridno = i + 1;
                    cellw = boxsize / boxesinrow[gridno];
                    print(' randd ${wi} / ${i+1} / ${gridno} / ${boxsize} / ${cellw}');

                    List<int> hx = List.generate(i + 1, (d) {
                      return d;
                    });
                    List<int> hy = List.generate(i + 2, (d) {
                      return d;
                    });
                    hPoints.clear();
                    vPoints.clear();
                    for (int j = 0; j < i + 3; j++) {
                      for (int k = 0; k < i + 2; k++) {
                        hPoints
                            .add(Offset(cellw + 8 * cellw * k, 8 * cellw * j));

                        if (i == 0) {
                          print("poinss $hPoints");
                        }
                      }
                    }
                    for (int k = 0; k < i + 2; k++) {
                      for (int j = 0; j < i + 3; j++) {
                        vPoints
                            .add(Offset(8 * cellw * j, cellw + 8 * cellw * k));
                        if (i == 0) {
                          print("poinss $hPoints");
                        }
                      }
                    }
                    p.initMusicCahce();
                    p.startMusicLoop();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (c) => ShapeScreen(
                    //             hPoints, vPoints, cellw, cellw * 7, i + 1)));
                    if (isSingle) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => CompGridPage(
                                    whichGridNo + 1,
                                    p1no,
                                    C.icons.indexOf(C.icons.last),
                                    hPoints,
                                    vPoints,
                                    cellw,
                                    cellw * 7,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => GridPage(
                                    whichGridNo + 1,
                                    p1no,
                                    p2no,
                                    hPoints,
                                    vPoints,
                                    cellw,
                                    cellw * 7,
                                  )));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(h * 0.02),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(h * 0.02),
                      child: Container(
                        padding: EdgeInsets.all(h * 0.03),
                        color: Colors.black,
                        height: h * 0.1,
                        width: w * 0.65,
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset('assets/play1.webp')),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget myWrapGrid(double d, int ind, int gridno) {
    List<Widget> boxList = [];
    print("main widrht     $d");
    for (int i = 0; i < ind * ind; i++) {
      boxList.add(myBox(i, d, ind, gridno));
    }
    return Wrap(
      children: [...boxList],
    );
  }

  Widget myBox(int i, double d, int count, int gridno) {
    // print('line index $lineindex');
    Color color = Colors.white;
    // BoxType boxType = BoxType.dot;
    // if (lines.containsKey(i)) {
    //   boxType = BoxType.hline;
    //   color = (lines[i]!.index == i && lines[i]!.marked
    //       ? lines[i]!.player == 1
    //           ? C.p1color
    //           : lines[i]!.player == 2
    //               ? C.p2color
    //               : C.colors[WhichColor.vlineshow]
    //       : C.colors[WhichColor.vlinehide])!;
    // } else if (boxes.containsKey(i)) {
    //   boxType = BoxType.box;

    //   color = (boxes[i]!.index == i && boxes[i]!.marked
    //       ? C.colors[WhichColor.boxmarked]
    //       : C.colors[WhichColor.boxNotMarked])!;
    // } else {
    //   color = Colors.black;
    // }

    // color = boxes.containsKey(i)
    //     ? boxes[i]!.index == i
    //         ? C.colors[WhichColor.boxNotMarked]
    //         : C.colors[WhichColor.boxNotMarked]
    //     : C.colors[WhichColor.boxNotMarked];

    return IgnorePointer(
      ignoring: true,
      //  lines.containsKey(i) ? false : true,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: getWidth(i, count, d, gridno),
          height: getHeight(i, count, d, gridno),
          decoration: BoxDecoration(
            color: Color.fromARGB(
                255,
                i * 10 + Random().nextInt(300),
                255 - i * 5 + Random().nextInt(300),
                i * 3 + Random().nextInt(300)),
            // color: color,
            // border: lastLineIndex == i ? Border.all():null
          ),
          // child: Center(child: Text(i.toString())),
          // color: lastLineIndex == i ? Color.fromARGB(255, 68, 73, 232) : color,
          // color:color,
          // child: boxType == BoxType.box ? boxWidget(i) : Center(),
        ),
      ),
    );
  }

  getWidth(int i, int count, double d, int gridno) {
    double w = 50;

    int half = (count / 2).toInt();

    double x = d / boxesinrow[gridno];
    // print("xxxxxxxxxx    $x");
    // x = 41.67 * 0.5;

    if ((i % count) % 2 == 0) {
      w = x;
    } else {
      w = 7 * x;
    }

    return w;
  }

  getHeight(int i, int count, double d, int gridno) {
    // print(d.toString() + "dddddddd");
    double h = 50;
    int half = (count / 2).toInt();

    double x = d / boxesinrow[gridno];
    // x = 41.67 * 0.5;
    if (i % (2 * count) < count) {
      // line and dot row (only lines and dots)
      h = x;
    } else {
      h = 7 * x;
    }
    return h;
  }

  Widget grid(int ind, double d) {
    double gap = d * 0.06 / (ind + 1);
    gap = 2;
    return Container(
      height: d,
      // width: d,
      padding: EdgeInsets.all(gap),
      color:
          // Colors.red,
          C.gridcolors[ind],
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: EdgeInsets.only(top: gap),
          itemCount: (ind + 2) * (ind + 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // mainAxisExtent:d*0.5,
              childAspectRatio: 1.2,
              crossAxisSpacing: gap,
              mainAxisSpacing: gap,
              crossAxisCount: ind + 2),
          itemBuilder: (c, i) {
            return Container(
              color: Color.fromARGB(255, 244, 244, 182).withAlpha(255),
            );
          }),
    );
  }
}
