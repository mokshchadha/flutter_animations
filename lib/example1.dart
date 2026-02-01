import 'dart:math';

import 'package:flutter/material.dart';

class Example1Widget extends StatefulWidget {
  const Example1Widget({super.key});

  @override
  State<Example1Widget> createState() => _Example1WidgetState();
}

class _Example1WidgetState extends State<Example1Widget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // 0.0 = 0 degrees
  // 0.5 = 180 degree
  // 1.0 = 360 degree
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          _animation, // whenever this animation cahnges the builder function is callsed
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..rotateZ(_animation.value),
          alignment: Alignment.center,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
          ),
        );
      },
    );
  }
}
