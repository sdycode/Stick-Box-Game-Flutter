import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:stick_box/ads/interstitial_ad.dart';
import 'package:stick_box/box_model.dart';
import 'package:stick_box/provder.dart';
import 'package:stick_box/shared.dart';
import 'package:stick_box/sizes.dart';

import 'constants.dart';

class GridPage extends StatefulWidget {
  int gridno;
  int p1no;
  int p2no;
  List<Offset> hPoints;
  List<Offset> vPoints;
  double x;
  double s;
  GridPage(this.gridno, this.p1no, this.p2no, this.hPoints, this.vPoints,
      this.x, this.s,
      {Key? key})
      : super(key: key);

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> with WidgetsBindingObserver {
  List<int> boxesinrow = [9, 17, 25, 33, 41, 49, 57, 65, 73];
  Map<int, LineModel> lines = {};
  Map<int, BoxModel> boxes = {};
  bool goBack = false;
  late vp p;

  int gridno = 0;
  int lastLineIndex = -1;
  Offset transOffset = Offset.zero;
  int count = 5;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  double ratio = Sizes().sh / Sizes().sw;
  // AudioPlayer musicPlayer = AudioPlayer();
  // AudioCache musciCashe = AudioCache();
  bool isSound = true;
  List<int> countsList = [];
  double volumeslidervalue = Shared.getVolume();

  bool showVolumeSlider = false;
  bool showSettings = false;
  double bh = 10;
  double bw = 10;
  // double boxsize = 100;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    print("wid ${widget.hPoints}");
    // audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioCache.load('smalltap.mp3');
    audioCache.load('boxmarked.mp3');
    audioCache.load('drawgame.mp3');
    audioCache.load('wingame.mp3');
    audioCache.load('boxdone.mp3');
    // musicPlayer.setVolume(volumeslidervalue);
    // musciCashe = AudioCache(fixedPlayer: musicPlayer);

    // musciCashe.load('gamemusic.mp3');
    // // musciCashe.play('gamemusic.mp3');
    // musciCashe.loop('gamemusic.mp3', volume: volumeslidervalue);

    checkSound();
    // TODO: implement initState
    super.initState();
    gridno = widget.gridno;
    count = (gridno * 2 + 3);
    boxes.clear();
    lines.clear();
    resetLinesandBoxes();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
    // musicPlayer.stop();
    // musciCashe.clearAll();
    audioPlayer.release();
    // musicPlayer.release();

    audioPlayer.dispose();
    // musicPlayer.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    //   _lastLifecycleState = state;
    // });
    if (state == AppLifecycleState.paused) {
      p.pause();
      print('player pausedd');
      // setState(() {
      //   volumeslidervalue = 0.0;

      //   // musicPlayer.pause();
      // });
    }
    if (state == AppLifecycleState.resumed) {
      p.resume();

      print('player resumed');
      // setState(() {
      //   volumeslidervalue = 0.1;
      //   // musicPlayer.resume();
      // });
    }
  }

  double zoomScale = 1.0;
  double tempScale = 1.0;
  List<double> scales = [1.0, 1.0];
  int scalecount = 0;
  bool turn1 = true;
  bool isBoxDone = false;
  StateSetter lineStater = (d) {};
  bool isGameOver = false;
  int whoWins = 0;
  double h = Sizes().sh;
  double w = Sizes().sw;
  double v = 0.05;
  double rem = 50;

