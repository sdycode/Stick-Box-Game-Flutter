import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShapeScreen extends StatefulWidget {
  List<Offset> hPoints;
   List<Offset> vPoints;
  double x;
  double s;
  int n;
  ShapeScreen(this.hPoints, this.vPoints,  this.x, this.s, this.n, {Key? key})
      : super(key: key);

  @override
  State<ShapeScreen> createState() => _ShapeScreenState();
}

Offset o = Offset.zero;

class _ShapeScreenState extends State<ShapeScreen> {
  List<Widget> widgets = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.hPoints.forEach((e) {
      widgets.add(Positioned(
        left: e.dx,
        top: e.dy,
        child: Container(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    double t = MediaQuery.of(context).viewPadding.top;
    double linew = 2;

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
            height: h,
            width: w,
            margin: EdgeInsets.only(top: t*2),
            color: Colors.orange.shade100,
            child: Transform.translate(
              offset: Offset(0, 0),
              child: 
              Stack(
                children: [
                  // ...widgets.map((e) => null)
                  ...(widget.hPoints.map((e) {
                    return Positioned(
                      left: e.dx+widget.x,
                      top: e.dy,
                      child: InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          height: widget.x * 3,
                          width: widget.s,
                          color: Colors.purple.shade300.withAlpha(0),
                          child: ClipPath(
                            clipper: MyPointsHLinesClipper(widget.x, widget.s),
                            child: Container(color: Colors.amber.shade300),
                          ),
                        ),
                      ),
                    );
                  }).toList()),
                
                  ...(widget.vPoints.map((e) {
                    return Positioned(
                      left: e.dx,
                      top: e.dy+widget.x,
                      child: InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          width: widget.x * 3,
                          height: widget.s,
                          color: Colors.purple.shade300.withAlpha(0),
                          child: ClipPath(
                            clipper: MyPointsVLinesClipper(widget.x, widget.s),
                            child: Container(
                                color: Color.fromARGB(255, 220, 2, 194).withAlpha(180)),
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
         
         
            )
            //  Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     // CustomPaint(
            //     //   size: Size(
            //     //       w * 0.6,
            //     //       (w * 0.6 * 0.5833333333333334)
            //     //           .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            //     //   painter: RPSCustomPainter(),
            //     // ),
    
            //     CustomPaint(
            //       // size: Size(300, 300),
            //       // child: Container(
            //       //   height: 300,
            //       //   width: 300,
            //       //   color: Colors.amber.shade100.withAlpha(80),
            //       // ),
            //       painter: PointsPainter(widget.hPoints),
            //     ),
    
            //     Text(
            //       o.toString(),
            //       style: TextStyle(fontSize: 30),
            //     ),
            //     // Container(
            //     //   color: Colors.purple,
            //     //   height: h * 0.5,
            //     //   width: h * 0.4,
            //     //   child: GestureDetector(
            //     //     onTapDown: (d) {
            //     //       setState(() {
            //     //         o = d.localPosition;
            //     //       });
            //     //       print(
            //     //           "on Tapp ${d.globalPosition}  and local ${d.localPosition}");
            //     //     },
            //     //     child: ClipPath(
            //     //       clipper: MyClipper(),
            //     //       child: Container(color: Colors.amber.shade300),
            //     //     ),
            //     //   ),
            //     // )
            //   ],
            // ),
    
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
    path0.moveTo(0, x);
    path0.lineTo(x, 0);
    path0.lineTo(6 * x, 0);

    path0.lineTo(7 * x, x);

    path0.lineTo(7 * x, 2 * x);
    path0.lineTo(6 * x, 3 * x);
    path0.lineTo(7 * x, 3 * x);
    path0.lineTo(x, 3 * x);
    path0.lineTo(0, 2 * x);
    // path0.lineTo(x, 0);
    // path0.lineTo(x, 0);

    // path0.lineTo(x, 0);

    // path0.lineTo(x, 0);

    // path0.lineTo(x, 0);
    // path0.lineTo(x, 0);

    // path0.lineTo(x, 0);
    // path0.lineTo(x, 0);

    // path0.lineTo(x, 0);

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

class PointsPainter extends CustomPainter {
  List<Offset> p;
  PointsPainter(this.p);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    // p.forEach((e) {});
    for (int i = 0; i < p.length - 1; i++) {
      canvas.drawPoints(
          PointMode.points,
          [p[i], p[i + 1]],
          Paint()
            ..color = Colors.red
            ..strokeWidth = 3);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.4150000, size.height * 0.5000000);
    path0.lineTo(size.width * 0.4566667, size.height * 0.4300000);
    path0.lineTo(size.width * 0.4983333, size.height * 0.3571429);
    path0.lineTo(size.width * 0.5833333, size.height * 0.3557143);
    path0.lineTo(size.width * 0.6666667, size.height * 0.4985714);
    path0.lineTo(size.width * 0.5825000, size.height * 0.6414286);
    path0.lineTo(size.width * 0.5000000, size.height * 0.6414286);
    path0.lineTo(size.width * 0.4150000, size.height * 0.5000000);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.4150000, size.height * 0.5000000);
    path0.lineTo(size.width * 0.4566667, size.height * 0.4300000);
    path0.lineTo(size.width * 0.4983333, size.height * 0.3571429);
    path0.lineTo(size.width * 0.5833333, size.height * 0.3557143);
    path0.lineTo(size.width * 0.6666667, size.height * 0.4985714);
    path0.lineTo(size.width * 0.5825000, size.height * 0.6414286);
    path0.lineTo(size.width * 0.5000000, size.height * 0.6414286);
    path0.lineTo(size.width * 0.4150000, size.height * 0.5000000);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
