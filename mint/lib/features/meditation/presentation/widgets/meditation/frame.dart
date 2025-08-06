import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health/core/theme.dart';

class Frame extends StatelessWidget {
  final Widget child;
  final String title;
  final String subTitle;
  final VoidCallback? onSubTitleTap;

  const Frame({
    super.key,
    required this.child,
    required this.title,
    required this.subTitle,
    this.onSubTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20.h),
          padding: EdgeInsets.only(top: 18.h, bottom: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
            border: Border.all(
              color: DefaultColors.serotonin,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8.r,
                spreadRadius: 0,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: child,
        ),
      ),
      Container(
          height: 28.h,
          margin: EdgeInsets.only(top: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              bottomRight: Radius.circular(8.r),
            ),
            color: Color.alphaBlend(
              DefaultColors.serotonin,
              Colors.white,
            ),
            border: Border(
              top: BorderSide(color: DefaultColors.serotonin, width: 1.w),
              left: BorderSide(color: DefaultColors.serotonin, width: 1.w),
              right: BorderSide(color: DefaultColors.serotonin, width: 1.w),
              bottom: BorderSide(color: DefaultColors.serotonin, width: 1.w),
            ),
            boxShadow: [
              BoxShadow(
                color: DefaultColors.serotonin.withValues(alpha: 0.2),
                blurRadius: 4.r,
                spreadRadius: 0,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Text(
            title,
            style: TextPresets.bodyMedium
                .copyWith(fontWeight: FontWeight.w800, color: Colors.white),
          )),
      Positioned(
        top: 0,
        right: 10.w,
        child: GestureDetector(
          onTap: onSubTitleTap,
          child: Text(
            subTitle,
            style: TextPresets.body.copyWith(
              color: DefaultColors.serotonin,
            ),
          ),
        ),
      )
    ]);
  }
}
