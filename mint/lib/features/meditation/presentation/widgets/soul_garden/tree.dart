import 'package:flutter/material.dart';
import 'dart:math' as math;

class TreeWidget extends StatelessWidget {
  final double growth;
  final double root;
  final double body;
  final double branch;
  final double leaf;
  final double flower;
  final double fruit;
  final double size;
  final int seed;

  const TreeWidget(
      {required this.growth,
      required this.root,
      required this.body,
      required this.branch,
      required this.leaf,
      required this.flower,
      required this.fruit,
      required this.size,
      required this.seed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _Tree(
            growth: growth,
            root: root,
            body: body,
            branch: branch,
            leaf: leaf,
            flower: flower,
            fruit: fruit,
            size: size,
            seed: seed,
          ),
        ));
  }
}

class _Tree extends CustomPainter {
  final double growth;
  final double root;
  final double body;
  final double branch;
  final double leaf;
  final double flower;
  final double fruit;
  final double size;
  final int seed;

  _Tree(
      {required this.growth,
      required this.root,
      required this.body,
      required this.branch,
      required this.leaf,
      required this.flower,
      required this.fruit,
      required this.size,
      required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    _drawCurvedTrunk(canvas, size, paint);
    _drawBranchPoints(canvas, size);
  }

  void _drawCurvedTrunk(Canvas canvas, Size size, Paint paint) {
    final trunkWidthBottom = size.width * 0.18;
    final trunkWidthTop = size.width * 0.04; // Giảm từ 0.07 xuống 0.04
    final trunkHeight =
        size.height * 0.70; // Tăng từ 0.55 lên 0.70 để cây dài hơn
    final trunkBottom = Offset(size.width / 2, size.height * 0.95);

    // Tạo random generator với seed cố định
    final random = math.Random(seed);
    // Số điểm để tạo đường cong (nhiều điểm = mượt hơn)
    const int segments = 8;
    final List<Offset> leftPoints = [];
    final List<Offset> rightPoints = [];
    // Tạo các điểm cong cho thân cây
    for (int i = 0; i <= segments; i++) {
      final progress = i / segments;
      final y = trunkBottom.dy - (trunkHeight * progress);
      // Tính độ rộng tại điểm này (từ rộng ở dưới đến hẹp ở trên)
      final currentWidth =
          trunkWidthBottom + (trunkWidthTop - trunkWidthBottom) * progress;
      // Tạo độ lệch ngang dựa trên seed (cây sẽ cong)
      final curveFactor = math.sin(progress * math.pi * 2 + seed) *
          0.05; // Độ cong tối đa 5% chiều rộng (giảm từ 8%)
      final bendOffset =
          size.width * curveFactor * progress; // Cong nhiều hơn ở phía trên

      // Thêm một chút nhiễu ngẫu nhiên nhỏ
      final noise = (random.nextDouble() - 0.5) * size.width * 0.02 * progress;

      final centerX = size.width / 2 + bendOffset + noise;

      leftPoints.add(Offset(centerX - currentWidth / 2, y));
      rightPoints.add(Offset(centerX + currentWidth / 2, y));
    }

    // Tạo path cho thân cây cong
    final path = Path();

    // Bắt đầu từ điểm dưới bên trái
    path.moveTo(leftPoints.first.dx, leftPoints.first.dy);

    // Vẽ đường cong bên trái (từ dưới lên trên)
    for (int i = 1; i < leftPoints.length; i++) {
      if (i == 1) {
        path.lineTo(leftPoints[i].dx, leftPoints[i].dy);
      } else {
        // Sử dụng quadratic curve để tạo đường cong mượt
        final controlPoint = Offset(
          (leftPoints[i - 1].dx + leftPoints[i].dx) / 2,
          (leftPoints[i - 1].dy + leftPoints[i].dy) / 2,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          leftPoints[i].dx,
          leftPoints[i].dy,
        );
      }
    }

    // Nối đến điểm trên bên phải
    path.lineTo(rightPoints.last.dx, rightPoints.last.dy);

    // Vẽ đường cong bên phải (từ trên xuống dưới)
    for (int i = rightPoints.length - 2; i >= 0; i--) {
      if (i == rightPoints.length - 2) {
        path.lineTo(rightPoints[i].dx, rightPoints[i].dy);
      } else {
        final controlPoint = Offset(
          (rightPoints[i + 1].dx + rightPoints[i].dx) / 2,
          (rightPoints[i + 1].dy + rightPoints[i].dy) / 2,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          rightPoints[i].dx,
          rightPoints[i].dy,
        );
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBranchPoints(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final trunkHeight = size.height * 0.70; // Đồng bộ với thân cây dài hơn
    final trunkBottom = Offset(size.width / 2, size.height * 0.95);

    // 1. Tìm hướng nghiêng của ngọn cây (phần trên cùng)
    const topProgress = 0.95; // Gần ngọn cây
    final topCurveFactor = math.sin(topProgress * math.pi * 2 + seed) * 0.05;
    final topBendOffset = size.width * topCurveFactor * topProgress;

    // 2. Xác định hướng cân bằng (ngược lại với hướng nghiêng ngọn)
    final needLeftBalance =
        topBendOffset > 0; // Nếu ngọn nghiêng phải thì cần cân bằng trái

    // 3. Tìm phần nhô ra đầu tiên theo hướng cân bằng cho cành đầu tiên
    double bestProgress =
        0.4; // Mặc định - điều chỉnh thấp hơn nữa từ 0.55 xuống 0.4
    bool found = false;

    // Quét từ trên xuống dưới (65% -> 20%) để tìm phần nhô ra đầu tiên - điều chỉnh thấp hơn nữa
    for (double testProgress = 0.65;
        testProgress >= 0.2;
        testProgress -= 0.05) {
      final testCurveFactor =
          math.sin(testProgress * math.pi * 2 + seed) * 0.05;
      final testBendOffset = size.width * testCurveFactor * testProgress;

      // Kiểm tra xem có nhô ra theo hướng cân bằng không
      final isCorrectDirection = needLeftBalance
          ? testBendOffset < -0.01 // Nhô ra bên trái
          : testBendOffset > 0.01; // Nhô ra bên phải

      if (isCorrectDirection && !found) {
        bestProgress = testProgress;
        found = true;
        break; // Lấy phần nhô ra đầu tiên
      }
    }

    // Sử dụng điểm có độ cong lớn nhất cho cành đầu tiên
    final branchHeightRatio = bestProgress;
    final branchY = trunkBottom.dy - (trunkHeight * branchHeightRatio);

    // Tính toán vị trí X tương ứng với đường cong của thân cây
    final progress = branchHeightRatio;
    final curveFactor = math.sin(progress * math.pi * 2 + seed) * 0.05;
    final bendOffset = size.width * curveFactor * progress;
    final noise = (random.nextDouble() - 0.5) * size.width * 0.02 * progress;
    final centerX = size.width / 2 + bendOffset + noise;

    // Tính độ rộng thân cây tại điểm này
    final trunkWidthBottom = size.width * 0.18;
    final trunkWidthTop = size.width * 0.04; // Giảm từ 0.07 xuống 0.04
    final currentWidth =
        trunkWidthBottom + (trunkWidthTop - trunkWidthBottom) * progress;

    // 4. Đặt điểm ở phía cân bằng tại vị trí nhô ra đầu tiên
    // Kéo cành về gần thân cây hơn
    final branchPointX = needLeftBalance
        ? centerX -
            currentWidth *
                0.25 // Đặt bên trái, gần thân hơn (từ 0.5 xuống 0.25)
        : centerX +
            currentWidth *
                0.25; // Đặt bên phải, gần thân hơn (từ 0.5 xuống 0.25)

    final branchPoint = Offset(branchPointX, branchY);

    // Vẽ cành đầu tiên từ điểm gốc
    _drawBranch(canvas, size, branchPoint, needLeftBalance, 1.0, 1.0);

    // 5. Tạo cành thứ hai ở phía ngược lại và thấp hơn
    // Tìm điểm cho cành thứ hai: phía ngược lại và thấp hơn cành đầu tiên
    final secondBranchHeightRatio = bestProgress - 0.15; // Thấp hơn 15%
    if (secondBranchHeightRatio > 0.1) {
      // Đảm bảo không quá thấp
      final secondBranchY =
          trunkBottom.dy - (trunkHeight * secondBranchHeightRatio);

      // Tính toán vị trí X cho cành thứ hai
      final secondProgress = secondBranchHeightRatio;
      final secondCurveFactor =
          math.sin(secondProgress * math.pi * 2 + seed) * 0.05;
      final secondBendOffset = size.width * secondCurveFactor * secondProgress;
      final secondNoise =
          (random.nextDouble() - 0.5) * size.width * 0.02 * secondProgress;
      final secondCenterX = size.width / 2 + secondBendOffset + secondNoise;

      // Tính độ rộng thân cây tại điểm này
      final secondCurrentWidth = trunkWidthBottom +
          (trunkWidthTop - trunkWidthBottom) * secondProgress;

      // Đặt cành thứ hai ở phía ngược lại với cành đầu tiên
      final secondBranchPointX = needLeftBalance
          ? secondCenterX +
              secondCurrentWidth * 0.25 // Đặt bên phải (ngược lại)
          : secondCenterX -
              secondCurrentWidth * 0.25; // Đặt bên trái (ngược lại)

      final secondBranchPoint = Offset(secondBranchPointX, secondBranchY);

      // Vẽ cành thứ hai (nhỏ hơn cành đầu tiên: gốc nhỏ hơn 10%, chiều dài ngắn hơn 15%)
      _drawBranch(
          canvas, size, secondBranchPoint, !needLeftBalance, 0.75, 0.85);

      // 6. Tạo cành thứ ba từ cành thứ hai: phía ngược lại và thấp hơn nữa
      final thirdBranchHeightRatio =
          secondBranchHeightRatio - 0.12; // Thấp hơn cành thứ hai 12%
      if (thirdBranchHeightRatio > 0.05) {
        // Đảm bảo không quá thấp
        final thirdBranchY =
            trunkBottom.dy - (trunkHeight * thirdBranchHeightRatio);

        // Tính toán vị trí X cho cành thứ ba
        final thirdProgress = thirdBranchHeightRatio;
        final thirdCurveFactor =
            math.sin(thirdProgress * math.pi * 2 + seed) * 0.05;
        final thirdBendOffset = size.width * thirdCurveFactor * thirdProgress;
        final thirdNoise =
            (random.nextDouble() - 0.5) * size.width * 0.02 * thirdProgress;
        final thirdCenterX = size.width / 2 + thirdBendOffset + thirdNoise;

        // Tính độ rộng thân cây tại điểm này
        final thirdCurrentWidth = trunkWidthBottom +
            (trunkWidthTop - trunkWidthBottom) * thirdProgress;

        // Đặt cành thứ ba ở phía ngược lại với cành thứ hai (cùng phía với cành đầu tiên)
        final thirdBranchPointX = needLeftBalance
            ? thirdCenterX -
                thirdCurrentWidth *
                    0.25 // Đặt bên trái (cùng phía cành đầu tiên)
            : thirdCenterX +
                thirdCurrentWidth *
                    0.25; // Đặt bên phải (cùng phía cành đầu tiên)

        final thirdBranchPoint = Offset(thirdBranchPointX, thirdBranchY);

        // Vẽ cành thứ ba (nhỏ hơn cành thứ hai: gốc nhỏ hơn 15%, chiều dài ngắn hơn 20%)
        // Cành thứ 3 có góc đặc biệt: hướng lên và lệch với thân 70 độ
        _drawBranch(
            canvas, size, thirdBranchPoint, needLeftBalance, 0.5, 0.6, 70.0);
      }
    }
  }

  void _drawBranch(Canvas canvas, Size size, Offset startPoint, bool isLeftSide,
      [double scale = 1.0, double lengthScale = 1.0, double? customAngle]) {
    final random = math.Random(seed + 1); // Seed khác để tạo biến thể

    // Thiết lập màu cho cành (cùng màu với thân cây)
    const branchColor = Color(0xFF8B4513);

    // Tham số cho cành
    // Tính chiều dài để cành ngang với ngọn thân cây
    final trunkHeightLocal = size.height * 0.70; // Đồng bộ với thân cây dài hơn
    final topOfTrunk =
        size.height * 0.95 - trunkHeightLocal; // Vị trí ngọn thân cây
    final verticalDistance =
        startPoint.dy - topOfTrunk; // Khoảng cách dọc cần bù
    final horizontalDistance = size.width *
        0.25 *
        lengthScale; // Khoảng cách ngang mong muốn (điều chỉnh theo lengthScale)
    final branchLength = math.sqrt(verticalDistance * verticalDistance +
            horizontalDistance * horizontalDistance) *
        lengthScale; // Tính theo định lý Pythagoras và điều chỉnh theo lengthScale
    const segments = 3; // Số đoạn để tạo đường cong (giảm từ 4)

    // Hướng ban đầu: hướng lên và nghiêng ngược lại với thân cây để cân bằng
    // isLeftSide = true nghĩa là cần cân bằng trái (thân cây nghiêng phải)
    // isLeftSide = false nghĩa là cần cân bằng phải (thân cây nghiêng trái)
    final double initialAngle;

    if (customAngle != null) {
      // Sử dụng góc tùy chỉnh (chuyển từ độ sang radian)
      // Góc 70° hướng lên và lệch với thân
      final angleInRadians = customAngle * math.pi / 180;
      initialAngle = isLeftSide
          ? -math.pi / 2 - angleInRadians // Hướng lên và lệch trái
          : -math.pi / 2 + angleInRadians; // Hướng lên và lệch phải
    } else {
      // Sử dụng góc mặc định
      initialAngle = isLeftSide
          ? -3 *
              math.pi /
              4 // Cần cân bằng trái: cành nghiêng nhiều hơn sang trái (-135°)
          : -math.pi /
              4; // Cần cân bằng phải: cành nghiêng nhiều hơn sang phải (-45°)
    }

    final List<Offset> branchPoints = [startPoint];

    // Tạo các điểm cành với độ cong tự nhiên
    for (int i = 1; i <= segments; i++) {
      final progress = i / segments;

      // Tính toán hướng với độ cong tự nhiên
      final currentAngle = initialAngle +
          math.sin(progress * math.pi) * 0.3 + // Độ cong chính
          (random.nextDouble() - 0.5) * 0.2; // Nhiễu ngẫu nhiên nhỏ

      // Tính toán độ dài đoạn hiện tại (ngắn dần về phía ngọn)
      final segmentLength = branchLength / segments * (1.0 - progress * 0.3);

      // Tính điểm tiếp theo
      final prevPoint = branchPoints.last;
      final nextPoint = Offset(
        prevPoint.dx + math.cos(currentAngle) * segmentLength,
        prevPoint.dy + math.sin(currentAngle) * segmentLength,
      );

      branchPoints.add(nextPoint);
    }

    // Vẽ cành với độ dày giảm dần từ gốc lên ngọn
    // Tính chiều rộng thân cây tại điểm gốc cành để làm chiều rộng gốc cành
    final trunkBottomLocal = Offset(size.width / 2, size.height * 0.95);
    final branchProgress =
        (trunkBottomLocal.dy - startPoint.dy) / trunkHeightLocal;
    final trunkWidthBottom = size.width * 0.18;
    final trunkWidthTop = size.width * 0.04; // Giảm từ 0.07 xuống 0.04
    final trunkWidthAtBranch =
        trunkWidthBottom + (trunkWidthTop - trunkWidthBottom) * branchProgress;

    final maxWidth = trunkWidthAtBranch *
        0.8 *
        scale; // Gốc cành = 80% chiều rộng thân tại điểm đó (điều chỉnh theo scale)
    final minWidth = maxWidth * 0.35; // Ngọn cành = 30% chiều rộng gốc cành

    // Tạo các điểm viền trái và phải cho cành
    final List<Offset> leftEdge = [];
    final List<Offset> rightEdge = [];

    for (int i = 0; i < branchPoints.length; i++) {
      final progress = i / (branchPoints.length - 1);
      final currentWidth = maxWidth * (1 - progress) + minWidth * progress;

      // Tính hướng vuông góc với cành tại điểm này
      Offset perpendicular;
      if (i == 0) {
        // Điểm đầu: dùng hướng đến điểm tiếp theo
        final direction = branchPoints[i + 1] - branchPoints[i];
        final length = math
            .sqrt(direction.dx * direction.dx + direction.dy * direction.dy);
        final normalized = Offset(direction.dx / length, direction.dy / length);
        perpendicular = Offset(-normalized.dy, normalized.dx);
      } else if (i == branchPoints.length - 1) {
        // Điểm cuối: dùng hướng từ điểm trước
        final direction = branchPoints[i] - branchPoints[i - 1];
        final length = math
            .sqrt(direction.dx * direction.dx + direction.dy * direction.dy);
        final normalized = Offset(direction.dx / length, direction.dy / length);
        perpendicular = Offset(-normalized.dy, normalized.dx);
      } else {
        // Điểm giữa: dùng hướng trung bình
        final direction = branchPoints[i + 1] - branchPoints[i - 1];
        final length = math
            .sqrt(direction.dx * direction.dx + direction.dy * direction.dy);
        final normalized = Offset(direction.dx / length, direction.dy / length);
        perpendicular = Offset(-normalized.dy, normalized.dx);
      }

      // Tạo điểm viền trái và phải
      leftEdge.add(branchPoints[i] + perpendicular * (currentWidth / 2));
      rightEdge.add(branchPoints[i] - perpendicular * (currentWidth / 2));
    }

    // Tạo path cho toàn bộ cành
    final branchPath = Path();

    // Vẽ viền trái
    branchPath.moveTo(leftEdge.first.dx, leftEdge.first.dy);
    for (int i = 1; i < leftEdge.length; i++) {
      branchPath.lineTo(leftEdge[i].dx, leftEdge[i].dy);
    }

    // Vẽ viền phải (ngược lại)
    for (int i = rightEdge.length - 1; i >= 0; i--) {
      branchPath.lineTo(rightEdge[i].dx, rightEdge[i].dy);
    }

    branchPath.close();

    // Vẽ cành
    final branchPaint = Paint()
      ..color = branchColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(branchPath, branchPaint);
  }

  @override
  bool shouldRepaint(covariant _Tree oldDelegate) {
    return false;
  }
}