  @override
  Widget build(BuildContext context) {
    p = Provider.of<vp>(context);
    double wi = w * 0.9;
    final Shader linearGradient1 = const LinearGradient(
      colors: <Color>[
        Color.fromARGB(255, 1, 34, 110),
        Color.fromARGB(255, 21, 80, 216)
      ],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );
    final Shader linearGradient2 = const LinearGradient(
      colors: <Color>[Colors.pink, Color.fromARGB(255, 245, 39, 39)],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );
    final Shader linearGradient3 = const LinearGradient(
      colors: <Color>[Colors.pink, Color.fromARGB(255, 6, 120, 6)],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );

    double boxsize =
        (((wi) ~/ boxesinrow[gridno]) * boxesinrow[gridno]).toDouble();
    print('  ${boxsize}');
    //  if (!Shared.isRatedFun()) {
    //       showRateUsDialog();
    //     }
    print('is rated ${Shared.isRatedFun()}');
    return WillPopScope(
      onWillPop: () async {
        showAskDialog(context);

        return true;
      },
      child: Scaffold(
        body: Container(
          height: h,
          width: w,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w,
                // color: Colors.red,
                height: MediaQuery.of(context).viewPadding.top + h * 0.001,
              ),
              Container(
                height: h * 0.05,
                // color: Colors.amber,
                child: Padding(
                  padding: EdgeInsets.all(h * 0.001),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: showSettings
                          ? [back(), replay(), sound(), music(), setting()]
                          : [
                              back(),
                              replay(),
                              // Text(' ${(h / w).toStringAsFixed(2)} ' +
                              //     rem.toString() +
                              //     ' h ${h.round()} / w ${w.round()} / ${boxsize} / ${widget.x} / ${((w - boxsize) * 0.5).toStringAsFixed(1)}'),
                              
                              setting()
                            ]),
                ),
              ),

              showSettings
                  ? Container(
                      height: h * 0.05,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top:h*0.006, bottom:h*0.006),
                            child: Image.asset(
                              'assets/music.png',
                              width: w * 0.2,
                              // height: h*0.04,
                            ),
                          ),
                          Container(
                            width: w * 0.78,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 2,
                                activeTrackColor:
                                    Color.fromARGB(255, 170, 122, 11),
                                thumbColor: Color.fromARGB(255, 236, 147, 22),
                                inactiveTrackColor:
                                    Color.fromARGB(255, 233, 221, 131),
                              ),
                              child: Slider(
                                  value: volumeslidervalue,
                                  min: 0.0,
                                  max: 0.5,
                                  onChanged: (d) {
                                    setState(() {
                                      volumeslidervalue = d;
                                      // musicPlayer.setVolume(volumeslidervalue);
                                      // Shared.setVolume(volumeslidervalue);
                                      p.setVolume(volumeslidervalue);
                                    });
                                  }),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              // Spacer(),
              Container(
                // color: Colors.green, 


              child: iconswithCelebration()),
              Spacer(),
              Container(
                  // color: Colors.red,
                  padding: EdgeInsets.only(top: 1, bottom: 1),
                  child: ClipRRect(
                    child: Transform.translate(
                      offset: Offset(transOffset.dx, transOffset.dy + 50 * 0),
                      child: Transform.scale(
                        scale: zoomScale,
                        child: GestureDetector(
                          child: Stack(
                            children: [
                              // ...widgets.map((e) => null)

                              Container(
                                // padding: EdgeInsets.all(w-boxsize),
                                padding: EdgeInsets.all((w - boxsize) * 0.5),
                                // padding: EdgeInsets.all(widget.x),
                                child: Container(
                                  height: boxsize,
                                  width: boxsize,
                                  color: Colors.pink.shade200.withAlpha(20),
                                  child: myWrapGrid(boxsize, gridno * 2 + 3),
                                ),
                              ),

                              ...(widget.hPoints.map((e) {
                                return Positioned(
                                  left: e.dx + (w - boxsize) * 0.5,

                                  //  widget.x,
                                  top: e.dy +
                                      ((w - boxsize) * 0.5 - widget.x).abs(),
                                  child: Transform.scale(
                                    scaleY: widget.x < 10 ? 1.5 : 1,
                                    child: Container(
                                      color:
                                          Colors.green.shade300.withAlpha(0),
                                      child: ClipPath(
                                        clipper: MyPointsHLinesClipper(
                                            widget.x, widget.s),
                                        child: GestureDetector(
                                          onTapDown: (d) {
                                            print(
                                                'tap point hhhh line clicked with ${d.localPosition.dx} & ${d.localPosition.dy}');
                                            int finali = 0;
                                            int indx =
                                                widget.hPoints.indexWhere((ee) {
                                              return ee == e;
                                            });
                                            int k = indx ~/ (widget.gridno + 1);
                                            int l = indx % (widget.gridno + 1);
                                            int n = (widget.gridno + 1) * 2 + 1;
                                            finali = k * n * 2 + 2 * (l) + 1;

                                            if (lines.containsKey(finali) &&
                                                !lines[finali]!.marked) {
                                              setState(() {
                                                isSound
                                                    ? audioCache
                                                        .play('smalltap.mp3')
                                                    : () {};

                                                lines[finali]!.marked = true;
                                                // !lines[finali]!.marked;
                                                lines[finali]!.player =
                                                    turn1 ? 1 : 2;
                                                print(
                                                    'box 000000000000000000000000');
                                                isBoxDone = false;
                                                updateBox(finali);
                                                checkGameOver();

                                                if (isBoxDone) {
                                                  isSound
                                                      ? audioCache
                                                          .play('boxmarked.mp3')
                                                      : () {};
                                                } else {
                                                  turn1 = !turn1;
                                                }

                                                lastLineIndex = finali;
                                              });
                                            }
                                            lines.forEach((key, value) {
                                              print(
                                                  "keyy $key -  ${value.marked}  - ${value.index} / $finali ");
                                            });

                                            print(
                                                'valuesss $k / $n / ${widget.gridno} / $indx  / $finali');
                                          },
                                          child: Container(
                                              height: widget.x * 3,
                                              width: widget.s,
                                              color: Color.fromARGB(
                                                      255, 108, 79, 255)
                                                  .withAlpha(0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()),

                              ...(widget.vPoints.map((e) {
                                return Positioned(
                                  left: e.dx +
                                      ((w - boxsize) * 0.5 - widget.x).abs(),
                                  top: e.dy + (w - boxsize) * 0.5,
                                  // widget.x,
                                  child: Transform.scale(
                                    scaleX: widget.x < 10 ? 1.5 : 1,
                                    child: Container(
                                      color:
                                          Colors.purple.shade300.withAlpha(0),
                                      child: GestureDetector(
                                        onTapDown: (d) {
                                          print(
                                              'tap point vvvvv line clicked with ${d.localPosition.dx} & ${d.localPosition.dy}');
                                          int finali = 0;
                                          int indx =
                                              widget.vPoints.indexWhere((ee) {
                                            return ee == e;
                                          });
                                          int k = indx ~/ (widget.gridno + 2);
                                          int l = indx % (widget.gridno + 2);
                                          int n = (widget.gridno + 1) * 2 + 1;
                                          finali = k * n * 2 + 2 * (l) + n;
                                          print(
                                              'valuesss $k / $n / $l /  ${widget.gridno} / $indx  / $finali');
                                          if (lines.containsKey(finali) &&
                                              !lines[finali]!.marked) {
                                            setState(() {
                                              isSound
                                                  ? audioCache
                                                      .play('smalltap.mp3')
                                                  : () {};

                                              lines[finali]!.marked = true;
                                              // !lines[finali]!.marked;
                                              lines[finali]!.player =
                                                  turn1 ? 1 : 2;
                                              print(
                                                  'box 000000000000000000000000');
                                              isBoxDone = false;
                                              updateBox(finali);
                                              checkGameOver();

                                              if (isBoxDone) {
                                                isSound
                                                    ? audioCache
                                                        .play('boxmarked.mp3')
                                                    : () {};
                                              } else {
                                                turn1 = !turn1;
                                              }

                                              lastLineIndex = finali;
                                            });
                                          }
                                          // lines.forEach((key, value) {
                                          //   print(
                                          //       "keyy $key -  ${value.marked}  - ${value.index} / $finali ");
                                          // });
                                        },
                                        child: ClipPath(
                                          clipper: MyPointsVLinesClipper(
                                              widget.x, widget.s),
                                          child: Container(
                                              width: widget.x * 3,
                                              height: widget.s,
                                              color: Color.fromARGB(
                                                      255, 220, 2, 194)
                                                  .withAlpha(0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList())
                              // Positioned(
                              //     left: 150,
                              //     top: 300,
                              //     child: InkWell(
                              //       onTap: () {
                              //         setState(() {});
                              //       },
                              //       child: Container(
                              //         height: widget.x * 3,
                              //         width: widget.s,
                              //         color: Colors.purple.shade300,
                              //         child: ClipPath(
                              //           clipper: MyPointsClipper(widget.x, widget.s),
                              //           child: Container(color: Colors.amber.shade300),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              Spacer(),

              // Container(
              //   color: Colors.amber,
              //   child: Center(
              //       child: Text(
              //           (((wi) ~/ boxesinrow[gridno]) * boxesinrow[gridno])
              //               .toDouble()
              //               .toString())),
              //   width: (((wi) ~/ boxesinrow[gridno]) * boxesinrow[gridno])
              //       .toDouble(),
              //   height: (((wi) ~/ boxesinrow[gridno]) * boxesinrow[gridno])
              //           .toDouble() /
              //       boxesinrow[gridno],
              // )

          //   showSettings && ratio<1.54?  Container() :Container(
          //       height: h * 0.08,
          //       // color: Colors.purple,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Container(
          //             height: h * 0.08,
          //             width: w * 0.35,
          //             child: Center(
          //               child: Text(
          //                 getP1Count(),
          //                 style: TextStyle(
          //                     fontSize: h * 0.04,
          //                     fontWeight:
          //                         turn1 ? FontWeight.bold : FontWeight.normal),
          //               ),
          //             ),
          //           ),
          //           Container(
          //             height: h * 0.08,
          //             width: w * 0.35,
          //             child: Center(
          //               child: Text(
          //                 getP2Count(),
          //                 style: TextStyle(
          //                     fontSize: h * 0.04,
          //                     fontWeight:
          //                         !turn1 ? FontWeight.bold : FontWeight.normal),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
             
          //  showSettings && ratio<1.54? Container() :  Container(
          //       height: h * 0.08,
          //       // color: Colors.orange,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Container(
          //               height: h * 0.08,
          //               width: w * 0.45,
          //               padding: EdgeInsets.all(h * 0.01),
          //               decoration: BoxDecoration(
          //                 color: C.p1color.withAlpha(30),
          //                 borderRadius: BorderRadius.circular(h * 0.03),
          //                 border: turn1
          //                     ? Border.all(width: 2, color: C.p1color)
          //                     : null,
          //               ),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: [
          //                   Image.asset(C.icons[widget.p1no]),
          //                   Text(
          //                     'Player 1',
          //                     style: TextStyle(
          //                         fontSize: w * 0.06,
          //                         fontWeight: turn1
          //                             ? FontWeight.bold
          //                             : FontWeight.normal),
          //                   ),
          //                 ],
          //               )),
          //           Container(
          //               height: h * 0.08,
          //               width: w * 0.45,
          //               padding: EdgeInsets.all(h * 0.01),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(h * 0.03),
          //                 color: C.p2color.withAlpha(30),
          //                 border: !turn1
          //                     ? Border.all(width: 2, color: C.p2color)
          //                     : null,
          //               ),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                 children: [
          //                   Image.asset(C.icons[widget.p2no]),
          //                   Text(
          //                     'Player 2',
          //                     style: TextStyle(
          //                         fontSize: h * 0.03,
          //                         fontWeight: !turn1
          //                             ? FontWeight.bold
          //                             : FontWeight.normal),
          //                   ),
          //                 ],
          //               )),
          //         ],
          //       ),
          //     ),
           

showSettings 
                  ? Container()
                  : Container(
                      height: h * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: h * 0.08,
                            width: w * 0.35,
                            child: Center(
                              child: Text(
                                getP1Count(),
                                style: TextStyle(
                                    fontSize: h * 0.04,
                                    fontWeight: turn1
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                          Container(
                            height: h * 0.08,
                            width: w * 0.35,
                            child: Center(
                              child: Text(
                                getP2Count(),
                                style: TextStyle(
                                    fontSize: h * 0.04,
                                    fontWeight: !turn1
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              showSettings && ratio < 1.54
                  ? Container()
                  : Container(
                      height: h * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              height: h * 0.08,
                              width: showSettings? w * 0.32:w*0.45,
                              padding: EdgeInsets.all(h * 0.01),
                              decoration: BoxDecoration(
                                color: C.p1color.withAlpha(30),
                                borderRadius: BorderRadius.circular(h * 0.03),
                                border: turn1
                                    ? Border.all(width: 2, color: C.p1color)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(C.icons[widget.p1no]),
                                  Text(
                                    'You',
                                    style: TextStyle(
                                        fontSize: w * 0.05,
                                        fontWeight: turn1
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ],
                              )),
                          showSettings?    Container(
                                width: w*0.08,
                                child: FittedBox(
                                  child: Text(
                                       getP1Count(),
                                style: TextStyle(
                                    fontSize: h * 0.04,
                                    fontWeight: turn1
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              
                                  ),
                                ),
                              ):Container(),
                           showSettings?   Container(
                                height: h*0.04,
                                width: 0.01,
                              ):Container(),
                          showSettings?      Container(
                                width: w*0.08,
                                child: FittedBox(
                                  child: Text(
                                       getP2Count(),
                                style: TextStyle(
                                    fontSize: h * 0.04,
                                    fontWeight: turn1
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              
                                  ),
                                ),
                              ):Container(),

                          Container(
                              height: h * 0.08,
                              width: showSettings? w * 0.32:w*0.45,
                              padding: EdgeInsets.all(h * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(h * 0.03),
                                color: C.p2color.withAlpha(30),
                                border: !turn1
                                    ? Border.all(width: 2, color: C.p2color)
                                    : null,
                              ),
                              child: InkWell(
                               
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(C.icons[widget.p2no]),
                                    Text(
                                      'Player 2',
                                      style: TextStyle(
                                          fontSize: showSettings?w*0.03: w * 0.043,
                                          fontWeight: !turn1
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),


           
              SizedBox(
                height: h * 0.008,
              )
            ],
          ),
        ),
      ),
    );
  }

  getWidth(int i, int count, double d) {
    double w = 50;

    double x = d / boxesinrow[gridno];
    print('cell $x');
    // print("xxxxxxxxxx    $x");
    // x = 41.67 * 0.5;

    if ((i % count) % 2 == 0) {
      w = x;
    } else {
      w = 7 * x;
    }

    return w;
  }

  getHeight(int i, int count, double d) {
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

  Widget myWrapGrid(double d, int ind) {
    List<Widget> boxList = [];
    print("main widrht     $d");
    for (int i = 0; i < ind * ind; i++) {
      boxList.add(myBox(i, d, ind));
    }
    return Wrap(
      children: [...boxList],
    );
  }

  Widget myBox(int i, double d, int count) {
    bh = getHeight(i, count, d);

    bw = getWidth(i, count, d);
    Color color = Colors.white;
    BoxType boxType = BoxType.dot;
    if (lines.containsKey(i)) {
      boxType = lines[i]!.boxType;
      color = (lines[i]!.index == i && lines[i]!.marked
          ? lines[i]!.player == 1
              ? C.linemarkedcolor
              : lines[i]!.player == 2
                  ? C.linemarkedcolor
                  : C.colors[WhichColor.vlineshow]
          : C.colors[WhichColor.vlinehide])!;
    } else if (boxes.containsKey(i)) {
      boxType = BoxType.box;

      color = (boxes[i]!.index == i && boxes[i]!.marked
          ? C.colors[WhichColor.boxmarked]
          : C.colors[WhichColor.boxNotMarked])!;
    } else {
      color = Colors.black;
    }

    // color = boxes.containsKey(i)
    //     ? boxes[i]!.index == i
    //         ? C.colors[WhichColor.boxNotMarked]
    //         : C.colors[WhichColor.boxNotMarked]
    //     : C.colors[WhichColor.boxNotMarked];

    return IgnorePointer(
      ignoring: false,
      // lines.containsKey(i) && !lines[i]!.marked ? false : true,
      child: Transform.scale(
        scale: boxType == BoxType.dot ? 1.0 : 1,
        child: Container(
          width: bw,
          height: bh,
          decoration: BoxDecoration(
            color: lastLineIndex == i && isGameOver ? Colors.blue : color,
            // border: lastLineIndex == i ? Border.all():null
          ),
          // child: Center(child: Text(i.toString())),
          // color: lastLineIndex == i ? Color.fromARGB(255, 68, 73, 232) : color,
          // color:color,
          child: boxType == BoxType.box
              ? boxWidget(i)
              : boxType != BoxType.dot
                  ? InkWell(
                      onTap: () {
                        // if (lines.containsKey(i)) {
                        //   setState(() {
                        //     audioCache.play('smalltap.mp3');

                        //     lines[i]!.marked = !lines[i]!.marked;
                        //     lines[i]!.player = turn1 ? 1 : 2;
                        //     print('box 000000000000000000000000');
                        //     isBoxDone = false;
                        //     updateBox(i);
                        //     checkGameOver();

                        //     if (isBoxDone) {
                        //       audioCache.play('boxmarked.mp3');
                        //     } else {
                        //       turn1 = !turn1;
                        //     }

                        //     lastLineIndex = i;
                        //   });
                        // }
                      },
                      child: Transform.scale(
                        scaleY: boxType == BoxType.hline ? 3 : 1,
                        scaleX: boxType == BoxType.vline ? 3 : 1,
                        child: Center(
                          child: Container(
                            height: boxType == BoxType.hline ? bh : bh * 0.7,
                            width: boxType == BoxType.hline ? bw * 0.7 : bw,
                            // color: Colors.red.withAlpha(60),
                          ),
                        ),
                      ),
                    )
                  : Center(),
          //  Color.fromARGB(255, i * 10 + Random().nextInt(300),
          //     255 - i * 5 + Random().nextInt(300), i * 3 + Random().nextInt(300)),
        ),
      ),
    );
  }

  getListOFx() {}

  bool checkIfBox(int i, int count) {
    bool check = false;
    if (!((i % count) % 2 == 0) && !(i % (2 * count) < count)) {
      print('this is box @ $i');
      check = true;
    }
    return check;
  }

  bool checkIsLine(int i, int count) {
    bool check = false;

    if ((i % count) % 2 == 0 && !(i % (2 * count) < count)) {
      // w = x;
      // Vertical line

      check = true;
    } else if (i % (2 * count) < count && (i % count) % 2 != 0) {
      // Horizpntal line
      // w = 7 * x;
      check = true;
    }

    return check;
  }

  bool isVline(int i, int count) {
    bool check = false;
    if ((i % count) % 2 == 0 && !(i % (2 * count) < count)) {
      // w = x;
      // Vertical line

      check = true;
    }
    return check;
  }

  bool isHline(int i, int count) {
    bool check = false;
    if (i % (2 * count) < count && (i % count) % 2 != 0) {
      // w = x;
      // Vertical line

      check = true;
    }
    return check;
  }

  void updateBox(int i) {
    if (lines[i]!.boxType == BoxType.vline) {
      int prevind = i - 1;
      int nextind = i + 1;
      if (boxes.containsKey(prevind)) {
        boxes[prevind]!.right = true;

        if (boxes[prevind]!.left == true &&
            boxes[prevind]!.right == true &&
            boxes[prevind]!.top == true &&
            boxes[prevind]!.bottom == true) {
          boxes[prevind]!.marked = true;
          isBoxDone = true;
          boxes[prevind]!.player = turn1 ? 1 : 2;
        }
      }
      if (boxes.containsKey(nextind)) {
        boxes[nextind]!.left = true;

        if (boxes[nextind]!.left == true &&
            boxes[nextind]!.right == true &&
            boxes[nextind]!.top == true &&
            boxes[nextind]!.bottom == true) {
          boxes[nextind]!.marked = true;
          isBoxDone = true;
          boxes[nextind]!.player = turn1 ? 1 : 2;
        }
      }
    } else if (lines[i]!.boxType == BoxType.hline) {
      int prevind = i - count;
      int nextind = i + count;
      if (boxes.containsKey(prevind)) {
        boxes[prevind]!.top = true;

        if (boxes[prevind]!.left == true &&
            boxes[prevind]!.right == true &&
            boxes[prevind]!.top == true &&
            boxes[prevind]!.bottom == true) {
          boxes[prevind]!.marked = true;
          isBoxDone = true;
          boxes[prevind]!.player = turn1 ? 1 : 2;
        }
      }
      if (boxes.containsKey(nextind)) {
        boxes[nextind]!.bottom = true;

        if (boxes[nextind]!.left == true &&
            boxes[nextind]!.right == true &&
            boxes[nextind]!.top == true &&
            boxes[nextind]!.bottom == true) {
          boxes[nextind]!.marked = true;
          isBoxDone = true;
          boxes[nextind]!.player = turn1 ? 1 : 2;
        }
      }

      //  turn1 = !turn1;
    }
    boxes.entries.toList().forEach((e) {
      print(
          'box ${e.key} -  ${e.value.top} - ${e.value.bottom} - ${e.value.left}- ${e.value.right}');
    });
  }

  Widget boxWidget(int i) {
    int p = boxes[i]!.player;
    String text = '';
    switch (p) {
      case 1:
        text = 'P1';

        break;
      case 2:
        text = 'P2';
        break;
      default:
    }
    return FittedBox(
      child: text == ''
          ? null
          : CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                  text == 'P1' ? C.icons[widget.p1no] : C.icons[widget.p2no]),
            ),
    );
  }

  String getP1Count() {
    int p1 = 0;
    boxes.values.toList().forEach((e) {
      if (e.marked && e.player == 1) {
        p1 += 1;
      }
    });
    return p1.toString();
  }

  String getP2Count() {
    int p2 = 0;
    boxes.values.toList().forEach((e) {
      if (e.marked && e.player == 2) {
        p2 += 1;
      }
    });
    return p2.toString();
  }

  void showAskDialog(ctx) {
    showDialog(context: context, builder: (context) => askDialog(context, ctx));
  }

  Widget askDialog(BuildContext context, BuildContext ctx) {
    double h = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      child: Container(
        //  decoration: BoxDecoration(
        //    borderRadius: BorderRadius.circular(30)
        //  ),
        child: Container(
          height: h * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: h * 0.03,
              ),
              Text(
                "Do you go back ?\n Your game progress will be lost ...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: h * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 36, 13, 90),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      p.pause();
                      Navigator.pop(context);
                      Navigator.pop(ctx);
                    },
                    child: Image.asset(
                      'assets/yesred.png',
                      width: w * 0.25,
                      height: w * 0.21,
                      fit: BoxFit.fill,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/nogreen.png',
                      width: w * 0.2,
                      height: w * 0.21,
                    ),
                  ),
                ],
              ),
              // InkWell(
              //   onTap: () {
              //     // goBack = true;
              //     Navigator.pop(context);
              //     Navigator.pop(ctx);
              //   },
              //   child: Container(
              //     height: h * 0.06,
              //     width: h * 0.2,
              //     padding: EdgeInsets.all(h * 0.0081),
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             width: 2, color: Color.fromARGB(255, 14, 26, 35)),
              //         borderRadius: BorderRadius.circular(30)),
              //     child: FittedBox(child: Center(child: Text('Yes'))),
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     height: h * 0.06,
              //     width: h * 0.2,
              //     padding: EdgeInsets.all(h * 0.0081),
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             width: 2, color: Color.fromARGB(255, 233, 236, 237)),
              //         color: Color.fromARGB(255, 36, 13, 90),
              //         borderRadius: BorderRadius.circular(30)),
              //     child: FittedBox(
              //         child: Center(
              //             child: Text(
              //       'No',
              //       style: TextStyle(color: Colors.white),
              //     ))),
              //   ),
              // ),

              SizedBox(
                height: h * 0.03,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showResetAskDialog(ctx) {
    showDialog(
        context: context, builder: (context) => resetAskDialog(context, ctx));
  }

  Widget resetAskDialog(BuildContext context, BuildContext ctx) {
    double h = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      child: Container(
        //  decoration: BoxDecoration(
        //    borderRadius: BorderRadius.circular(30)
        //  ),
        child: Container(
          height: h * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: h * 0.03,
              ),
              Text(
                "Do you reset game ?\n Your game progress will be lost ...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: h * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 36, 13, 90),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        transOffset = Offset.zero;
                        zoomScale = 1.0;
                        tempScale = 1.0;

                        lines.clear();
                        boxes.clear();
                        resetLinesandBoxes();
                        turn1 = true;
                        isGameOver = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/yesred.png',
                      width: w * 0.25,
                      height: w * 0.21,
                      fit: BoxFit.fill,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/nogreen.png',
                      width: w * 0.2,
                      height: w * 0.21,
                    ),
                  ),
                ],
              ),
              // InkWell(
              //   onTap: () {
              //     // goBack = true;
              //     Navigator.pop(context);
              //     Navigator.pop(ctx);
              //   },
              //   child: Container(
              //     height: h * 0.06,
              //     width: h * 0.2,
              //     padding: EdgeInsets.all(h * 0.0081),
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             width: 2, color: Color.fromARGB(255, 14, 26, 35)),
              //         borderRadius: BorderRadius.circular(30)),
              //     child: FittedBox(child: Center(child: Text('Yes'))),
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     height: h * 0.06,
              //     width: h * 0.2,
              //     padding: EdgeInsets.all(h * 0.0081),
              //     decoration: BoxDecoration(
              //         border: Border.all(
              //             width: 2, color: Color.fromARGB(255, 233, 236, 237)),
              //         color: Color.fromARGB(255, 36, 13, 90),
              //         borderRadius: BorderRadius.circular(30)),
              //     child: FittedBox(
              //         child: Center(
              //             child: Text(
              //       'No',
              //       style: TextStyle(color: Colors.white),
              //     ))),
              //   ),
              // ),

              SizedBox(
                height: h * 0.03,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconswithCelebration() {
    // isGameOver = true;
    return isGameOver ? showWinnerRow() : showPlayerIcons();
    // double dh = h -
    //     (0.05 + 0.05 + 0.05 + 0.16 + 0.01) * h -
    //     w -
    //     MediaQuery.of(context).viewPadding.top;
    // return Container(
    //   height:dh>0? dh: 50,
    //   width: w,
    //   child: FittedBox(
    //     child: Text(dh.toString()),
    //   ),
    // );
  }

  Widget showWinnerRow() {
    print('winn $whoWins');

    double remaingH = h - (0.05 + 0.16 + 0.01) * h - w ;
    rem = remaingH.round().toDouble();
    double fullradius = remaingH * 0.35;
    double innerRadius = remaingH * 0.9 * 0.35;
    return Container(
      height: remaingH * 0.7,
      width: w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // width: w * 0.28,
            height: remaingH * 0.7,
            child: Image.asset(
              'assets/celeb.gif',
              fit: BoxFit.cover,
            ),
          ),
          Container(
              // width: w * 0.28,
              height: remaingH * 0.7,
              child: CircleAvatar(
                radius: remaingH * 0.3,
                backgroundColor: Colors.white.withAlpha(0),
                backgroundImage: AssetImage(whoWins == 1
                    ? C.icons[widget.p1no]
                    : whoWins == 2
                        ? C.icons[widget.p2no]
                        : 'assets/monkey1.gif'),
              )

              // ? Image.asset(
              //     C.icons[widget.p1no],
              //     fit: BoxFit.cover,
              //   )
              // : Image.asset(
              //     C.icons[widget.p2no],
              //     fit: BoxFit.cover,
              //   ),
              ),
          RotatedBox(
            quarterTurns: 3,
            child: Container(
              // width: w * 0.28,
              height: remaingH * 0.7,
              child: Image.asset(
                'assets/celeb.gif',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showPlayerIcons() {
    double remaingH = h - ( 0.05 + 0.16 + 0.009) * h - w;
       rem = remaingH.round().toDouble();

    double fullradius = remaingH * 0.35;
    double innerRadius = remaingH * 0.9 * 0.35;
    print('turn11 $turn1');
    return Container(
      height: remaingH * 0.7,
      // color: Colors.blue,
      width: w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withAlpha(0),
            backgroundImage: turn1 ? AssetImage('assets/circnobg.gif') : null,
            radius: fullradius,
            child: CircleAvatar(
              backgroundColor: Colors.white.withAlpha(0),
              radius: innerRadius,
              backgroundImage: AssetImage(C.icons[widget.p1no]),
            ),
          ),
          CircleAvatar(
            radius: fullradius,
            backgroundColor: Colors.white.withAlpha(0),
            backgroundImage: !turn1 ? AssetImage('assets/circnobg.gif') : null,
            child: CircleAvatar(
              backgroundColor: Colors.white.withAlpha(0),
              radius: innerRadius,
              backgroundImage: AssetImage(C.icons[widget.p2no]),
            ),
          )
        ],
      ),
    );
  }

  void checkGameOver() {
    int total = int.parse(getP1Count()) + int.parse(getP2Count());
    int tc = ((gridno + 1) * (gridno + 1));
    print('checkk $total  ,, $tc');
    if (total >= tc) {
      setState(() {
        if (int.parse(getP1Count()) > int.parse(getP2Count())) {
          whoWins = 1;

          isSound ? audioCache.play('wingame.mp3') : () {};
        } else if (int.parse(getP1Count()) < int.parse(getP2Count())) {
          whoWins = 2;
          isSound ? audioCache.play('wingame.mp3') : () {};
        } else {
          whoWins = 0;
          isSound ? audioCache.play('drawgame.mp3') : () {};
        }
        isGameOver = true;
      });
      Shared.incrementGameCompleteCount();
      print('intert count ${Shared.getGameCompletedCount()} --- ');
      if (Shared.getGameCompletedCount() % 3 == 0) {
        // InterstitialAdsAdmob.instance.showInterstitialAd();
        if (Shared.getGameCompletedCount() % 20 == 0) {
          Shared.resetGameCompletCount(0);
        }
      } else {
        print('rated ${Shared.isRatedFun()}');
        if (!Shared.isRatedFun() && Shared.getGameCompletedCount() == 15) {
          showRateUsDialog();
        }
      }
      Shared.getGameCompletedCount() != 15 ? showPlayAgainDialog() : () {};
    }
  }

  void resetLinesandBoxes() {
    for (int i = 0; i < count * count; i++) {
      if (checkIsLine(i, count)) {
        print('this is line @ $i');
        if (isVline(i, count)) {
          lines[i] = LineModel(i, BoxType.vline);
        } else if (isHline(i, count)) {
          lines[i] = LineModel(i, BoxType.hline);
        }
      } else if (checkIfBox(i, count)) {
        boxes[i] = BoxModel(i, BoxType.box);
      }
    }
    print("countt before $countsList");
  }

  void checkSound() {
    isSound = isSound;
  }

  void showRateUsDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => rateDialog());
  }

  Widget rateDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.06),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(w * 0.06),
        child: Container(
          height: h * 0.4,
          width: w * 0.7,
          // color:

          //  CustomColors.primaryColor,
          child: Column(children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              height: h * 0.25,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.04),
                    child: Text(
                      'Enjoying Stick Box !!!',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: w * 0.08),
                    ),
                  ),
                  ratingBar(w * 0.7, h * 0.4),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.04 * 0),
                    child: Text(
                      'Review Us :)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: w * 0.08),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Shared.setRatedDone();
                Navigator.pop(context);
              },
              child: Container(
                height: h * 0.06,
                width: w * 0.5,
                margin: EdgeInsets.all(h * 0.02),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(h * 0.09),
                    color: Color.fromARGB(255, 19, 9, 46)),
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(h * 0.01),
                    child: Center(
                      child: Text(
                        'Write A Review',
                        style: TextStyle(
                            // fontSize: h*0.061,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Not now',
                style: TextStyle(color: Colors.grey, fontSize: h * 0.02),
              ),
            )
          ]),
        ),
      ),
    );
  }

  ratingBar(double wr, double hr) {
    return Padding(
      padding: EdgeInsets.all(hr * 0.061),
      child: RatingBar.builder(
        itemCount: 5,
        initialRating: 5,
        minRating: 1,
        direction: Axis.horizontal,
        glowColor: Color.fromARGB(255, 251, 189, 4),
        unratedColor: Colors.yellow[70],
        itemBuilder: (context, int index) =>
            Icon(Icons.star, size: wr * 0.1, color: Colors.orangeAccent),
        onRatingUpdate: (rating) {
          // setState(() {
          //   // ratingno = rating.toString().substring(0, 1);
          // });

          print("rrat" + rating.toString());
        },
      ),
    );
  }

  void showPlayAgainDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => playagainDialog());
  }

  playagainDialog() {
    return Container(
      margin: EdgeInsets.only(top: h * 0.55),
      height: h * 0.185,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(w * 0.1)),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.1)),
        child: InkWell(
          onTap: () {
            isSound ? audioCache.play('boxdone.mp3') : () {};
            setState(() {
              transOffset = Offset.zero;
              zoomScale = 1.0;
              tempScale = 1.0;

              lines.clear();
              boxes.clear();
              resetLinesandBoxes();
              isGameOver = false;
              whoWins == 2 ? turn1 = false : turn1 = true;
              lastLineIndex = -1;
            });
            Navigator.maybePop(context);
          },
          child: Container(
            //  margin: EdgeInsets.only(top: h*0.05),
            height: h * 0.15,
            child: Center(
              child: Image.asset(
                'assets/playagain.png',
                height: h * 0.10,
              ),
            ),
          ),
        ),
        // Column(
        //  children: [
        //    Spacer(flex: 10,),
        //    Container(
        //      child: Image.asset('assets/playagain.png', width: w*0.8,),
        //    ),
        //    Spacer(flex: 2,)
        //  ],
      ),
    );
  }

  back() {
    return InkWell(
      onTap: () {
        Navigator.of(context).maybePop();
      },
      child: Image.asset(
        'assets/back.png',
        height: h * 0.05,
      ),
    );
  }

  replay() {
    return InkWell(
      onTap: () {
        isSound ? audioCache.play('boxdone.mp3') : () {};
        showResetAskDialog(context);
      },
      child: Image.asset(
        'assets/replay.png',
        height: h * 0.05,
      ),
    );
  }

  sound() {
    return InkWell(
      onTap: () {
        Shared.changeSoundONOFF(!isSound);
        setState(() {
          isSound = Shared.getSoundStatus();
        });
      },
      child: Image.asset(
        isSound ? 'assets/soundon.png' : 'assets/soundoff.png',
        height: h * 0.05,
      ),
    );
  }

  music() {
    return InkWell(
      onTap: () {
        // Shared.changeSoundONOFF(!isSound);
        setState(() {
          // showVolumeSlider = !showVolumeSlider;
          volumeslidervalue = 0.0;
          p.setVolume(volumeslidervalue);
        });
      },
      child: Image.asset(
        volumeslidervalue != 0.0 ? 'assets/musicon.png' : 'assets/musicoff.png',
        height: h * 0.05,
      ),
    );
  }

  setting() {
    return InkWell(
      onTap: () {
        // Shared.changeSoundONOFF(!isSound);
        setState(() {
          showSettings = !showSettings;
          Shared.setVolume(p.sliderValue);
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (w, animation) {
          return RotationTransition(
            turns: animation,
            child: w,
          );
        },
        child: showSettings
            ? RotatedBox(
                key: Key('1'),
                quarterTurns: 0,
                child: Image.asset(
                  'assets/musicsetting.png',
                  fit: BoxFit.cover,
                  height: h * 0.05,
                ),
              )
            : RotatedBox(
                key: Key('2'),
                quarterTurns: 1,
                child: Image.asset(
                  'assets/musicsetting.png',
                                    fit: BoxFit.cover,

                  height: h * 0.05,
                ),
              ),
      ),
    );
  }
}

class MyPointsVLinesClipper extends CustomClipper<Path> {
  double x;
  double s;
  MyPointsVLinesClipper(this.x, this.s);
  @override
  Path getClip(Size size) {
    size = Size(s, 3 * x);
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    print("the size $size");

    Path path0 = Path();
// With Offset x
    path0.moveTo(x, 0);
    path0.lineTo(2 * x, 0);
    path0.lineTo(3 * x, x);

    path0.lineTo(3 * x, 6 * x);

    path0.lineTo(2 * x, 7 * x);
    path0.lineTo(x, 7 * x);
    path0.lineTo(0, 6 * x);
    path0.lineTo(0, 1 * x);

    // Without offset

    // path0.moveTo(0, 0);
    // path0.lineTo( x, 0);
    // path0.lineTo(2 * x, x);

    // path0.lineTo(2 * x, 6 * x);

    // path0.lineTo( x, 7 * x);
    // path0.lineTo(0, 7 * x);
    // path0.lineTo(-x, 6 * x);
    // path0.lineTo(-x, 1 * x);

    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    // throw UnimplementedError();
    return false;
  }
}

class MyPointsHLinesClipper extends CustomClipper<Path> {
  double x;
  double s;
  MyPointsHLinesClipper(this.x, this.s);
  @override
  Path getClip(Size size) {
    size = Size(s, 3 * x);
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    print("the size $size");

    Path path0 = Path();
    // path0.moveTo(size.width * 0.4150000, size.height * 0.5000000);
    // path0.lineTo(size.width * 0.4566667, size.height * 0.4300000);
    // path0.lineTo(size.width * 0.4983333, size.height * 0.3571429);
    // path0.lineTo(size.width * 0.5833333, size.height * 0.3557143);
    // path0.lineTo(size.width * 0.6666667, size.height * 0.4985714);
    // path0.lineTo(size.width * 0.5825000, size.height * 0.6414286);
    // path0.lineTo(size.width * 0.5000000, size.height * 0.6414286);
    // path0.lineTo(size.width * 0.4150000, size.height * 0.5000000);
    // x = 10;
    if (x < 10) {
      // x = 10;

      path0.moveTo(0, x);
      path0.lineTo(x, 0);
      path0.lineTo(6 * x, 0);

      path0.lineTo(7 * x, x);

      path0.lineTo(7 * x, 2 * x);
      path0.lineTo(6 * x, 3 * x);
      path0.lineTo(7 * x, 3 * x);
      path0.lineTo(x, 3 * x);
      path0.lineTo(0, 2 * x);
    } else {
      path0.moveTo(0, x);
      path0.lineTo(x, 0);
      path0.lineTo(6 * x, 0);

      path0.lineTo(7 * x, x);

      path0.lineTo(7 * x, 2 * x);
      path0.lineTo(6 * x, 3 * x);
      path0.lineTo(7 * x, 3 * x);
      path0.lineTo(x, 3 * x);
      path0.lineTo(0, 2 * x);

      path0.close();
    }

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    // throw UnimplementedError();
    return false;
  }
}

/*

  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        transOffset = Offset.zero;
                        zoomScale = 1.0;
                        tempScale = 1.0;
                      });
                    },
                    child: Container(
                        height: h * 0.06,
                        child: Center(
                          child: Text('Reset Position',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = linearGradient1)),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        transOffset = Offset.zero;
                        zoomScale = 1.0;
                        tempScale = 1.0;

                        lines.clear();
                        boxes.clear();
                        resetLinesandBoxes();
                        isGameOver = false;
                      });
                    },
                    child: Container(
                        height: h * 0.06,
                        child: Center(
                          child: Text(isGameOver ? 'Play Again' : 'Reset',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader = linearGradient2)),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Container(
                      height: h * 0.06,
                      child: Center(
                        child: Text('Go Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient3)),
                      ),
                    ),
                  ),
                ],
              ),
            
*/

/*

   //                MasonryGridView.count(
                //                 crossAxisCount: 5,
                //                 mainAxisSpacing: 4,
                //                 crossAxisSpacing: 4,
                //                 itemCount: 25,
                //                 itemBuilder: (context, i) {
                //                   return Container(
                //                     // index: index,
                //                     // extent: (index % 5 + 1) * 100,
                //              color:     Color.fromARGB(
                //                         120,
                //                         i * 10 + Random().nextInt(300),
                //                         255 - i * 5 + Random().nextInt(300),
                //                         i * 3 + Random().nextInt(300)),

                //                     child: Stack(
                //                       children: [
                //                         Container(),
                //                         Container(
                // width: getWidth(i, 5),
                //                     height: getHeight(i, 5),
                //                      color: Color.fromARGB(
                //                         255,
                //                         i * 10 + Random().nextInt(300),
                //                         255 - i * 5 + Random().nextInt(300),
                //                         i * 3 + Random().nextInt(300)),
                //                         )
                //                       ],
                //                     ),

                //                   );
                //                 },
                //               ),
*/
/*


// onTapDown: (d) {
                      //   print('tap point ${d.localPosition}');
                      // },
                      // onScaleStart: (d) {
                      //   setState(() {
                      //     scalecount = 0;
                      //   });
                      // },
                      // onScaleEnd: (d) {
                      //   setState(() {
                      //     scalecount = 0;
                      //   });
                      // },
                      // onScaleUpdate: (d) {
                      //   print('point ${d.focalPointDelta}');
                      //   setState(() {
                      //     transOffset = Offset(
                      //         transOffset.dx + d.focalPointDelta.dx * zoomScale,
                      //         transOffset.dy +
                      //             d.focalPointDelta.dy * zoomScale);
                      //     scalecount++;
                      //     scales[0] = scales[1];
                      //     scales[1] = d.scale;
                      //     if (d.scale == 1.0) {
                      //       tempScale = zoomScale;
                      //       zoomScale = d.scale * tempScale;
                      //     }
                      //     if (d.scale > 1 && scales[0] != scales[1]) {
                      //       if (zoomScale < 10) {
                      //         zoomScale = d.scale * tempScale;
                      //         // zoomScale += 0.05;
                      //       }
                      //     } else if (d.scale < 1 && scales[0] != scales[1]) {
                      //       if (zoomScale > 0.06) {
                      //         // zoomScale -= 0.05;
                      //         zoomScale = d.scale * tempScale;
                      //       }
                      //     }
                      //     // zoomScale += d.scale;
                      //     print('scale is ${d.scale} and $zoomScale');
                      //   });
                      // },

                      */
