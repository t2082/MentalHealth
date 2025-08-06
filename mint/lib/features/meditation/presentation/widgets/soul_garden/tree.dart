import 'package:flutter/material.dart';
import 'dart:math' as math;

class TreeWidget extends StatelessWidget {
  final double growth;

  final double size;
  final int seed;

  const TreeWidget(
      {required this.growth, required this.size, required this.seed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _Tree(
            size: size,
            seed: seed,
          ),
        ));
  }
}

class _Tree extends CustomPainter {
  final double size;
  final int seed;

  _Tree({required this.size, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    _drawCurvedTrunk(canvas, size, paint);
    _drawBranchPoints(canvas, size);
    _drawClouds(canvas, size);

    // Vẽ đám mây thứ 5 tại điểm trung điểm của 4 đám mây
    _drawCenterCloud(canvas, size);
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

    // Tạo path cho thân cây cong với gốc bo tròn
    final path = Path();

    // Tính toán điểm gốc bo tròn
    final leftBottom = leftPoints.first;
    final rightBottom = rightPoints.first;
    final centerBottom =
        Offset((leftBottom.dx + rightBottom.dx) / 2, leftBottom.dy);
    final bottomRadius = (rightBottom.dx - leftBottom.dx) / 2;

    // Bắt đầu từ điểm bên trái, nhưng hơi cao hơn để tạo chỗ cho đường cong
    final leftStartY = leftBottom.dy - bottomRadius * 0.3;
    path.moveTo(leftBottom.dx, leftStartY);

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

    // Vẽ đường cong xuống điểm bên phải tương ứng với bên trái
    final rightStartY = rightBottom.dy - bottomRadius * 0.3;
    path.lineTo(rightBottom.dx, rightStartY);

    // Tạo đường cong bo tròn ở gốc thân cây
    // Sử dụng arcTo để tạo cung tròn từ phải sang trái
    final bottomRect = Rect.fromCenter(
      center: centerBottom,
      width: bottomRadius * 2,
      height: bottomRadius * 0.6, // Làm phẳng một chút để trông tự nhiên hơn
    );

    // Vẽ cung tròn từ bên phải sang bên trái (180 độ)
    path.arcTo(bottomRect, 0, math.pi, false);

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

    // Danh sách lưu vị trí ngọn các cành để vẽ đám mây
    final List<Offset> branchTips = [];

    // Vẽ cành đầu tiên từ điểm gốc
    final firstBranchTip =
        _drawBranch(canvas, size, branchPoint, needLeftBalance, 1.0, 1.0);
    if (firstBranchTip != null) branchTips.add(firstBranchTip);

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
      final secondBranchTip = _drawBranch(
          canvas, size, secondBranchPoint, !needLeftBalance, 0.75, 0.85);
      if (secondBranchTip != null) branchTips.add(secondBranchTip);

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
        final thirdBranchTip = _drawBranch(
            canvas, size, thirdBranchPoint, needLeftBalance, 0.5, 0.6, 70.0);
        if (thirdBranchTip != null) branchTips.add(thirdBranchTip);
      }
    }

