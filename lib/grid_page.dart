import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:stick_box/box_model.dart';
import 'package:stick_box/sizes.dart';

import 'constants.dart';

class GridPage extends StatefulWidget {
  int gridno;
  int p1no;
  int p2no;
  GridPage(this.gridno, this.p1no, this.p2no, {Key? key}) : super(key: key);

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<int> boxesinrow = [9, 17, 25, 33, 41, 49, 57, 65, 73];
  Map<int, LineModel> lines = {};
  Map<int, BoxModel> boxes = {};
  bool goBack = false;

  int gridno = 0;
  int lastLineIndex = -1;
  Offset transOffset = Offset.zero;
  int count = 5;
  @override
  void initState() {
     audioCache.load('smalltap.mp3');
      audioCache.load('boxmarked.mp3');
       audioCache.load('drawgame.mp3');
    // TODO: implement initState
    super.initState();
    gridno = widget.gridno;
    count = (gridno * 2 + 3);
    boxes.clear();
    lines.clear();
    resetLinesandBoxes();
  }
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    audioPlayer.release();
    
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
  @override
  Widget build(BuildContext context) {
    double wi = w * 0.9;
    final Shader linearGradient1 = LinearGradient(
      colors: <Color>[Color.fromARGB(255, 1, 34, 110), Color.fromARGB(255, 21, 80, 216)],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );
      final Shader linearGradient2 = LinearGradient(
      colors: <Color>[Colors.pink, Color.fromARGB(255, 245, 39, 39)],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );
      final Shader linearGradient3 = LinearGradient(
      colors: <Color>[Colors.pink, Color.fromARGB(255, 6, 120, 6)],
    ).createShader(
      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );
    
    double boxsize =
        (((wi) ~/ boxesinrow[gridno]) * boxesinrow[gridno]).toDouble();
    print('  ${boxsize}');
    return WillPopScope(
      onWillPop: () async {
        showAskDialog(context);

        return true;
      },
      child: Scaffold(
        body: Container(
          height: h,
          width: w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top+h*0.05, 
              ),
              iconswithCelebration(),

              Expanded(
                  child: ClipRRect(
                child: Transform.translate(
                  offset: transOffset,
                  child: Transform.scale(
                    scale: zoomScale,
                    child: GestureDetector(
                      onTapDown: (d) {
                        print('tap point ${d.localPosition}');
                      },
                      onScaleStart: (d) {
                        setState(() {
                          scalecount = 0;
                        });
                      },
                      onScaleEnd: (d) {
                        setState(() {
                          scalecount = 0;
                        });
                      },
                      onScaleUpdate: (d) {
                        print('point ${d.focalPointDelta}');
                        setState(() {
                          transOffset = Offset(
                              transOffset.dx + d.focalPointDelta.dx * zoomScale,
                              transOffset.dy +
                                  d.focalPointDelta.dy * zoomScale);
                          scalecount++;
                          scales[0] = scales[1];
                          scales[1] = d.scale;
                          if (d.scale == 1.0) {
                            tempScale = zoomScale;
                            zoomScale = d.scale * tempScale;
                          }
                          if (d.scale > 1 && scales[0] != scales[1]) {
                            if (zoomScale < 10) {
                              zoomScale = d.scale * tempScale;
                              // zoomScale += 0.05;
                            }
                          } else if (d.scale < 1 && scales[0] != scales[1]) {
                            if (zoomScale > 0.06) {
                              // zoomScale -= 0.05;
                              zoomScale = d.scale * tempScale;
                            }
                          }
                          // zoomScale += d.scale;
                          print('scale is ${d.scale} and $zoomScale');
                        });
                      },
                      child: Center(
                        child: Container(
                          height: boxsize,
                          width: boxsize,
                          // color: Colors.pink.shade200.withAlpha(0),
                          child: myWrapGrid(boxsize, gridno * 2 + 3),
                        ),
                      ),
                    ),
                  ),
                ),
              )),

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

              Row(
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
                            fontWeight:
                                turn1 ? FontWeight.bold : FontWeight.normal),
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
                            fontWeight:
                                !turn1 ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: h * 0.08,
                    width: w * 0.35,
                    padding: EdgeInsets.all(h * 0.01),
                    decoration: BoxDecoration(
                      color: C.p1color.withAlpha(30),
                      borderRadius: BorderRadius.circular(h * 0.03),
                      border:
                          turn1 ? Border.all(width: 2, color: C.p1color) : null,
                    ),
                    child: Center(
                      child: Text(
                        'Player 1',
                        style: TextStyle(
                            fontSize: h * 0.03,
                            fontWeight:
                                turn1 ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                  Container(
                    height: h * 0.08,
                    width: w * 0.35,
                    padding: EdgeInsets.all(h * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(h * 0.03),
                      color: C.p2color.withAlpha(30),
                      border: !turn1
                          ? Border.all(width: 2, color: C.p2color)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        'Player 2',
                        style: TextStyle(
                            fontSize: h * 0.03,
                            fontWeight:
                                !turn1 ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                ],
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
                      });
                    },
                    child: Container(
                        height: h * 0.06,
                        child: Center(
                          child: Text(
                            'Reset Position',
                            textAlign: TextAlign.center,
                             style: TextStyle(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient1)
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        transOffset = Offset.zero;
                        zoomScale = 1.0;
                        tempScale = 1.0;
                        // lines.entries.forEach((e) {
                        //   e.value.marked = false;
                        // });
                        // boxes.entries.forEach((e) {
                        //   e.value.marked = false;
                        //   e.value.bottom = false;
                        //    e.value.top = false;
                        //     e.value.left = false;
                        //      e.value.right = false;
                        // });
                        lines.clear();
                        boxes.clear();
                        resetLinesandBoxes();
                        isGameOver = false;
                      });
                    },
                    child: Container(
                        height: h * 0.06,
                        child: Center(
                          child: Text(
                            isGameOver ? 'Play Again' : 'Reset',
                            textAlign: TextAlign.center, style: TextStyle(
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient2)
                            
                          ),
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
            ],
          ),
        ),
      ),
    );
  }

  getWidth(int i, int count, double d) {
    double w = 50;

    int half = (count / 2).toInt();

    double x = d / boxesinrow[gridno];
    print('cell $x');
    // print("xxxxxxxxxx    $x");
    // x = 41.67 * 0.5;

    if ((i % count) % 2 == 0) {
      w = x + 0;
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
    double bh = getHeight(i, count, d);

    double bw = getWidth(i, count, d);
    Color color = Colors.white;
    BoxType boxType = BoxType.dot;
    if (lines.containsKey(i)) {
      boxType = lines[i]!.boxType;
      color = (lines[i]!.index == i && lines[i]!.marked
          ? lines[i]!.player == 1
              ? C.p1color
              : lines[i]!.player == 2
                  ? C.p2color
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
            color: color,
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
                        if (lines.containsKey(i)) {
                          setState(() {
                                audioCache.play('smalltap.mp3');

                            lines[i]!.marked = !lines[i]!.marked;
                            lines[i]!.player = turn1 ? 1 : 2;
                            print('box 000000000000000000000000');
                            isBoxDone = false;
                            updateBox(i);
                            checkGameOver();
                           
                            if (isBoxDone) {
                              audioCache.play('boxmarked.mp3');
                            } else {
                              turn1 = !turn1;
                            }

                            lastLineIndex = i;
                          });
                        }
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
              InkWell(
                onTap: () {
                  // goBack = true;
                  Navigator.pop(context);
                  Navigator.pop(ctx);
                },
                child: Container(
                  height: h * 0.06,
                  width: h * 0.2,
                  padding: EdgeInsets.all(h * 0.0081),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Color.fromARGB(255, 14, 26, 35)),
                      borderRadius: BorderRadius.circular(30)),
                  child: FittedBox(child: Center(child: Text('Yes'))),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: h * 0.06,
                  width: h * 0.2,
                  padding: EdgeInsets.all(h * 0.0081),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Color.fromARGB(255, 233, 236, 237)),
                      color: Color.fromARGB(255, 36, 13, 90),
                      borderRadius: BorderRadius.circular(30)),
                  child: FittedBox(
                      child: Center(
                          child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ))),
                ),
              ),
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
  }

  Widget showWinnerRow() {
    print('winn $whoWins');
    return Container(
      height: h * 0.15,
      width: w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            // width: w * 0.28,
            height: h * 0.15,
            child: Image.asset(
              'assets/celeb.gif',
              fit: BoxFit.contain,
            ),
          ),
          Container(
              // width: w * 0.28,
              height: h * 0.15,
              child: CircleAvatar(
                radius: h * 0.075,
                backgroundColor: Colors.white,
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
              height: h * 0.15,
              child: Image.asset(
                'assets/celeb.gif',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showPlayerIcons() {
    double fullradius = h * 0.08;
    double innerRadius = h * 0.065;
    print('turn11 $turn1');
    return Container(
      height: h * 0.16,
      width: w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: turn1 ? AssetImage('assets/circnobg.gif') : null,
            radius: fullradius,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: innerRadius,
              backgroundImage: AssetImage(C.icons[widget.p1no]),
            ),
          ),
          CircleAvatar(
            radius: fullradius,
            backgroundColor: Colors.white,
            backgroundImage: !turn1 ? AssetImage('assets/circnobg.gif') : null,
            child: CircleAvatar(
              backgroundColor: Colors.white,
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
          whoWins = 1; audioCache.play('win.mp3');
        } else if (int.parse(getP1Count()) < int.parse(getP2Count())) {
          whoWins = 2; audioCache.play('win.mp3');
        } else {
          whoWins = 0; audioCache.play('drawgame.mp3');
         
                             
                            
        }
        isGameOver = true;
      });
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
  }
}

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
