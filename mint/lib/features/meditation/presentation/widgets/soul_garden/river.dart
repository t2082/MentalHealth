import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Widget dòng sông với hiệu ứng nước chảy nhẹ nhàng
/// Chiều cao cố định 150px, có thể tùy chỉnh màu sắc
class RiverWidget extends StatefulWidget {
  /// Màu sắc chính của dòng sông
  final Color riverColor;

  /// Màu sắc highlight cho hiệu ứng ánh sáng
  final Color? highlightColor;

  /// Tốc độ chảy của dòng nước (0.0 - 2.0)
  final double flowSpeed;

  /// Độ cao của sóng nước (0.0 - 1.0)
  final double waveHeight;

  /// Chiều rộng của widget
  final double? width;

  const RiverWidget({
    super.key,
    this.riverColor = const Color(0xFF4A90E2), // Màu xanh dương mặc định
    this.highlightColor,
    this.flowSpeed = 1.0,
    this.waveHeight = 0.3,
    this.width,
  });

  @override
  State<RiverWidget> createState() => _RiverWidgetState();
}

class _RiverWidgetState extends State<RiverWidget>
    with TickerProviderStateMixin {
  late AnimationController _flowController;
  late AnimationController _shimmerController;

  late Animation<double> _flowAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Animation cho dòng nước chảy
    _flowController = AnimationController(
      duration: Duration(seconds: (4 / widget.flowSpeed).round()),
      vsync: this,
    )..repeat();

    // Animation cho hiệu ứng ánh sáng lấp lánh
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _flowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flowController,
      curve: Curves.linear,
    ));

    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flowController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: widget.width ?? double.infinity,
        height: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: widget.riverColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          child: AnimatedBuilder(
            animation: Listenable.merge([_flowAnimation, _shimmerAnimation]),
            builder: (context, child) {
              return CustomPaint(
                painter: _RiverPainter(
                  riverColor: widget.riverColor,
                  highlightColor: widget.highlightColor ??
                      widget.riverColor.withValues(alpha: 0.7),
                  flowProgress: _flowAnimation.value,
                  shimmerProgress: _shimmerAnimation.value,
                  waveHeight: widget.waveHeight,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ),
    );
  }
}

/// CustomPainter để vẽ hiệu ứng dòng sông
class _RiverPainter extends CustomPainter {
  final Color riverColor;
  final Color highlightColor;
  final double flowProgress;
  final double shimmerProgress;
  final double waveHeight;

  _RiverPainter({
    required this.riverColor,
    required this.highlightColor,
    required this.flowProgress,
    required this.shimmerProgress,
    required this.waveHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ nền dòng sông
    _drawRiverBase(canvas, size);

    // Vẽ hiệu ứng ánh sáng
    _drawShimmerEffect(canvas, size);

    // Vẽ bọt nước nhỏ
    // _drawWaterBubbles(canvas, size);
  }

  /// Vẽ nền cơ bản của dòng sông với hiệu ứng độ sâu
  void _drawRiverBase(Canvas canvas, Size size) {
    // Vẽ lớp nền sâu
    final deepPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.3),
        radius: 1.2,
        colors: [
          riverColor.withValues(alpha: 0.6),
          riverColor.withValues(alpha: 0.8),
          riverColor,
          riverColor.withValues(alpha: 0.95),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      deepPaint,
    );

    // Vẽ hiệu ứng khúc xạ ánh sáng từ trên xuống
    _drawLightRefraction(canvas, size);
  }

