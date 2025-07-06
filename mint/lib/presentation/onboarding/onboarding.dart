import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mental_health/core/extension/datetime_extension.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/presentation/homePage/home_page.dart';
import 'package:mental_health/core/services/quote_service.dart';
import 'package:mental_health/injection_container.dart' as di;

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  /// Trả về khoảng thời gian của buổi hiện tại
  final now = DateTime.now();
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  // Animation controller cho fade out khi chuyển trang
  AnimationController? _fadeOutController;
  Animation<double>? _fadeOutAnimation;
  bool _isNavigating = false;

  // Animation controller cho glow effect của quote
  AnimationController? _glowController;
  Animation<double>? _glowAnimation;

  // Loading states
  bool _isLoading = true;
  bool _showContinueButton = false;

  // Quote state
  String _currentQuote =
      'Mỗi phút bạn dành cho chính mình hôm nay là một hạt giống hạnh phúc cho ngày mai.';
  QuoteService? _quoteService;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    // Animation cho fade out khi chuyển trang
    _fadeOutController = AnimationController(
      duration:
          const Duration(milliseconds: 1500), // Thời gian fade out nhẹ nhàng
      vsync: this,
    );
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeOutController!,
      curve: Curves.easeInOutQuart, // Curve nhẹ nhàng
    ));

    // Animation cho glow effect của quote - phát sáng và nhạt dần
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController!,
      curve: Curves.easeInOutSine,
    ));

    _startLoadingProcess();
  }

  void _startLoadingProcess() async {
    try {
      // Initialize QuoteService
      _quoteService = await di.sl.getAsync<QuoteService>();

      // Initialize quote service (this will set default quote for first launch
      // and fetch new quote in background)
      await _quoteService!.initialize();

      // Get current quote to display
      final quote = await _quoteService!.getDisplayQuote();

      if (mounted) {
        setState(() {
          _currentQuote = quote;
        });
      }
    } catch (e) {
      print('Error initializing quote service: $e');
      // Keep default quote if error occurs
    }

    // Wait for minimum loading time
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _showContinueButton = true;
      });
      _animationController!.repeat(reverse: true);

      // Bắt đầu glow animation cho quote - lặp lại hiệu ứng phát sáng
      _startGlowEffect();
    }
  }

  // Method để bắt đầu hiệu ứng glow lặp lại
  void _startGlowEffect() {
    _glowController!.forward().then((_) {
      // Sau khi phát sáng xong, đợi 2 giây rồi lặp lại
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _glowController!.reset();
          _startGlowEffect();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _fadeOutController?.dispose();
    _glowController?.dispose();
    super.dispose();
  }

  // Method để xử lý navigation với fade out animation
  void _navigateToHome() {
    if (_isNavigating) return; // Tránh multiple taps

    setState(() {
      _isNavigating = true;
    });

    // Dừng animation text
    _animationController?.stop();

    // Bắt đầu fade out animation
    _fadeOutController?.forward().then((_) {
      // Sau khi fade out hoàn thành, navigate đến home
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeOutAnimation!,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeOutAnimation!.value,
            child: _buildBody(context),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          color: DefaultColors.primary,
          child: Lottie.asset(
            now.isMorning
                ? 'assets/lotties/welcomebg_morning.json'
                : 'assets/lotties/welcomebg_night.json',
            fit: BoxFit.cover,
            repeat: true,
            animate: true,
            frameBuilder: (context, child, composition) {
              if (composition == null) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: DefaultColors.primary,
                );
              }
              return child;
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: DefaultColors.primary,
                child: const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: DefaultColors.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Câu nói hôm nay:\n ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _glowAnimation!,
                    builder: (context, child) {
                      // Tính toán cường độ glow: 0 = bình thường, 1 = sáng nhất
                      double glowValue = _glowAnimation!.value;

                      // Tạo curve để glow tăng nhanh và giảm chậm (như đèn flash)
                      double glowIntensity = glowValue < 0.3
                          ? glowValue * 3.33 // Tăng nhanh trong 30% đầu
                          : 1.0 -
                              ((glowValue - 0.3) /
                                  0.7); // Giảm chậm trong 70% còn lại

                      return Text(
                        _currentQuote,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: glowIntensity > 0.1
                              ? [
                                  // Glow chính - chỉ xuất hiện khi có hiệu ứng
                                  Shadow(
                                    color: Colors.white
                                        .withValues(alpha: 0.8 * glowIntensity),
                                    blurRadius: 12 * glowIntensity,
                                    offset: const Offset(0, 0),
                                  ),
                                  // Glow rộng hơn
                                  Shadow(
                                    color: Colors.white
                                        .withValues(alpha: 0.6 * glowIntensity),
                                    blurRadius: 20 * glowIntensity,
                                    offset: const Offset(0, 0),
                                  ),
                                  // Glow xa nhất
                                  Shadow(
                                    color: Colors.white
                                        .withValues(alpha: 0.3 * glowIntensity),
                                    blurRadius: 30 * glowIntensity,
                                    offset: const Offset(0, 0),
                                  ),
                                ]
                              : null, // Không có shadow khi ở trạng thái bình thường
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: DefaultColors.primary,
            child: Stack(
              children: [
                // Background music animation
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/lotties/musicbg.json',
                    fit: BoxFit.cover,
                    repeat: true,
                    animate: true,
                  ),
                ),
                // Content on top
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 48,
                      ),
                      child: Center(
                        child: _isLoading
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Lottie.asset(
                                      'assets/lotties/loading.json',
                                      width: 48,
                                      height: 48,
                                      repeat: true,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Đang tải tài nguyên...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white.withAlpha(80),
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : _showContinueButton
                                ? GestureDetector(
                                    onTap: _navigateToHome,
                                    child: _isNavigating
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Lottie.asset(
                                              'assets/lotties/loading.json',
                                              width: 48,
                                              height: 48,
                                              repeat: true,
                                            ))
                                        : AnimatedBuilder(
                                            animation: _fadeAnimation!,
                                            builder: (context, child) {
                                              return Opacity(
                                                opacity: _fadeAnimation!.value,
                                                child: Text(
                                                  'Chạm vào đây để tiếp tục',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            },
                                          ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
