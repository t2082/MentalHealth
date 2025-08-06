import 'package:flutter/material.dart';

class Grass extends StatelessWidget {
  final double size;

  const Grass({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GrassPainter(
        size: size,
      ),
    );
  }
}

class _GrassPainter extends CustomPainter {
  final double size;

  _GrassPainter({required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round; // Bo góc mượt

    // Tạo đường cong mượt mà với cubic bezier
    final path = Path();

    // Điểm bắt đầu và kết thúc
    final startX = size.width * 0.05;
    final endX = size.width * 0.95;
    final centerY = size.height * 0.5;
    final width = endX - startX;

    path.moveTo(startX, centerY);

    // Tạo đường cong mượt với cubic bezier curves
    // Chia thành các segment nhỏ để tạo độ uốn lượn tự nhiên
    const numSegments = 8;
    final segmentWidth = width / numSegments;

    for (int i = 0; i < numSegments; i++) {
      final t = i / numSegments;
      final nextT = (i + 1) / numSegments;

      // Tạo độ lệch Y tự nhiên với sin wave
      final currentY = centerY +
          15 *
              (0.5 - 0.5 * (2 * t - 1).abs()) *
              (i % 2 == 0 ? 1 : -1) *
              (0.8 + 0.4 * (1 - (2 * t - 1).abs()));
      final nextY = centerY +
          15 *
              (0.5 - 0.5 * (2 * nextT - 1).abs()) *
              ((i + 1) % 2 == 0 ? 1 : -1) *
              (0.8 + 0.4 * (1 - (2 * nextT - 1).abs()));

      final currentX = startX + t * width;
      final nextX = startX + nextT * width;

      // Control points để tạo đường cong mượt
      final control1X = currentX + segmentWidth * 0.3;
      final control1Y = currentY;
      final control2X = nextX - segmentWidth * 0.3;
      final control2Y = nextY;

      path.cubicTo(
        control1X,
        control1Y,
        control2X,
        control2Y,
        nextX,
        nextY,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
