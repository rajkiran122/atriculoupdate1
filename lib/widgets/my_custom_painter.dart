import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

const Color darkBlue = Color(0xff092E34);
const Color lightBlue = Color(0xff489FB5);
const Color orange = Color(0xffFFA62B);
const Color darkOrange = Color(0xffCC7700);

class MyCustomPainter extends CustomPainter {
  MyCustomPainter(Animation<double> animation)
      : bluePaint = Paint()
          ..color = lightBlue
          ..style = PaintingStyle.fill,
        greyPaint = Paint()
          ..color = Color(0xFF0d1212)
          ..style = PaintingStyle.fill,
        orangePaint = Paint()
          ..color = orange
          ..style = PaintingStyle.fill,
        liquidAnim = CurvedAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInBack,
          parent: animation,
        ),
        orangeAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.7,
            curve: Interval(0, 0.8, curve: SpringCurve()),
          ),
          reverseCurve: Curves.linear,
        ),
        greyAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.8,
            curve: Interval(0, 0.9, curve: SpringCurve()),
          ),
          reverseCurve: Curves.easeInCirc,
        ),
        blueAnim = CurvedAnimation(
          parent: animation,
          curve: const SpringCurve(),
          reverseCurve: Curves.easeInCirc,
        ),
        super(repaint: animation);

  final Animation<double> liquidAnim;
  final Animation<double> greyAnim;
  final Animation<double> blueAnim;
  final Animation<double> orangeAnim;

  final Paint bluePaint;
  final Paint greyPaint;
  final Paint orangePaint;

  @override
  void paint(Canvas canvas, Size size) {
    drawBluePaint(canvas, size);
    paintGrey(size, canvas);
    paintOrange(size, canvas);
  }

  void drawBluePaint(Canvas canvas, Size size) {
    Path bluePath = Path();
    bluePath.moveTo(size.width, size.height / 2);
    bluePath.lineTo(size.width, 0);
    bluePath.lineTo(0, 0);
    bluePath.lineTo(
      0,
      lerpDouble(0, size.height, blueAnim.value),
    );
    _addPointsToPath(bluePath, [
      Point(
        lerpDouble(0, size.width / 3, blueAnim.value),
        lerpDouble(0, size.height, blueAnim.value),
      ),
      Point(
        lerpDouble(size.width / 2, size.width / 4 * 3, liquidAnim.value),
        lerpDouble(size.height / 2, size.height / 4 * 3, liquidAnim.value),
      ),
      Point(
        size.width,
        lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value),
      ),
    ]);
    bluePath.close();
    canvas.drawPath(bluePath, bluePaint);
  }

  void paintGrey(Size size, Canvas canvas) {
    final path = Path();
    path.moveTo(size.width, 300);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(
        size.height / 4,
        size.height / 2,
        greyAnim.value,
      ),
    );
    _addPointsToPath(
      path,
      [
        Point(
          size.width / 4,
          lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 5,
          lerpDouble(size.height / 4, size.height / 2, liquidAnim.value),
        ),
        Point(
          size.width * 4 / 5,
          lerpDouble(size.height / 6, size.height / 3, greyAnim.value),
        ),
        Point(
          size.width,
          lerpDouble(size.height / 5, size.height / 4, greyAnim.value),
        ),
      ],
    );

    canvas.drawPath(path, greyPaint);
  }

  void paintOrange(Size size, Canvas canvas) {
    if (orangeAnim.value > 0) {
      final path = Path();

      path.moveTo(size.width * 3 / 4, 0);
      path.lineTo(0, 0);
      path.lineTo(
        0,
        lerpDouble(0, size.height / 12, orangeAnim.value),
      );

      _addPointsToPath(path, [
        Point(
          size.width / 7,
          lerpDouble(0, size.height / 6, liquidAnim.value),
        ),
        Point(
          size.width / 3,
          lerpDouble(0, size.height / 10, liquidAnim.value),
        ),
        Point(
          size.width / 3 * 2,
          lerpDouble(0, size.height / 8, liquidAnim.value),
        ),
        Point(
          size.width * 3 / 4,
          0,
        ),
      ]);

      canvas.drawPath(path, orangePaint);
    }
  }

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError('Need three or more points to create a path.');
    }

    for (var i = 0; i < points.length - 2; i++) {
      final xc = (points[i].x + points[i + 1].x) / 2;
      final yc = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xc, yc);
    }

    // connect the last two points
    path.quadraticBezierTo(
        points[points.length - 2].x,
        points[points.length - 2].y,
        points[points.length - 1].x,
        points[points.length - 1].y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

/// Custom curve to give gooey spring effect
class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return (-(pow(e, -t / a) * cos(t * w)) + 1).toDouble();
  }
}
