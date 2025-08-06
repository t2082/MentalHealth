import 'dart:math' as math;
import 'package:flutter/material.dart';

class LandWidget extends StatelessWidget {
  final double size;

  const LandWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Land(
        size: size,
      ),
    );
  }
}

class _Land extends CustomPainter {
  final double size;

  _Land({required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    _drawGreenEllipse(canvas, size);
    _drawSoilFill(canvas, size);
    _drawVerticalLines(canvas, size);
    _drawConnectingLines(canvas, size);
  }

  void _drawGreenEllipse(Canvas canvas, Size size) {
    // Tạo màu xanh lá với gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.green.shade300, // Xanh lá nhạt ở trên - không opacity
        Colors.green.shade600, // Xanh lá đậm ở dưới - không opacity
      ],
    );

    // Vị trí trung tâm của ellipse (hơi lệch xuống dưới)
    final centerX = size.width / 2;
    final centerY = size.height * 0.97; // Đặt ở 97% chiều cao

    // Kích thước ellipse
    final ellipseWidth = size.width * 0.7; // 70% chiều rộng
    final ellipseHeight = size.height * 0.2; // 20% chiều cao

    // Tạo độ cong nhẹ cố định
    const curveFactor = 0.1; // Độ cong cố định 10%
    const tiltAngle = curveFactor * math.pi / 6; // Góc nghiêng cố định

    // Tạo path cho ellipse có độ cong
    final path = Path();

    // Số điểm để tạo ellipse mượt
    const int points = 12;

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;

      // Tính toán điểm trên ellipse cơ bản
      final x = math.cos(angle) * ellipseWidth / 2;
      final y = math.sin(angle) * ellipseHeight / 2;

      // Áp dụng độ cong/xoay
      final rotatedX = x * math.cos(tiltAngle) - y * math.sin(tiltAngle);
      final rotatedY = x * math.sin(tiltAngle) + y * math.cos(tiltAngle);

      // Tạo biến dạng nhỏ cố định dựa trên index để có tính nhất quán
      final noiseX = math.sin(i * 0.5) * ellipseWidth * 0.02;
      final noiseY = math.cos(i * 0.3) * ellipseHeight * 0.015;

      final finalX = centerX + rotatedX + noiseX;
      final finalY = centerY + rotatedY + noiseY;