    // Vẽ đám mây ngẫu nhiên trên các ngọn cành
    _drawBranchClouds(canvas, size, branchTips);
  }

  Offset? _drawBranch(
      Canvas canvas, Size size, Offset startPoint, bool isLeftSide,
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

    // Trả về vị trí ngọn cành (điểm cuối cùng)
    return branchPoints.last;
  }

  void _drawClouds(Canvas canvas, Size size) {
    final random =
        math.Random(seed + 2); // Seed khác để tạo biến thể cho đám mây
    final trunkHeight = size.height * 0.70;
    final trunkBottom = Offset(size.width / 2, size.height * 0.95);

    // Tìm vị trí ngọn của thân cây
    const topProgress = 1.0; // Ngọn cây (100%)
    final topCurveFactor = math.sin(topProgress * math.pi * 2 + seed) * 0.05;
    final topBendOffset = size.width * topCurveFactor * topProgress;
    final topNoise =
        (random.nextDouble() - 0.5) * size.width * 0.02 * topProgress;
    final topCenterX = size.width / 2 + topBendOffset + topNoise;
    final topY = trunkBottom.dy - trunkHeight;

    // Vị trí trung tâm của đám mây (dính vào ngọn cây)
    final cloudCenterX = topCenterX;
    final cloudCenterY =
        topY - size.height * 0.05; // Đám mây dính gần ngọn cây hơn

    // Kích thước đám mây (chiều ngang lớn hơn chiều dọc)
    final cloudWidth = size.width * 0.7; // Chiều ngang tăng từ 0.6 lên 0.7
    final cloudHeight = size.height * 0.35; // Chiều dọc tăng từ 0.3 lên 0.35

    // Tạo gradient cho đám mây màu hoa anh đào
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.pink.shade50.withValues(alpha: 0.9), // Phần trên hồng rất nhạt
        Colors.pink.shade200.withValues(alpha: 0.7), // Phần dưới hồng đậm hơn
      ],
    );

    // Vẽ đám mây gốc
    _drawCloudShape(canvas, cloudCenterX, cloudCenterY, cloudWidth, cloudHeight,
        gradient, random);

    // Nhân bản thêm 2 đám mây nữa cùng lệch xuống dưới 20% so với đám mây chính
    // Vị trí chung cho cả 2 đám mây nhân bản - lệch xuống 20% chiều cao đám mây
    final cloudCenterYClones = cloudCenterY + cloudHeight * 0.2;

    // Đám mây thứ 2 - lệch xuống 20% và lệch trái 10% so với đám mây chính
    final cloudCenterX2 = cloudCenterX - cloudWidth * 0.1; // Lệch trái 10%
    final gradient2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.pink.shade100.withValues(alpha: 0.8), // Hồng nhạt hơn
        Colors.pink.shade300.withValues(alpha: 0.6), // Hồng đậm hơn
      ],
    );
    _drawCloudShape(canvas, cloudCenterX2, cloudCenterYClones, cloudWidth,
        cloudHeight, gradient2, math.Random(seed + 3));

    // Đám mây thứ 3 - lệch xuống 20% và lệch phải 10% so với đám mây chính
    final cloudCenterX3 = cloudCenterX + cloudWidth * 0.1; // Lệch phải 10%
    final gradient3 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.pink.shade200.withValues(alpha: 0.7), // Hồng trung bình
        Colors.pink.shade400.withValues(alpha: 0.5), // Hồng đậm nhất
      ],
    );
    _drawCloudShape(canvas, cloudCenterX3, cloudCenterYClones, cloudWidth,
        cloudHeight, gradient3, math.Random(seed + 4));
  }

  void _drawBranchClouds(Canvas canvas, Size size, List<Offset> branchTips) {
    for (int i = 0; i < branchTips.length; i++) {
      final branchTip = branchTips[i];

      // Đảm bảo tất cả các cành đều có mây - loại bỏ logic ngẫu nhiên
      final cloudRandom = math.Random(seed + 10 + i);

      // Kích thước đám mây nhỏ hơn cho cành (tỷ lệ với kích thước cành)
      final branchCloudWidth = size.width *
          (0.45 + cloudRandom.nextDouble() * 0.25); // 45-70% (tăng từ 40-65%)
      final branchCloudHeight = size.height *
          (0.25 + cloudRandom.nextDouble() * 0.15); // 25-40% (tăng từ 20-35%)

      // Vị trí đám mây (hơi lệch khỏi ngọn cành)
      final offsetX = (cloudRandom.nextDouble() - 0.5) *
          size.width *
          0.05; // Lệch ngang ±5%
      final offsetY = -size.height *
          (0.03 + cloudRandom.nextDouble() * 0.02); // Lệch lên 3-5%

      final cloudCenterX = branchTip.dx + offsetX;
      final cloudCenterY = branchTip.dy + offsetY;

      // Tạo gradient cho đám mây cành màu hoa anh đào
      final branchGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade100.withValues(alpha: 0.8), // Hồng nhạt
          Colors.pink.shade300.withValues(alpha: 0.6), // Hồng đậm hơn
        ],
      );

      // Vẽ đám mây cành gốc
      _drawCloudShape(canvas, cloudCenterX, cloudCenterY, branchCloudWidth,
          branchCloudHeight, branchGradient, cloudRandom);

      // Nhân bản thêm 2 đám mây cành nữa cùng lệch xuống dưới 20% so với đám mây chính
      // Vị trí chung cho cả 2 đám mây cành nhân bản - lệch xuống 20% chiều cao đám mây
      final branchCloudCenterYClones = cloudCenterY + branchCloudHeight * 0.2;

      // Đám mây cành thứ 2 - lệch xuống 20% và lệch trái 10% so với đám mây cành chính
      final branchCloudCenterX2 =
          cloudCenterX - branchCloudWidth * 0.1; // Lệch trái 10%
      final branchGradient2 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade200.withValues(alpha: 0.7), // Hồng nhạt hơn
          Colors.pink.shade400.withValues(alpha: 0.5), // Hồng đậm hơn
        ],
      );
      _drawCloudShape(
          canvas,
          branchCloudCenterX2,
          branchCloudCenterYClones,
          branchCloudWidth,
          branchCloudHeight,
          branchGradient2,
          math.Random(seed + 20 + i));

      // Đám mây cành thứ 3 - lệch xuống 20% và lệch phải 10% so với đám mây cành chính
      final branchCloudCenterX3 =
          cloudCenterX + branchCloudWidth * 0.1; // Lệch phải 10%
      final branchGradient3 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade300.withValues(alpha: 0.6), // Hồng trung bình
          Colors.pink.shade500.withValues(alpha: 0.4), // Hồng đậm nhất
        ],
      );
      _drawCloudShape(
          canvas,
          branchCloudCenterX3,
          branchCloudCenterYClones,
          branchCloudWidth,
          branchCloudHeight,
          branchGradient3,
          math.Random(seed + 30 + i));
    }
  }

  void _drawCloudShape(
      Canvas canvas,
      double centerX,
      double centerY,
      double width,
      double height,
      LinearGradient gradient,
      math.Random random) {
    // Tạo đám mây bằng cách vẽ nhiều hình ellipse chồng lên nhau
    final cloudPath = Path();

    // Số lượng "bong bóng" tạo nên đám mây
    const int bubbleCount = 8;

    for (int i = 0; i < bubbleCount; i++) {
      // Tạo vị trí ngẫu nhiên cho mỗi bong bóng trong phạm vi đám mây
      final angle = (i / bubbleCount) * 2 * math.pi;
      final radiusVariation = 0.3 + random.nextDouble() * 0.4; // 0.3 - 0.7

      // Vị trí bong bóng (phân bố theo hình ellipse)
      final bubbleX = centerX + math.cos(angle) * width * 0.3 * radiusVariation;
      final bubbleY =
          centerY + math.sin(angle) * height * 0.3 * radiusVariation;

      // Kích thước bong bóng
      final bubbleWidth = width *
          (0.15 + random.nextDouble() * 0.15); // 15-30% chiều rộng đám mây
      final bubbleHeight = height *
          (0.2 + random.nextDouble() * 0.2); // 20-40% chiều cao đám mây

      // Tạo ellipse cho bong bóng
      final bubbleRect = Rect.fromCenter(
        center: Offset(bubbleX, bubbleY),
        width: bubbleWidth,
        height: bubbleHeight,
      );

      final bubblePath = Path()..addOval(bubbleRect);
      cloudPath.addPath(bubblePath, Offset.zero);
    }

    // Thêm bong bóng trung tâm lớn hơn
    final centerBubbleRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: width * 0.4,
      height: height * 0.5,
    );
    final centerBubblePath = Path()..addOval(centerBubbleRect);
    cloudPath.addPath(centerBubblePath, Offset.zero);

    // Tạo Paint với gradient
    final cloudRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: width,
      height: height,
    );

    final paint = Paint()
      ..shader = gradient.createShader(cloudRect)
      ..style = PaintingStyle.fill;

    // Vẽ đám mây
    canvas.drawPath(cloudPath, paint);
  }

  void _drawCenterCloud(Canvas canvas, Size size) {
    final random = math.Random(seed + 100); // Seed riêng cho đám mây trung tâm

    // Tính toán vị trí các đám mây hiện có
    final List<Offset> cloudPositions = [];

    // 1. Vị trí đám mây chính (ngọn cây)
    final trunkHeight = size.height * 0.70;
    final trunkBottom = Offset(size.width / 2, size.height * 0.95);
    const topProgress = 1.0;
    final topCurveFactor = math.sin(topProgress * math.pi * 2 + seed) * 0.05;
    final topBendOffset = size.width * topCurveFactor * topProgress;
    final topNoise =
        (random.nextDouble() - 0.5) * size.width * 0.02 * topProgress;
    final topCenterX = size.width / 2 + topBendOffset + topNoise;
    final topY = trunkBottom.dy - trunkHeight;
    final mainCloudCenter = Offset(topCenterX, topY - size.height * 0.05);
    cloudPositions.add(mainCloudCenter);

    // 2. Tính toán vị trí 3 đám mây cành (tương tự logic trong _drawBranchPoints)
    // Tìm hướng nghiêng của ngọn cây
    const topProgressLocal = 0.95;
    final topCurveFactorLocal =
        math.sin(topProgressLocal * math.pi * 2 + seed) * 0.05;
    final topBendOffsetLocal =
        size.width * topCurveFactorLocal * topProgressLocal;
    final needLeftBalance = topBendOffsetLocal > 0;

    // Tìm vị trí cành đầu tiên
    double bestProgress = 0.4;
    bool found = false;
    for (double testProgress = 0.65;
        testProgress >= 0.2;
        testProgress -= 0.05) {
      final testCurveFactor =
          math.sin(testProgress * math.pi * 2 + seed) * 0.05;
      final testBendOffset = size.width * testCurveFactor * testProgress;
      final isCorrectDirection =
          needLeftBalance ? testBendOffset < -0.01 : testBendOffset > 0.01;
      if (isCorrectDirection && !found) {
        bestProgress = testProgress;
        found = true;
        break;
      }
    }

    // Tính vị trí đám mây cành 1
    final branchHeightRatio = bestProgress;
    final branchY = trunkBottom.dy - (trunkHeight * branchHeightRatio);
    final progress = branchHeightRatio;
    final curveFactor = math.sin(progress * math.pi * 2 + seed) * 0.05;
    final bendOffset = size.width * curveFactor * progress;
    final noise = (random.nextDouble() - 0.5) * size.width * 0.02 * progress;
    final centerX = size.width / 2 + bendOffset + noise;
    final trunkWidthBottom = size.width * 0.18;
    final trunkWidthTop = size.width * 0.04;
    final currentWidth =
        trunkWidthBottom + (trunkWidthTop - trunkWidthBottom) * progress;
    final branchPointX = needLeftBalance
        ? centerX - currentWidth * 0.25
        : centerX + currentWidth * 0.25;

    // Tính vị trí đám mây từ ngọn cành 1 (giả sử cành dài khoảng 25% chiều rộng)
    final branch1CloudX =
        branchPointX + (needLeftBalance ? -size.width * 0.2 : size.width * 0.2);
    final branch1CloudY = branchY - size.height * 0.04;
    cloudPositions.add(Offset(branch1CloudX, branch1CloudY));

    // Tính vị trí đám mây cành 2
    final secondBranchHeightRatio = bestProgress - 0.15;
    if (secondBranchHeightRatio > 0.1) {
      final secondBranchY =
          trunkBottom.dy - (trunkHeight * secondBranchHeightRatio);
      final secondProgress = secondBranchHeightRatio;
      final secondCurveFactor =
          math.sin(secondProgress * math.pi * 2 + seed) * 0.05;
      final secondBendOffset = size.width * secondCurveFactor * secondProgress;
      final secondNoise =
          (random.nextDouble() - 0.5) * size.width * 0.02 * secondProgress;
      final secondCenterX = size.width / 2 + secondBendOffset + secondNoise;
      final secondCurrentWidth = trunkWidthBottom +
          (trunkWidthTop - trunkWidthBottom) * secondProgress;
      final secondBranchPointX = needLeftBalance
          ? secondCenterX + secondCurrentWidth * 0.25
          : secondCenterX - secondCurrentWidth * 0.25;

      final branch2CloudX = secondBranchPointX +
          (needLeftBalance ? size.width * 0.15 : -size.width * 0.15);
      final branch2CloudY = secondBranchY - size.height * 0.04;
      cloudPositions.add(Offset(branch2CloudX, branch2CloudY));

      // Tính vị trí đám mây cành 3
      final thirdBranchHeightRatio = secondBranchHeightRatio - 0.12;
      if (thirdBranchHeightRatio > 0.05) {
        final thirdBranchY =
            trunkBottom.dy - (trunkHeight * thirdBranchHeightRatio);
        final thirdProgress = thirdBranchHeightRatio;
        final thirdCurveFactor =
            math.sin(thirdProgress * math.pi * 2 + seed) * 0.05;
        final thirdBendOffset = size.width * thirdCurveFactor * thirdProgress;
        final thirdNoise =
            (random.nextDouble() - 0.5) * size.width * 0.02 * thirdProgress;
        final thirdCenterX = size.width / 2 + thirdBendOffset + thirdNoise;
        final thirdCurrentWidth = trunkWidthBottom +
            (trunkWidthTop - trunkWidthBottom) * thirdProgress;
        final thirdBranchPointX = needLeftBalance
            ? thirdCenterX - thirdCurrentWidth * 0.25
            : thirdCenterX + thirdCurrentWidth * 0.25;

        final branch3CloudX = thirdBranchPointX +
            (needLeftBalance ? -size.width * 0.12 : size.width * 0.12);
        final branch3CloudY = thirdBranchY - size.height * 0.04;
        cloudPositions.add(Offset(branch3CloudX, branch3CloudY));
      }
    }

    // Tính điểm trung điểm của tất cả các đám mây
    if (cloudPositions.length >= 3) {
      // Đảm bảo có ít nhất 3 đám mây
      double totalX = 0;
      double totalY = 0;
      for (final pos in cloudPositions) {
        totalX += pos.dx;
        totalY += pos.dy;
      }
      final centerCloudX = totalX / cloudPositions.length;
      final centerCloudY = totalY / cloudPositions.length;

      // Kích thước đám mây trung tâm (bằng với đám mây cành)
      final centerCloudWidth = size.width *
          (0.45 + random.nextDouble() * 0.25); // 45-70% (tăng từ 40-65%)
      final centerCloudHeight = size.height *
          (0.25 + random.nextDouble() * 0.15); // 25-40% (tăng từ 20-35%)

      // Tạo gradient cho đám mây trung tâm màu hoa anh đào (giống đám mây cành)
      final centerGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade100.withValues(alpha: 0.8), // Hồng nhạt
          Colors.pink.shade300.withValues(alpha: 0.6), // Hồng đậm hơn
        ],
      );

      // Vẽ đám mây trung tâm gốc
      _drawCloudShape(canvas, centerCloudX, centerCloudY, centerCloudWidth,
          centerCloudHeight, centerGradient, random);

      // Nhân bản thêm 2 đám mây trung tâm nữa cùng lệch xuống dưới 20% so với đám mây chính
      // Vị trí chung cho cả 2 đám mây trung tâm nhân bản - lệch xuống 20% chiều cao đám mây
      final centerCloudYClones = centerCloudY + centerCloudHeight * 0.2;

      // Đám mây trung tâm thứ 2 - lệch xuống 20% và lệch trái 10% so với đám mây trung tâm chính
      final centerCloudX2 =
          centerCloudX - centerCloudWidth * 0.1; // Lệch trái 10%
      final centerGradient2 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade200.withValues(alpha: 0.7), // Hồng nhạt hơn
          Colors.pink.shade400.withValues(alpha: 0.5), // Hồng đậm hơn
        ],
      );
      _drawCloudShape(
          canvas,
          centerCloudX2,
          centerCloudYClones,
          centerCloudWidth,
          centerCloudHeight,
          centerGradient2,
          math.Random(seed + 200));

      // Đám mây trung tâm thứ 3 - lệch xuống 20% và lệch phải 10% so với đám mây trung tâm chính
      final centerCloudX3 =
          centerCloudX + centerCloudWidth * 0.1; // Lệch phải 10%
      final centerGradient3 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade300.withValues(alpha: 0.6), // Hồng trung bình
          Colors.pink.shade500.withValues(alpha: 0.4), // Hồng đậm nhất
        ],
      );
      _drawCloudShape(
          canvas,
          centerCloudX3,
          centerCloudYClones,
          centerCloudWidth,
          centerCloudHeight,
          centerGradient3,
          math.Random(seed + 300));

      // Thêm cặp đám mây nhân bản lệch lên trên 30% so với đám mây trung tâm chính
      // Vị trí chung cho cặp đám mây lệch lên trên - lệch lên 30% chiều cao đám mây
      final centerCloudYClonesUp = centerCloudY - centerCloudHeight * 0.3;

      // Đám mây trung tâm thứ 4 - lệch lên 30% và lệch trái để tạo khoảng cách rõ ràng với đám mây thứ 5
      final centerCloudX4 = centerCloudX -
          centerCloudWidth * 0.2; // Lệch trái 7.5% (tổng khoảng cách 15%)
      final centerGradient4 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade100.withValues(alpha: 1), // Tăng opacity lên 0.9
          Colors.pink.shade200.withValues(alpha: 0.9), // Tăng opacity lên 0.8
        ],
      );
      _drawCloudShape(
          canvas,
          centerCloudX4,
          centerCloudYClonesUp,
          centerCloudWidth * 1.3, // Tăng kích thước lên 130%
          centerCloudHeight * 1.3, // Tăng kích thước lên 130%
          centerGradient4,
          math.Random(seed + 400));

      // Đám mây trung tâm thứ 5 - lệch lên 30% và lệch phải để tạo khoảng cách rõ ràng với đám mây thứ 4
      final centerCloudX5 = centerCloudX +
          centerCloudWidth * 0.25; // Lệch phải 7.5% (tổng khoảng cách 15%)
      final centerGradient5 = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.pink.shade100.withValues(alpha: 0.9), // Hồng rất nhạt
          Colors.pink.shade300.withValues(alpha: 0.7), // Hồng nhạt
        ],
      );
      _drawCloudShape(
          canvas,
          centerCloudX5,
          centerCloudYClonesUp,
          centerCloudWidth * 1.3, // Tăng kích thước lên 130%
          centerCloudHeight * 1.3, // Tăng kích thước lên 130%
          centerGradient5,
          math.Random(seed + 500));
    }
  }

  @override
  bool shouldRepaint(covariant _Tree oldDelegate) {
    return false;
  }
}
