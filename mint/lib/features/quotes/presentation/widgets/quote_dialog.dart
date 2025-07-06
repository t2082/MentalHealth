import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/quotes/domain/entities/quote.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_bloc.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_event.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_state.dart';

class QuoteDialog extends StatefulWidget {
  final String feeling;
  final Color primaryColor;
  final Color accentColor;

  const QuoteDialog({
    super.key,
    required this.feeling,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    bool isErr = false;
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: 400.h, // Tối đa 500.h
                minHeight: 150.h, // Tối thiểu 150.h
              ),
              margin: EdgeInsets.all(13.w),
              padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Color.alphaBlend(
                  widget.accentColor.withValues(alpha: 0.1),
                  Colors.white,
                ),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.2),
                  width: 1.w,
                ),
              ),
              child: SingleChildScrollView(
                child: BlocBuilder<QuoteBloc, QuoteState>(
                  builder: (context, state) {
                    if (state is QuoteInitial) {
                      context
                          .read<QuoteBloc>()
                          .add(GetQuoteByFeelingEvent(widget.feeling));
                      return _buildLoading();
                    } else if (state is QuoteLoading) {
                      return _buildLoading();
                    } else if (state is QuoteLoaded) {
                      return _buildQuoteContent(context, state.quote);
                    } else if (state is QuoteError) {
                      isErr = true;
                      return _buildError(context, state.message);
                    }
                    return _buildLoading();
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 6.w,
              right: 7.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    top: 2.h,
                    bottom: 4.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.alphaBlend(
                            widget.primaryColor.withValues(alpha: 0.8),
                            Colors.white),
                        Color.alphaBlend(
                            widget.accentColor.withValues(alpha: 0.7),
                            Colors.white),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Text('Đóng',
                      style: TextPresets.title.copyWith(
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            isErr
                ? Positioned(
                    bottom: 6.w,
                    left: 7.w,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 12.w,
                          right: 12.w,
                          top: 2.h,
                          bottom: 4.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.alphaBlend(
                                  widget.primaryColor.withValues(alpha: 0.8),
                                  Colors.white),
                              Color.alphaBlend(
                                  widget.accentColor.withValues(alpha: 0.7),
                                  Colors.white),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.r),
                            bottomLeft: Radius.circular(12.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Text('Thử lại',
                            style: TextPresets.title.copyWith(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 7.w),
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 13.w,
                    top: 2.h,
                    bottom: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.alphaBlend(
                            widget.primaryColor.withValues(alpha: 0.8),
                            Colors.white),
                        Color.alphaBlend(
                            widget.accentColor.withValues(alpha: 0.7),
                            Colors.white),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.feeling,
                    style: TextPresets.title.copyWith(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    gradient: LinearGradient(
                      colors: [
                        Color.alphaBlend(
                            widget.primaryColor.withValues(alpha: 0.8),
                            Colors.white),
                        Color.alphaBlend(
                            widget.accentColor.withValues(alpha: 0.6),
                            Colors.white),
                      ],
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      _getFeelingIcon(widget.feeling),
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                      width: 16.w,
                      height: 16.h,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildLoading() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                widget.primaryColor,
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
          SizedBox(height: 16.h),
          Text(
            'Đợi chờ là hạnh phúc ...',
            style: TextPresets.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteContent(BuildContext context, Quote quote) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Wrap content
      children: [
        Text(
          '"${_showTranslation ? quote.displayContent : quote.content}"',
          style: TextPresets.subTitle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          '- ${quote.author}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: widget.primaryColor,
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 12.h),
        Text(
          'Nguồn: ${quote.source}',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.right,
        ),
        // Translation toggle button
        if (quote.translatedContent != null &&
            quote.translatedContent!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTranslation = !_showTranslation;
                });
              },
              child: Text(
                _showTranslation ? 'Xem bản gốc' : 'Xem bản dịch',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: widget.primaryColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60.w,
          height: 60.h,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              widget.primaryColor,
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
        SizedBox(height: 16.h),
        Text(
          'Có một chút vấn đề kỹ thuật!\nChúng tôi sẽ khắc phục ngay đây...',
          style: TextPresets.subTitle.copyWith(
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Vui lòng truy cập lại sau!',
          style: TextPresets.body,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getFeelingIcon(String feeling) {
    switch (feeling.toLowerCase()) {
      case 'mục tiêu':
        return 'assets/icons/target.svg';
      case 'vận động':
        return 'assets/icons/energy.svg';
      case 'gắn kết':
        return 'assets/icons/heart.svg';
      case 'tự tin':
        return 'assets/icons/galaxy-star.svg';
      default:
        return '';
    }
  }
}