  /// Vẽ hiệu ứng khúc xạ ánh sáng từ bề mặt xuống đáy
  void _drawLightRefraction(Canvas canvas, Size size) {
    final refractionPaint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.overlay;

    // Tạo các tia sáng khúc xạ từ trên xuống
    for (int i = 0; i < 6; i++) {
      final x = size.width * (i / 6.0) + (flowProgress * size.width * 0.1);
      final phase = flowProgress * math.pi + (i * math.pi / 3);

      // Tạo path cho tia sáng khúc xạ
      final path = Path();
      final topX = x + 20 * math.sin(phase);
      final bottomX =
          x + 40 * math.sin(phase * 0.7) + 15 * math.cos(phase * 1.3);

      path.moveTo(topX, 0);
      path.quadraticBezierTo(x + 30 * math.sin(phase * 1.1), size.height * 0.4,
          bottomX, size.height);

      // Gradient cho tia khúc xạ
      final refractionGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          highlightColor.withValues(alpha: 0.1),
          highlightColor.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      );

      refractionPaint.shader = refractionGradient.createShader(
          Rect.fromLTWH(math.min(topX, bottomX) - 20, 0, 40, size.height));

      refractionPaint.strokeWidth = 8 + 4 * math.sin(phase);
      refractionPaint.style = PaintingStyle.stroke;
      refractionPaint.strokeCap = StrokeCap.round;

      canvas.drawPath(path, refractionPaint);
    }
  }

  /// Vẽ hiệu ứng ánh sáng phản chiếu thật như trên mặt nước
  void _drawShimmerEffect(Canvas canvas, Size size) {
    _drawSparkles(canvas, size);
  }

  /// Vẽ các điểm sáng lấp lánh nhỏ với hiệu ứng infinity trôi mãi không hết
  void _drawSparkles(Canvas canvas, Size size) {
    final sparklePaint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    // Tạo nhiều lớp sparkles với tốc độ khác nhau để tạo hiệu ứng infinity
    _drawSparkleLayer(canvas, size, sparklePaint, 20, 1.0, 0.0); // Lớp chính
    _drawSparkleLayer(canvas, size, sparklePaint, 15, 0.7, 0.3); // Lớp chậm hơn
    _drawSparkleLayer(
        canvas, size, sparklePaint, 10, 1.3, 0.6); // Lớp nhanh hơn
    _drawSparkleLayer(canvas, size, sparklePaint, 8, 0.5, 0.8); // Lớp rất chậm
  }

  /// Vẽ một lớp sparkles với tốc độ và offset riêng
  void _drawSparkleLayer(Canvas canvas, Size size, Paint paint, int count,
      double speedMultiplier, double phaseOffset) {
    final random = math.Random(
        123 + (speedMultiplier * 100).toInt()); // Seed khác nhau cho mỗi lớp

    for (int i = 0; i < count; i++) {
      // Tạo vị trí ban đầu ngẫu nhiên
      final baseX = size.width * random.nextDouble();
      final baseY = size.height * (0.1 + random.nextDouble() * 0.8);

      // Tạo hiệu ứng trôi liên tục với tốc độ khác nhau
      final flowOffset = (flowProgress * speedMultiplier + phaseOffset) % 1.0;
      final x =
          (baseX + flowOffset * size.width * 1.5) % (size.width + 50) - 25;

      // Tạo chuyển động sóng dọc theo chiều cao
      final wavePhase = flowProgress * 2 * math.pi * speedMultiplier + i * 0.5;
      final y = baseY + 8 * math.sin(wavePhase) + 4 * math.cos(wavePhase * 1.3);

      // Tạo hiệu ứng fade in/out liên tục
      final sparklePhase =
          (shimmerProgress * speedMultiplier + i * 0.15 + phaseOffset) % 1.0;
      final brightness = _calculateSparkleBrightness(sparklePhase, i);

      // Tạo hiệu ứng xuất hiện/biến mất ở các cạnh
      final edgeFade = _calculateEdgeFade(x, size.width);
      final finalBrightness = brightness * edgeFade;

      if (finalBrightness > 0.1) {
        // Kích thước thay đổi theo brightness và tốc độ
        final sparkleSize =
            (1.5 + finalBrightness * 4) * (0.8 + speedMultiplier * 0.2);

        // Màu sắc với alpha thay đổi
        paint.color = highlightColor.withValues(alpha: finalBrightness * 0.8);

        // Vẽ sparkle với nhiều hình dạng khác nhau
        _drawSparkleShape(canvas, Offset(x, y), sparkleSize, paint, i % 3);
      }
    }
  }

  /// Tính toán độ sáng của sparkle với hiệu ứng phức tạp
  double _calculateSparkleBrightness(double phase, int index) {
    // Kết hợp nhiều sóng sin/cos để tạo hiệu ứng tự nhiên
    final primary = math.pow(math.sin(phase * math.pi), 2).toDouble();
    final secondary = math.sin(phase * 2 * math.pi + index * 0.3) * 0.3 + 0.7;
    final tertiary = math.cos(phase * 3 * math.pi + index * 0.7) * 0.2 + 0.8;

    return primary * secondary * tertiary;
  }

  /// Tính toán hiệu ứng fade ở các cạnh để sparkles xuất hiện/biến mất mượt mà
  double _calculateEdgeFade(double x, double width) {
    const fadeDistance = 30.0;

    if (x < fadeDistance) {
      return math.max(0.0, x / fadeDistance);
    } else if (x > width - fadeDistance) {
      return math.max(0.0, (width - x) / fadeDistance);
    }
    return 1.0;
  }

  /// Vẽ sparkle với các hình dạng khác nhau
  void _drawSparkleShape(
      Canvas canvas, Offset center, double size, Paint paint, int shapeType) {
    switch (shapeType) {
      case 0: // Hình thập tự cổ điển
        _drawCrossSparkle(canvas, center, size, paint);
        break;
      case 1: // Hình sao 4 cánh
        _drawStarSparkle(canvas, center, size, paint);
        break;
      case 2: // Hình tròn với tia sáng
        _drawCircleSparkle(canvas, center, size, paint);
        break;
    }
  }

  /// Vẽ sparkle hình thập tự
  void _drawCrossSparkle(
      Canvas canvas, Offset center, double size, Paint paint) {
    // Tia ngang
    canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: size * 1.8,
        height: size * 0.4,
      ),
      paint,
    );

    // Tia dọc
    canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: size * 0.4,
        height: size * 1.8,
      ),
      paint,
    );
  }

  /// Vẽ sparkle hình sao 4 cánh
  void _drawStarSparkle(
      Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final radius = size * 0.8;

    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final r = (i % 2 == 0) ? radius : radius * 0.4;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  /// Vẽ sparkle hình tròn với tia sáng
  void _drawCircleSparkle(
      Canvas canvas, Offset center, double size, Paint paint) {
    // Vẽ tròn trung tâm
    canvas.drawCircle(center, size * 0.3, paint);

    // Vẽ các tia sáng xung quanh
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final startX = center.dx + size * 0.4 * math.cos(angle);
      final startY = center.dy + size * 0.4 * math.sin(angle);
      final endX = center.dx + size * 0.9 * math.cos(angle);
      final endY = center.dy + size * 0.9 * math.sin(angle);

      paint.strokeWidth = size * 0.15;
      paint.strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Reset paint style
    paint.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(covariant _RiverPainter oldDelegate) {
    return oldDelegate.flowProgress != flowProgress ||
        oldDelegate.shimmerProgress != shimmerProgress ||
        oldDelegate.riverColor != riverColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.waveHeight != waveHeight;
  }
}
