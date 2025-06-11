import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final List<_Star> _stars = List.generate(
    50,
    (i) {
      final rand = Random();
      return _Star(
        x: rand.nextDouble(),
        y: rand.nextDouble(),
        radius: rand.nextDouble() * 1.5 + 0.5,
        twinkle: rand.nextDouble() * pi * 2,
        speed: rand.nextDouble() * 0.5 + 0.2,
      );
    },
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
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
        return Stack(
          children: [
            // 배경색 제거: 투명하게
            CustomPaint(
              painter: _BackgroundPainter(_controller.value, _stars),
              size: MediaQuery.of(context).size,
            ),
          ],
        );
      },
    );
  }
}

class _Star {
  final double x, y, radius, twinkle, speed;
  _Star({required this.x, required this.y, required this.radius, required this.twinkle, required this.speed});
}

class _BackgroundPainter extends CustomPainter {
  final double progress;
  final List<_Star> stars;
  _BackgroundPainter(this.progress, this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60)
      ..style = PaintingStyle.fill;

    // 곡선을 따라 움직이는 원들의 중심 좌표 계산
    final path1 = Offset(
      size.width * (0.2 + 0.1 * sin(progress * 2 * pi)),
      size.height * (0.3 + 0.1 * cos(progress * 2 * pi)),
    );
    final path2 = Offset(
      size.width * (0.5 + 0.15 * cos(progress * 2 * pi)),
      size.height * (0.5 + 0.1 * sin(progress * 2 * pi)),
    );
    final path3 = Offset(
      size.width * (0.8 + 0.1 * sin(progress * 2 * pi + pi)),
      size.height * (0.4 + 0.1 * cos(progress * 2 * pi + pi)),
    );
    final path4 = Offset(
      size.width * (0.2 + 0.1 * sin(progress * 2 * pi + pi)),
      size.height * (0.3 + 0.1 * cos(progress * 2 * pi + pi)),
    );

    // 파스텔톤 색상
    
    final color1 = const Color.fromARGB(255, 255, 230, 0).withOpacity(0.05); // 하늘색
    final color2 = const Color.fromARGB(248, 0, 153, 255).withOpacity(0.05); // 분홍색
    final color3 = const Color.fromARGB(255, 102, 255, 0).withOpacity(0.05); // 노란색
    final color4 = const Color.fromARGB(255, 242, 101, 255).withOpacity(0.05); // 보라색


    // 원 그리기
    paint.color = color1;
    canvas.drawCircle(path1, size.width * 0.27, paint);
    paint.color = color2;
    canvas.drawCircle(path2, size.width * 0.30, paint);
    paint.color = color3;
    canvas.drawCircle(path3, size.width * 0.26, paint);
    paint.color = color4;
    canvas.drawCircle(path4, size.width * 0.26, paint);

    // 별(점) 그리기
    final starPaint = Paint()..color = const Color.fromARGB(255, 110, 121, 72).withOpacity(0.5);
    for (final star in stars) {
      // 미세한 움직임: sin/cos, twinkle, progress, speed 활용
      final dx = star.x * size.width + 8 * sin(progress * 2 * pi * star.speed + star.twinkle);
      final dy = star.y * size.height + 8 * cos(progress * 2 * pi * star.speed + star.twinkle);
      final r = star.radius + 0.5 * sin(progress * 2 * pi + star.twinkle);
      canvas.drawCircle(Offset(dx, dy), r, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.stars != stars;
} 