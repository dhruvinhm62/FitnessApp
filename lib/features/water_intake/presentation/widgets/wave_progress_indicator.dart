import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveProgressIndicator extends StatefulWidget {
  final double percentage; // 0.0 to 1.0

  const WaveProgressIndicator({Key? key, required this.percentage}) : super(key: key);

  @override
  _WaveProgressIndicatorState createState() => _WaveProgressIndicatorState();
}

class _WaveProgressIndicatorState extends State<WaveProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(
            animationValue: _controller.value,
            percentage: widget.percentage,
          ),
          child: Container(),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double percentage;

  WavePainter({required this.animationValue, required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    // Cap visual fill at 85% so 15% is always empty at the top for the wave animation
    final visualPercentage = percentage * 0.85;
    final fillLevel = size.height * (1 - visualPercentage);

    final path1 = Path();
    final path2 = Path();

    final paint1 = Paint()
      ..color = const Color(0xFF4A90E2).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF2180F5)
      ..style = PaintingStyle.fill;

    // Wave 1
    path1.moveTo(0, size.height);
    path1.lineTo(0, fillLevel);
    for (double i = 0.0; i < size.width; i++) {
      path1.lineTo(
          i,
          fillLevel +
              math.sin((i / size.width * 2 * math.pi) +
                      (animationValue * 2 * math.pi)) *
                  15);
    }
    path1.lineTo(size.width, size.height);
    path1.close();

    // Wave 2
    path2.moveTo(0, size.height);
    path2.lineTo(0, fillLevel);
    for (double i = 0.0; i < size.width; i++) {
      path2.lineTo(
          i,
          fillLevel +
              math.sin((i / size.width * 2 * math.pi) +
                      (animationValue * 2 * math.pi) +
                      math.pi) *
                  20);
    }
    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
