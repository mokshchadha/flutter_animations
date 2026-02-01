import 'dart:math';

import 'package:flutter/material.dart';

// extension on TickerFuture {
//   Future<void> delayed(Duration duration) => Future.delayed(duration, this);
// }

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:

        /// first the point should move the the x cordinates
        path.moveTo(size.width, 0.0);

        /// then it should move to y bottom cordinate
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        path.moveTo(0, 0); // here no need as we start from the origin
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwise,
    );

    path.close();
    return path;
  }
}

class HalfCircleCustomClipper extends CustomClipper<Path> {
  final CircleSide side;
  const HalfCircleCustomClipper({required this.side});

  @override
  Path getClip(Size size) {
    Path path = side.toPath(size);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _counterClockwiseRotationAnimation =
        Tween(
              begin: 0.0,
              end: -pi / 2,
            ) // this negative angle gives use the coutner clockwise tilt
            .animate(
              CurvedAnimation(
                parent: _counterClockwiseRotationController,
                curve: Curves.bounceOut,
              ),
            );

    _flipAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _flipAnimation = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _flipAnimationController,
        curve: Curves.decelerate,
      ),
    );

    _counterClockwiseRotationAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // reset and start the flip
        _flipAnimation =
            Tween(
              begin: _flipAnimation.value,
              end: _flipAnimation.value + pi,
            ).animate(
              CurvedAnimation(
                parent: _flipAnimationController,
                curve: Curves.decelerate,
              ),
            );
        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween(
          begin: _counterClockwiseRotationAnimation.value,
          end: _counterClockwiseRotationAnimation.value - pi / 2,
        ).animate(_counterClockwiseRotationController);

        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset()
      ..forward();
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _counterClockwiseRotationAnimation,
          _flipAnimation,
        ]),
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateZ(_counterClockwiseRotationAnimation.value),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  transform: Matrix4.identity()..rotateX(_flipAnimation.value),
                  alignment: Alignment.center,
                  child: ClipPath(
                    clipper: HalfCircleCustomClipper(side: CircleSide.left),
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.identity()..rotateX(_flipAnimation.value),
                  alignment: Alignment.center,
                  child: ClipPath(
                    clipper: HalfCircleCustomClipper(side: CircleSide.right),
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
