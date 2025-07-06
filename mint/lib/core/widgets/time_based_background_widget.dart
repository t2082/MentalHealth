import 'package:flutter/material.dart';
import 'package:mental_health/core/extension/extensions.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/core/widgets/background.dart';

class TimeBasedBackgroundWidget extends StatefulWidget {
  final Widget child;
  final bool autoUpdate;
  final Duration updateInterval;
  final bool showLoading;
  final Color loadingBackgroundColor;

  const TimeBasedBackgroundWidget({
    super.key,
    required this.child,
    this.autoUpdate = true,
    this.updateInterval = const Duration(minutes: 1),
    this.showLoading = true,
    this.loadingBackgroundColor = Colors.black,
  });

  @override
  State<TimeBasedBackgroundWidget> createState() =>
      _TimeBasedBackgroundWidgetState();
}

class _TimeBasedBackgroundWidgetState extends State<TimeBasedBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Khởi tạo animation controller cho fade transition
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Bắt đầu với opacity = 1
    _fadeController.forward();

    // Thiết lập timer để cập nhật tự động nếu được bật
    if (widget.autoUpdate) {
      _startAutoUpdate();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  /// Bắt đầu cập nhật tự động
  void _startAutoUpdate() {
    Future.delayed(widget.updateInterval, () {
      if (mounted && widget.autoUpdate) {
        _updateBackground();
        _startAutoUpdate();
      }
    });
  }

  /// Cập nhật nền dựa trên thời gian hiện tại
  void _updateBackground() {
    // Chỉ cần setState để cập nhật màu sắc
    setState(() {
      // Màu sắc sẽ được cập nhật tự động trong _getTimeBasedColor()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildTimeBasedBackground(),
        widget.child,
      ],
    );
  }

  /// Xây dựng nền Container với màu sắc dựa trên thời gian
  Widget _buildTimeBasedBackground() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          // child: Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   child: Image.asset(
          //     DateTime.now().isMorning
          //         ? 'assets/images/bg_morning.png'
          //         : 'assets/images/bg_night.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child:Background()
        );
      },
    );
  }
}

extension TimeBasedBackgroundExtension on Widget {
  /// Wrap widget này với TimeBasedBackgroundWidget
  Widget withTimeBasedBackground({
    bool autoUpdate = true,
    Duration updateInterval = const Duration(minutes: 1),
    bool showLoading = true,
    Color loadingBackgroundColor = Colors.black,
  }) {
    return TimeBasedBackgroundWidget(
      autoUpdate: autoUpdate,
      updateInterval: updateInterval,
      showLoading: showLoading,
      loadingBackgroundColor: loadingBackgroundColor,
      child: this,
    );
  }
}
