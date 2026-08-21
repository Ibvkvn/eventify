import 'dart:math';

import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  const CustomProgressIndicator({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  int barCount = 8;

  @override
  void initState () {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    )..repeat();
  }

  @override
  void dispose () {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.5);

    return AnimatedBuilder(
      animation: animationController, 
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: SpinnerPainter(
            progress: animationController.value,
            color: effectiveColor
          ),
        );
      }
    );
  }
}

class SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;
  static int barCount = 8;

  const SpinnerPainter({
    required this.color,
    required this.progress
  });


  @override
  void paint (Canvas canvas, Size size){
    final center = Offset(size.width/ 2, size.height / 2);
    final outterRadius = size.width / 2;
    final innerRadius = outterRadius / 2;
    final barLenght = outterRadius - innerRadius;
    final barWidth = size.width * 0.08;

    for (double i = 0; i < barCount; i++) {
      final angle = (2 * pi * i)/barCount;

      final distanceFromHead = ((i / barCount) - progress ) % 1.0;
      final opacity = (1.0 - distanceFromHead).clamp(0.15, 1.0);
      final paint = Paint()..color = color.withOpacity(opacity)..strokeWidth = barWidth..strokeCap = StrokeCap.round;
      final start = center + Offset(cos(angle), sin(angle)) * innerRadius;
      final end = center + Offset(cos(angle), sin(angle)) * (innerRadius +barLenght);

      canvas.drawLine(start, end, paint);
    }
  }

  bool shouldRepaint(covariant SpinnerPainter oldDelegate){
    return oldDelegate.progress != progress;
  }
}