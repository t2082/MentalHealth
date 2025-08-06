import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health/core/extension/datetime_extension.dart';
import 'package:mental_health/core/theme.dart';
import 'dart:ui';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_event.dart';

class BottomNavBar extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;

  const BottomNavBar(
      {super.key, required this.items, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _scaleController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation cho glow effect
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Animation cho scale effect khi tap
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  /// Lấy gradient colors dựa trên thời gian hiện tại
  List<Color> _getTimeBasedGradient() {
    final now = DateTime.now();

    if (now.isMorning) {
      return [
        DefaultColors.serotoninNeon.withValues(alpha: 0.5),
        DefaultColors.serotoninNeon.withValues(alpha: 0.5),
        DefaultColors.serotoninNeon.withValues(alpha: 0.6),
      ];
    } else {
      return [
        const Color(0xFF0F0F23).withValues(alpha: 0.98), // Very dark blue
        const Color(0xFF191970).withValues(alpha: 0.95), // Midnight blue
        const Color(0xFF483D8B).withValues(alpha: 0.90), // Dark slate blue
      ];
    }
  }

  /// Lấy màu accent dựa trên thời gian
  Color _getTimeBasedAccentColor() {
    final now = DateTime.now();

    if (now.isMorning) {
      return const Color.fromARGB(255, 235, 245, 240); // Gold
    } else {
      return const Color.fromARGB(255, 60, 255, 252); // Cyan
    }
  }

  /// Lấy màu glow dựa trên thời gian
  Color _getTimeBasedGlowColor() {
    final now = DateTime.now();
    if (now.isMorning) {
      return const Color.fromARGB(255, 235, 245, 240)
          .withValues(alpha: 0.6); // Gold glow
    } else {
      return const Color(0xFF00BFFF)
          .withValues(alpha: 0.6); // Deep sky blue glow
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      margin:  EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getTimeBasedGlowColor(),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getTimeBasedGradient(),
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: _getTimeBasedAccentColor().withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.items.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = index == widget.currentIndex;
    final item = widget.items[index];

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      onTap: () {
        context.read<NavigationBloc>().add(NavigationTo(index: index));
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _getTimeBasedGlowColor(),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: _buildIcon(item, isSelected),
                      ),
                      if (isSelected && item.label != null) ...[
                        Text(
                          item.label!,
                          style: TextStyle(
                            color: _getTimeBasedAccentColor(),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build icon widget với color và size phù hợp
  Widget _buildIcon(BottomNavigationBarItem item, bool isSelected) {
    // return Container(
    //   width: 15,
    //   height: 15,
    //   color:Colors.amber
    // );

    final iconWidget = item.icon;

    if (iconWidget is Image) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          isSelected
              ? _getTimeBasedAccentColor()
              : Colors.white.withValues(alpha: 0.7),
          BlendMode.srcIn,
        ),
        child: SizedBox(
          width: isSelected ? 28.w : 24.w,
          height: isSelected ? 28.w : 24.w,
          child: iconWidget,
        ),
      );
    }

    if (iconWidget is Icon) {
      return Icon(
        iconWidget.icon,
        color: isSelected
            ? _getTimeBasedAccentColor()
            : Colors.white.withValues(alpha: 0.7),
        size: isSelected ? 28.w : 24.w,
      );
    }

    // Fallback: trả về widget gốc
    return SizedBox(
      width: isSelected ? 28.w : 24.w,
      height: isSelected ? 28.w : 24.w,
      child: iconWidget,
    );
  }
}
