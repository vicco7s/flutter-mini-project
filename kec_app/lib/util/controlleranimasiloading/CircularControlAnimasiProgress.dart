import 'package:flutter/material.dart';

class ColorfulCirclePrgressIndicator extends StatefulWidget {
  @override
  _ColorfulCirclePrgressIndicatorState createState() => _ColorfulCirclePrgressIndicatorState();
}

class _ColorfulCirclePrgressIndicatorState extends State<ColorfulCirclePrgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _colorAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem<Color?>(
          tween: ColorTween(begin: Colors.deepPurple, end: Colors.green),
          weight: 1,
        ),
        TweenSequenceItem<Color?>(
          tween: ColorTween(begin: Colors.green, end: Colors.yellow),
          weight: 1,
        ),
        TweenSequenceItem<Color?>(
          tween: ColorTween(begin: Colors.yellow, end: Colors.red),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(_colorAnimation.value ?? Colors.transparent),
          );
        },
      ),
    );
  }
}