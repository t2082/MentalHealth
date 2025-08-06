import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/meditation/presentation/widgets/meditation/emotion_core.dart';
import 'package:mental_health/features/meditation/presentation/widgets/meditation/frame.dart';
import 'package:mental_health/features/quotes/presentation/pages/quote_histories_screen.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  Widget _buildModernTaskCard(
    String title,
    String description,
    IconData icon,
    Color primaryColor,
    Color accentColor,
    bool isCompleted,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: DfBRadius.defaultRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accentColor.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: DefaultColors.serotonin.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        spacing: 12.w,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextPresets.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  description,
                  style: TextPresets.bodySmall.copyWith(
                    color: Colors.black.withValues(alpha: 0.7),
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30.w,
            height: 30.h,
            child: Stack(children: [
              Center(
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.4),
                      width: 2.w,
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
              Positioned(
                bottom: 6.w,
                left: 6.w,
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        color: accentColor,
                        size: 25.sp,
                      )
                    : const SizedBox.shrink(),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFeatureCard(
    String title,
    String icon,
    Color primaryColor,
    Color accentColor,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 64.w,
          height: 64.h,
          child: Center(
            child: Image.asset(
              icon,
              width: 38.w,
              height: 38.h,
            ),
          ),
        ),
        Text(
          title,
          style: TextPresets.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAppbar() {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 12.w,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  spreadRadius: 0,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Streak Counter
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      colors: [
                        DefaultColors.endorphin.withValues(alpha: 0.8),
                        DefaultColors.endorphinNeon.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: Image.asset('assets/icons/flame.png'),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '100',
                        style: TextPresets.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Coins Counter
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      colors: [
                        DefaultColors.dopamine.withValues(alpha: 0.8),
                        DefaultColors.dopamineNeon.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: Image.asset('assets/icons/coin.png'),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '100K',
                        style: TextPresets.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        DefaultColors.serotonin.withValues(alpha: 0.8),
                        DefaultColors.serotoninNeon.withValues(alpha: 0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DefaultColors.serotonin.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        spreadRadius: 0,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  DefaultColors.oxytocin.withValues(alpha: 0.3),
                  DefaultColors.oxytocinNeon.withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: DefaultColors.oxytocin.withValues(alpha: 0.2),
                  blurRadius: 12.r,
                  spreadRadius: 0,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 20.r,
              backgroundImage: const AssetImage('assets/images/profile.png'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Để nền trong suốt
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 24.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  spacing: 16.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/rose.png',
                          width: 35.w,
                          height: 35.h,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Xin chào \$user,',
                                  style: TextPresets.subTitle),
                              Text('Chúc bạn một ngày mới vui vẻ!',
                                  style: TextPresets.title),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color:
                            DefaultColors.serotoninNeon.withValues(alpha: 0.6),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8.r,
                            spreadRadius: 0,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  DefaultColors.white.withValues(alpha: 0.3),
                                  DefaultColors.serotonin
                                      .withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.black,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hôm nay bạn cảm thấy thế nào?',
                                  style: TextPresets.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Hãy bắt đầu hành trình tâm linh của bạn',
                                  style: TextPresets.bodySmall.copyWith(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Frame(
                  title: 'Lõi cảm xúc',
                  subTitle: 'Xem lịch sử...',
                  onSubTitleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuoteHistoriesScreen(),
                      ),
                    );
                  },
                  child: const EmotionCore(),
                ),
                Frame(
                  title: 'Nhiệm vụ hôm nay (8/16)',
                  subTitle: 'Chi tiết ...',
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      children: [
                        _buildModernTaskCard(
                          'Thực hành biết ơn',
                          'Viết ra 3 điều biết ơn trong ngày hôm nay',
                          Icons.favorite_rounded,
                          DefaultColors.oxytocin,
                          DefaultColors.oxytocinNeon,
                          true,
                        ),
                        SizedBox(height: 12.h),
                        _buildModernTaskCard(
                          'Gọi điện hỏi thăm gia đình',
                          'Đã bao lâu rồi bạn chưa gọi điện cho gia đình?',
                          Icons.family_restroom,
                          DefaultColors.dopamine,
                          DefaultColors.dopamineNeon,
                          false,
                        ),
                        SizedBox(height: 12.h),
                        _buildModernTaskCard(
                          'Vận động nhẹ nhàng',
                          'Yoga hoặc đi bộ 15 phút để thư giãn cơ thể',
                          Icons.directions_walk_rounded,
                          DefaultColors.endorphin,
                          DefaultColors.endorphinNeon,
                          true,
                        ),
                      ],
                    ),
                  ),
                ),
                Frame(
                  title: 'Tiện ích khác',
                  subTitle: '',
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildModernFeatureCard(
                          'Nhật ký',
                          'assets/icons/notebook.png',
                          DefaultColors.dopamine,
                          DefaultColors.dopamineNeon,
                        ),
                        _buildModernFeatureCard(
                          'Uống nước',
                          'assets/icons/water.png',
                          DefaultColors.endorphin,
                          DefaultColors.endorphinNeon,
                        ),
                        _buildModernFeatureCard(
                          'Nhắc nhở',
                          'assets/icons/alert.png',
                          DefaultColors.oxytocin,
                          DefaultColors.oxytocinNeon,
                        ),
                        _buildModernFeatureCard(
                          'Báo thức',
                          'assets/icons/clock.png',
                          DefaultColors.serotonin,
                          DefaultColors.serotoninNeon,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
              ],
            ),
          ),
          Align(alignment: Alignment.topRight, child: _buildAppbar())
        ]),
      ),
    );
  }
}