      if (i == 0) {
        path.moveTo(finalX, finalY);
      } else {
        path.lineTo(finalX, finalY);
      }
    }

    path.close();

    // Tạo Paint với gradient
    final ellipseRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: ellipseWidth,
      height: ellipseHeight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(ellipseRect)
      ..style = PaintingStyle.fill;

    // Vẽ ellipse
    canvas.drawPath(path, paint);
  }

  void _drawSoilFill(Canvas canvas, Size size) {
    // Vị trí trung tâm của ellipse (giống như trong các method khác)
    final centerX = size.width / 2;
    final centerY = size.height * 0.97;

    // Kích thước ellipse (giống như trong các method khác)
    final ellipseWidth = size.width * 0.7;
    final ellipseHeight = size.height * 0.2;

    // Tạo độ cong nhẹ cố định (giống như trong các method khác)
    const curveFactor = 0.1;
    const tiltAngle = curveFactor * math.pi / 6;

    // Số điểm để tạo ellipse mượt (giống như trong các method khác)
    const int points = 12;

    // Paint cho fill đất - gradient từ đậm đến nhẹ với hiệu ứng mờ dần mạnh hơn
    final soilGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.3, 0.7, 1.0], // Nhiều điểm chuyển tiếp hơn
      colors: [
        Colors.brown.shade900.withValues(alpha: 0.9), // Rất đậm ở trên
        Colors.brown.shade800.withValues(alpha: 0.7), // Đậm
        Colors.brown.shade600.withValues(alpha: 0.5), // Trung bình
        Colors.brown.shade500.withValues(alpha: 0.2), // Rất mờ ở dưới
      ],
    );

    // Tạo danh sách các điểm đầu và điểm đích
    List<Offset> startPoints = [];
    List<Offset?> endPoints = [];

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;

      // Tính toán điểm trên ellipse cơ bản (giống như trong _drawVerticalLines)
      final x = math.cos(angle) * ellipseWidth / 2;
      final y = math.sin(angle) * ellipseHeight / 2;

      // Áp dụng độ cong/xoay (giống như trong _drawVerticalLines)
      final rotatedX = x * math.cos(tiltAngle) - y * math.sin(tiltAngle);
      final rotatedY = x * math.sin(tiltAngle) + y * math.cos(tiltAngle);

      // Tạo biến dạng nhỏ cố định dựa trên index (giống như trong _drawVerticalLines)
      final noiseX = math.sin(i * 0.5) * ellipseWidth * 0.02;
      final noiseY = math.cos(i * 0.3) * ellipseHeight * 0.015;

      final startX = centerX + rotatedX + noiseX;
      final startY = centerY + rotatedY + noiseY;

      // Bỏ qua điểm cuối cùng vì nó trùng với điểm đầu tiên
      if (i == points) continue;

      // Lưu điểm đầu (trên ellipse)
      startPoints.add(Offset(startX, startY));

      // Chiều dài của đường thẳng xuống (giống như trong _drawVerticalLines)
      final lineLength = 20 + math.sin(i * 0.8) * 8;

      // Tính toán độ nghiêng dựa trên vị trí so với tâm (giống như trong _drawVerticalLines)
      final distanceFromCenter = startX - centerX;
      final tiltFactor = -distanceFromCenter / (ellipseWidth / 2) * 0.3;

      // Điểm kết thúc của đường thẳng (giống như trong _drawVerticalLines)
      final endX = startX + tiltFactor * lineLength;
      final endY = startY + lineLength;

      // Chỉ lưu điểm đích nếu nó nằm bên ngoài ellipse
      if (!_isPointInsideEllipse(endX, endY, centerX, centerY, ellipseWidth,
          ellipseHeight, tiltAngle)) {
        endPoints.add(Offset(endX, endY));
      } else {
        endPoints.add(null);
      }
    }

    // Vẽ fill cho từng hình tứ giác [i, i+1][a, b]
    for (int i = 0; i < startPoints.length; i++) {
      final nextIndex = (i + 1) % startPoints.length;

      final startPoint1 = startPoints[i]; // Điểm đầu thứ i
      final startPoint2 = startPoints[nextIndex]; // Điểm đầu thứ i+1
      final endPoint1 = endPoints[i]; // Điểm đích thứ i
      final endPoint2 = endPoints[nextIndex]; // Điểm đích thứ i+1

      // Chỉ fill nếu cả hai điểm đích đều hợp lệ
      if (endPoint1 != null && endPoint2 != null) {
        final quadPath = Path();

        // Tạo hình tứ giác: điểm đầu 1 -> điểm đầu 2 -> điểm đích 2 -> điểm đích 1 -> về điểm đầu 1
        quadPath.moveTo(startPoint1.dx, startPoint1.dy);
        quadPath.lineTo(startPoint2.dx, startPoint2.dy);
        quadPath.lineTo(endPoint2.dx, endPoint2.dy);
        quadPath.lineTo(endPoint1.dx, endPoint1.dy);
        quadPath.close();

        // Tạo bounding box cho gradient
        final bounds = quadPath.getBounds();
        final soilFillPaint = Paint()
          ..shader = soilGradient.createShader(bounds)
          ..style = PaintingStyle.fill;

        canvas.drawPath(quadPath, soilFillPaint);
      }
    }
  }

  void _drawVerticalLines(Canvas canvas, Size size) {
    // Vị trí trung tâm của ellipse (giống như trong _drawGreenEllipse)
    final centerX = size.width / 2;
    final centerY = size.height * 0.97;

    // Kích thước ellipse (giống như trong _drawGreenEllipse)
    final ellipseWidth = size.width * 0.7;
    final ellipseHeight = size.height * 0.2;

    // Tạo độ cong nhẹ cố định (giống như trong _drawGreenEllipse)
    const curveFactor = 0.1;
    const tiltAngle = curveFactor * math.pi / 6;

    // Số điểm để tạo ellipse mượt (giống như trong _drawGreenEllipse)
    const int points = 12;

    // Tạo các điểm trên ellipse và vẽ đường thẳng xuống từ mỗi điểm
    // Sử dụng cùng logic như _drawGreenEllipse để đảm bảo điểm khớp chính xác
    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;

      // Tính toán điểm trên ellipse cơ bản (giống như trong _drawGreenEllipse)
      final x = math.cos(angle) * ellipseWidth / 2;
      final y = math.sin(angle) * ellipseHeight / 2;

      // Áp dụng độ cong/xoay (giống như trong _drawGreenEllipse)
      final rotatedX = x * math.cos(tiltAngle) - y * math.sin(tiltAngle);
      final rotatedY = x * math.sin(tiltAngle) + y * math.cos(tiltAngle);

      // Tạo biến dạng nhỏ cố định dựa trên index (giống như trong _drawGreenEllipse)
      final noiseX = math.sin(i * 0.5) * ellipseWidth * 0.02;
      final noiseY = math.cos(i * 0.3) * ellipseHeight * 0.015;

      final startX = centerX + rotatedX + noiseX;
      final startY = centerY + rotatedY + noiseY;

      // Bỏ qua điểm cuối cùng vì nó trùng với điểm đầu tiên (i == points)
      if (i == points) continue;

      // Chiều dài của đường thẳng xuống (cố định dựa trên index để nhất quán)
      final lineLength = 20 + math.sin(i * 0.8) * 8; // Từ 12-28 pixels

      // Tính toán độ nghiêng dựa trên vị trí so với tâm
      final distanceFromCenter = startX - centerX;
      // Nếu ở bên phải (distanceFromCenter > 0) thì nghiêng về trái (âm)
      // Nếu ở bên trái (distanceFromCenter < 0) thì nghiêng về phải (dương)
      final tiltFactor = -distanceFromCenter /
          (ellipseWidth / 2) *
          0.3; // Độ nghiêng tối đa 60%

      // Điểm kết thúc của đường thẳng (nghiêng về phía trung tâm)
      final endX = startX + tiltFactor * lineLength;
      final endY = startY + lineLength;

      // Kiểm tra xem điểm cuối có nằm trong ellipse không
      if (!_isPointInsideEllipse(endX, endY, centerX, centerY, ellipseWidth,
          ellipseHeight, tiltAngle)) {
        // Vẽ đường thẳng với gradient từ đậm đến mờ
        _drawGradientLine(
          canvas,
          Offset(startX, startY),
          Offset(endX, endY),
          Colors.brown.shade800.withValues(alpha: 0.5), // Đậm ở đầu
          Colors.brown.shade600.withValues(alpha: 0.1), // Mờ ở cuối
          1.5,
        );
      }
    }
  }

  void _drawConnectingLines(Canvas canvas, Size size) {
    // Vị trí trung tâm của ellipse (giống như trong các method khác)
    final centerX = size.width / 2;
    final centerY = size.height * 0.97;

    // Kích thước ellipse (giống như trong các method khác)
    final ellipseWidth = size.width * 0.7;
    final ellipseHeight = size.height * 0.2;

    // Tạo độ cong nhẹ cố định (giống như trong các method khác)
    const curveFactor = 0.1;
    const tiltAngle = curveFactor * math.pi / 6;

    // Số điểm để tạo ellipse mượt (giống như trong các method khác)
    const int points = 12;

    // Tạo danh sách các điểm cuối của các đường thẳng
    List<Offset?> endPoints = [];

    for (int i = 0; i <= points; i++) {
      final angle = (i / points) * 2 * math.pi;

      // Tính toán điểm trên ellipse cơ bản (giống như trong _drawVerticalLines)
      final x = math.cos(angle) * ellipseWidth / 2;
      final y = math.sin(angle) * ellipseHeight / 2;

      // Áp dụng độ cong/xoay (giống như trong _drawVerticalLines)
      final rotatedX = x * math.cos(tiltAngle) - y * math.sin(tiltAngle);
      final rotatedY = x * math.sin(tiltAngle) + y * math.cos(tiltAngle);

      // Tạo biến dạng nhỏ cố định dựa trên index (giống như trong _drawVerticalLines)
      final noiseX = math.sin(i * 0.5) * ellipseWidth * 0.02;
      final noiseY = math.cos(i * 0.3) * ellipseHeight * 0.015;

      final startX = centerX + rotatedX + noiseX;
      final startY = centerY + rotatedY + noiseY;

      // Bỏ qua điểm cuối cùng vì nó trùng với điểm đầu tiên
      if (i == points) continue;

      // Chiều dài của đường thẳng xuống (giống như trong _drawVerticalLines)
      final lineLength = 20 + math.sin(i * 0.8) * 8;

      // Tính toán độ nghiêng dựa trên vị trí so với tâm (giống như trong _drawVerticalLines)
      final distanceFromCenter = startX - centerX;
      final tiltFactor = -distanceFromCenter / (ellipseWidth / 2) * 0.3;

      // Điểm kết thúc của đường thẳng (giống như trong _drawVerticalLines)
      final endX = startX + tiltFactor * lineLength;
      final endY = startY + lineLength;

      // Chỉ lưu điểm cuối nếu nó nằm bên ngoài ellipse
      if (!_isPointInsideEllipse(endX, endY, centerX, centerY, ellipseWidth,
          ellipseHeight, tiltAngle)) {
        endPoints.add(Offset(endX, endY));
      } else {
        endPoints.add(null); // Đánh dấu điểm không hợp lệ
      }
    }

    // Vẽ các đường nối giữa các điểm cuối liên tiếp
    for (int i = 0; i < endPoints.length; i++) {
      final currentPoint = endPoints[i];
      final nextPoint = endPoints[(i + 1) % endPoints.length];

      // Chỉ vẽ nếu cả hai điểm đều hợp lệ
      if (currentPoint != null && nextPoint != null) {
        // Kiểm tra xem đường nối có cắt qua ellipse không
        if (!_lineIntersectsEllipse(currentPoint, nextPoint, centerX, centerY,
            ellipseWidth, ellipseHeight, tiltAngle)) {
          // Vẽ đường nối với gradient mờ
          _drawGradientLine(
            canvas,
            currentPoint,
            nextPoint,
            Colors.brown.shade800.withValues(alpha: 0.2), // Mờ ở đầu
            Colors.brown.shade600.withValues(alpha: 0.1), // Rất mờ ở cuối
            1.0, // Độ dày nét bình thường
          );
        }
      }
    }
  }

  // Vẽ đường thẳng với gradient từ màu đầu đến màu cuối
  void _drawGradientLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Color startColor,
    Color endColor,
    double strokeWidth,
  ) {
    // Tạo gradient từ điểm đầu đến điểm cuối
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [startColor, endColor],
    );

    // Tạo rect bao quanh đường thẳng để áp dụng gradient
    final rect = Rect.fromPoints(start, end);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  // Kiểm tra xem một điểm có nằm trong ellipse hay không
  bool _isPointInsideEllipse(
      double pointX,
      double pointY,
      double centerX,
      double centerY,
      double ellipseWidth,
      double ellipseHeight,
      double tiltAngle) {
    // Chuyển điểm về hệ tọa độ tương đối so với tâm ellipse
    final relativeX = pointX - centerX;
    final relativeY = pointY - centerY;

    // Xoay ngược lại để bỏ độ nghiêng của ellipse
    final unrotatedX =
        relativeX * math.cos(-tiltAngle) - relativeY * math.sin(-tiltAngle);
    final unrotatedY =
        relativeX * math.sin(-tiltAngle) + relativeY * math.cos(-tiltAngle);

    // Kiểm tra phương trình ellipse: (x/a)² + (y/b)² <= 1
    final a = ellipseWidth / 2; // Bán trục lớn
    final b = ellipseHeight / 2; // Bán trục nhỏ

    final normalizedX = unrotatedX / a;
    final normalizedY = unrotatedY / b;

    return (normalizedX * normalizedX + normalizedY * normalizedY) <= 1.0;
  }

  // Kiểm tra xem một đường thẳng có cắt qua ellipse hay không
  bool _lineIntersectsEllipse(
      Offset point1,
      Offset point2,
      double centerX,
      double centerY,
      double ellipseWidth,
      double ellipseHeight,
      double tiltAngle) {
    // Kiểm tra nhiều điểm dọc theo đường thẳng
    const int samples = 10;
    for (int i = 0; i <= samples; i++) {
      final t = i / samples;
      final sampleX = point1.dx + (point2.dx - point1.dx) * t;
      final sampleY = point1.dy + (point2.dy - point1.dy) * t;

      // Nếu bất kỳ điểm nào nằm trong ellipse thì đường thẳng cắt qua ellipse
      if (_isPointInsideEllipse(sampleX, sampleY, centerX, centerY,
          ellipseWidth, ellipseHeight, tiltAngle)) {
        return true;
      }
    }

    return false;
  }

  @override
  bool shouldRepaint(covariant _Land oldDelegate) {
    return oldDelegate.size != size;
  }
}
