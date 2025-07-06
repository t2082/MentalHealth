import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mental_health/features/quotes/domain/usecases/get_quote_by_feeling.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_bloc.dart';
import 'package:mental_health/features/quotes/presentation/widgets/quote_dialog.dart';
import 'package:mental_health/injection_container.dart' as di;

class FeelingButton extends StatefulWidget {
  final String feeling;
  final double process;
  final Color color;
  final Color colorLight;
  final String icon;
  final VoidCallback? onTap;
  const FeelingButton({
    super.key,
    required this.feeling,
    required this.process,
    required this.colorLight,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  State<FeelingButton> createState() => _FeelingButtonState();
}

class _FeelingButtonState extends State<FeelingButton>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: widget.process,
      end: 1.0,
    ).animate(_progressController);
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showQuoteDialog();
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startProgress() {
    _progressController.reset();
    _progressController.forward();
  }

  void _stopProgress() {
    _progressController.stop();
  }

  void _resetProgress() {
    _progressController.reset();
  }

  void _showQuoteDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => BlocProvider(
        create: (context) => QuoteBloc(
          getQuoteByFeeling: di.sl<GetQuoteByFeeling>(),
        ),
        child: QuoteDialog(
          feeling: widget.feeling,
          primaryColor: widget.color,
          accentColor: widget.colorLight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _pressController.forward();
        widget.process == 1 ? _showQuoteDialog() : _startProgress();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _pressController.reverse();
        _stopProgress();
        _resetProgress();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _pressController.reverse();
        _stopProgress();
        _resetProgress();
      },
      child: Column(
        children: [
          SizedBox(
            width: 70.w,
            height: 70.h,
            child: Stack(children: [
              // Outer glow effect that appears when pressed
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isPressed
                      ? [
                          BoxShadow(
                            color: widget.colorLight.withValues(alpha: 0.7),
                            blurRadius: 15.r,
                            spreadRadius: 5.r,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.2),
                            blurRadius: 8.r,
                            spreadRadius: 0,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                ),
              ),
              // Base gradient background
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _isPressed
                          ? widget.colorLight.withValues(alpha: 0.6)
                          : widget.color.withValues(alpha: 0.3),
                      _isPressed
                          ? widget.colorLight.withValues(alpha: 0.4)
                          : widget.color.withValues(alpha: 0.2),
                      _isPressed
                          ? widget.colorLight.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.1),
                    ],
                    stops: const [0.4, 0.6, 1.0],
                  ),
                ),
              ),
              SizedBox.expand(
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) => CircularProgressIndicator(
                    value: _progressAnimation.value,
                    color: widget.colorLight.withValues(alpha: 0.7),
                    backgroundColor: widget.color.withValues(alpha: 0.2),
                    strokeWidth: 3.0,
                  ),
                ),
              ),
              SizedBox.expand(
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.colorLight,
                    BlendMode.srcIn,
                  ),
                  child: Lottie.asset(
                    'assets/lotties/orb.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  widget.icon,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.6),
                    BlendMode.srcIn,
                  ),
                  width: 20.w,
                  height: 20.h,
                ),
              ),
            ]),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.feeling,
            style: TextStyle(
              color: widget.colorLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.white.withValues(alpha: 0.6),
                  blurRadius: 10.r,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
