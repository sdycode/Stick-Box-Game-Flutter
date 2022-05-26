import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stick_box/grid_page.dart';

import 'constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> boxesinrow = [9, 17, 25, 33, 41, 49, 57, 65, 73];
  int whichGridNo = 0;
  int playerNo = 0;
  int p1no = 0;
  int p2no = 4;
 AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioCache.load('tap2.mp3');
   
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    audioPlayer.release();
    
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    double t = MediaQuery.of(context).viewPadding.top;
    // h = h - t;
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return true;
      },
      child: Scaffold(
        body: Container(
          height: h,
          width: w,
          child: Column(
            children: [
              Container(
                height: w * 0.34 * 2 + t,
                width: w,
                // color: Colors.pink.shade100,
                child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (c, i) {
                      double wi = w * 0.3;
                      int gridno = i + 1;
                      double boxsize =
                          (((wi) ~/ boxesinrow[i]) * boxesinrow[i]).toDouble();

                      return InkWell(
                        onTap: () {
                          setState(() {
                            whichGridNo = i;
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
                          scale: whichGridNo == i ? 1.2 : 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: whichGridNo == i
                                      ? Border.all(width: 2)
                                      : null),
                              margin: EdgeInsets.all(w * 0.041),
                              padding: EdgeInsets.all(w * 0.011),
                              child: grid(i, w * 0.28)

                              // Center(4
                              //   child: Text('${i + 2} x ${i + 2} '),
                              // ),
                              ),
                        ),
                      );
                    }),
              ),
              Spacer(),
              Container(
                height: h * 0.1,
                width: w,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: C.icons.length,
                    itemBuilder: (c, i) {
                      return InkWell(
                        onTap: () {
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
                          padding: EdgeInsets.all(h * 0.01),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: h * 0.05,
                            backgroundImage: AssetImage(C.icons[i]),
                          ),
                        ),
                      );
                    }),
              ),
              Spacer(),
              Row(
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
                          radius: h * 0.085,
                          backgroundColor: playerNo == 0
                              ? Colors.black
                              : Colors.grey.shade200,
                          child: CircleAvatar(
                            radius: h * 0.08,
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
                          borderRadius: BorderRadius.circular(h * 0.02 * 0),
                          child: Container(
                            height: h * 0.08,
                            width: w * 0.4,
                            child: Image.asset('assets/player1nobg.webp'),
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
                          radius: h * 0.085,
                          backgroundColor: playerNo != 0
                              ? Colors.black
                              : Colors.grey.shade200,
                          child: CircleAvatar(
                            radius: h * 0.08,
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
                          borderRadius: BorderRadius.circular(h * 0.02 * 0),
                          child: Container(
                            height: h * 0.08,
                            width: w * 0.4,
                            child: Image.asset('assets/player2nobg.webp'),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                   audioCache.play('tap2.mp3');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) =>
                              GridPage(whichGridNo + 1, p1no, p2no)));
                },
                child: Padding(
                  padding: EdgeInsets.all(h * 0.02),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(h * 0.02),
                    child: Container(
                      height: h * 0.1,
                      width: w * 0.7,
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.asset('assets/play1.webp')),
                    ),
                  ),
                ),
              )
            ],
          ),
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
      width: d,
      padding: EdgeInsets.all(gap),
      color: C.gridcolors[ind],
      child: GridView.builder(
          itemCount: (ind + 2) * (ind + 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
