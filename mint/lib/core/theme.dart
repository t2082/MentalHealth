import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_health/core/extension/extensions.dart';

class FontSizes {
  static const double size10 = 10.0;
  static const double size11 = 11.0;
  static const double size12 = 12.0;
  static const double size13 = 13.0;
  static const double size14 = 14.0;
  static const double size15 = 15.0;
  static const double size16 = 16.0;
  static const double size17 = 17.0;
  static const double size18 = 18.0;
  static const double size19 = 19.0;
  static const double size20 = 20.0;
  static const double size21 = 21.0;
  static const double size22 = 22.0;
  static const double size23 = 23.0;
  static const double size24 = 24.0;
  static const double size25 = 25.0;
  static const double size26 = 26.0;
  static const double size27 = 27.0;
  static const double size28 = 28.0;
  static const double size29 = 29.0;
  static const double size30 = 30.0;
  static const double size31 = 31.0;
  static const double size32 = 32.0;
  static const double size33 = 33.0;
  static const double size34 = 34.0;
  static const double size35 = 35.0;
  static const double size36 = 36.0;
  static const double size37 = 37.0;
  static const double size38 = 38.0;
  static const double size39 = 39.0;
  static const double size40 = 40.0;
  static const double size41 = 41.0;
  static const double size42 = 42.0;
  static const double size43 = 43.0;
  static const double size44 = 44.0;
  static const double size45 = 45.0;
  static const double size46 = 46.0;
  static const double size47 = 47.0;
  static const double size48 = 48.0;
}

class DefaultColors {
  static Color get background => const Color(0xFFF5FFFA);
  // static Color get border => const Color(0xFFF5FFFA);

  static Color get textPrimary => DateTime.now().isMorning
      ? const Color(0xFF665F73)
      : const Color(0xFFFFFFFF);

  static Color get reverseTextPrimary => DateTime.now().isMorning
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF665F73);

  static Color get primary => const Color(0xFFC3FFD0);

  static Color get reversePrimary => DateTime.now().isMorning
      ? const Color(0xFF121B31)
      : const Color(0xFF98ba82);

  static const Color secondary = Color(0xFF371B34);

  static const Color white = Color(0xFFFFFFFF);
  static const Color pink = Color(0xFFEA2B83);
  static const Color lightpink = Color(0xFFFCDDEC);
  static const Color purple = Color(0xFF8E8FF8);
  static const Color orange = Color(0xFFF18F3B);
  static const Color lightteal = Color(0xFF58D5D4);
  static const Color darksea = Color(0xFF121B31);
  static const Color tea = Color(0xFF98ba82); // Màu trà xanh nhạt cho buổi sáng

  // Bộ màu mới nổi bật trên nền trắng
  static const Color dopamine = Color(0xFF8E44AD); // Tím đậm cho mục tiêu
  static const Color dopamineNeon = Color(0xFFBB6BD9); // Tím neon sáng
  static const Color endorphin =
      Color(0xFFE74C3C); // Đỏ năng lượng cho vận động
  static const Color endorphinNeon = Color(0xFFFF6B35); // Đỏ neon sáng
  static const Color oxytocin = Color(0xFFE91E63); // Hồng đậm cho gắn kết
  static const Color oxytocinNeon = Color(0xFFFF4081); // Hồng neon sáng
  static const Color serotonin = Color(0xFF27AE60); // Xanh lá đậm cho tự tin
  static const Color serotoninNeon =
      Color(0xFF2ECC71); // Xanh lá neon sáng // Xanh lá neon sáng

  static Color task1 = Colors.pink[100]!;
  static Color task2 = Colors.orange[100]!;
  static Color task3 = Colors.green[100]!;
}

class TextPresets {
  // Small labels & captions - Cho các nhãn nhỏ, caption
  static TextStyle get labelSmall => GoogleFonts.quicksand(
        fontSize: FontSizes.size10,
        fontWeight: FontWeight.w400,
        height: 1.2,
      );

  static TextStyle get label => GoogleFonts.quicksand(
        fontSize: FontSizes.size12,
        fontWeight: FontWeight.w500,
        height: 1.3,
      );

  static TextStyle get labelLarge => GoogleFonts.quicksand(
        fontSize: FontSizes.size14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // Body Text - Cho nội dung chính
  static TextStyle get bodySmall => GoogleFonts.quicksand(
        fontSize: FontSizes.size13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get body => GoogleFonts.quicksand(
        fontSize: FontSizes.size14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.quicksand(
        fontSize: FontSizes.size16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyLarge => GoogleFonts.quicksand(
        fontSize: FontSizes.size18,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  // Titles - Cho tiêu đề các section
  static TextStyle get titleSmall => GoogleFonts.quicksand(
        fontSize: FontSizes.size18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get subTitle => GoogleFonts.quicksand(
        fontSize: FontSizes.size16,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get title => GoogleFonts.quicksand(
        fontSize: FontSizes.size16,
        fontWeight: FontWeight.w700,
        height: 1.4,
      );

  static TextStyle get titleLarge => GoogleFonts.quicksand(
        fontSize: FontSizes.size24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  // Headlines - Cho tiêu đề lớn
  static TextStyle get headlineSmall => GoogleFonts.quicksand(
        fontSize: FontSizes.size26,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get headline => GoogleFonts.quicksand(
        fontSize: FontSizes.size28,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get headlineLarge => GoogleFonts.quicksand(
        fontSize: FontSizes.size32,
        fontWeight: FontWeight.w800,
        height: 1.2,
      );

  // Display / Hero - Cho tiêu đề chính của màn hình
  static TextStyle get displaySmall => GoogleFonts.quicksand(
        fontSize: FontSizes.size34,
        fontWeight: FontWeight.w800,
        height: 1.15,
      );

  static TextStyle get display => GoogleFonts.quicksand(
        fontSize: FontSizes.size36,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  static TextStyle get displayLarge => GoogleFonts.quicksand(
        fontSize: FontSizes.size40,
        fontWeight: FontWeight.w900,
        height: 1.05,
      );

  // Special styles - Cho các mục đích đặc biệt
  static TextStyle get price => GoogleFonts.quicksand(
        fontSize: FontSizes.size16,
        fontWeight: FontWeight.w900,
        height: 1.5,
      );

  static TextStyle get button => GoogleFonts.quicksand(
        fontSize: FontSizes.size16,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get buttonSmall => GoogleFonts.quicksand(
        fontSize: FontSizes.size14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get buttonLarge => GoogleFonts.quicksand(
        fontSize: FontSizes.size18,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  // Helper methods để thêm màu sắc
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withPrimaryColor(TextStyle style) {
    return style.copyWith(color: DefaultColors.textPrimary);
  }

  static TextStyle withSecondaryColor(TextStyle style) {
    return style.copyWith(color: DefaultColors.secondary);
  }

  static TextStyle withWhiteColor(TextStyle style) {
    return style.copyWith(color: DefaultColors.white);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFFAEAFF7),
      focusColor: const Color(0xFF371B34),
      fontFamily: GoogleFonts.quicksand().fontFamily,
      textTheme: TextTheme(
        // Display styles
        displayLarge:
            TextPresets.displayLarge.copyWith(color: DefaultColors.textPrimary),
        displayMedium:
            TextPresets.display.copyWith(color: DefaultColors.textPrimary),
        displaySmall:
            TextPresets.displaySmall.copyWith(color: DefaultColors.textPrimary),

        // Headline styles
        headlineLarge: TextPresets.headlineLarge
            .copyWith(color: DefaultColors.textPrimary),
        headlineMedium:
            TextPresets.headline.copyWith(color: DefaultColors.textPrimary),
        headlineSmall: TextPresets.headlineSmall
            .copyWith(color: DefaultColors.textPrimary),

        // Title styles
        titleLarge:
            TextPresets.titleLarge.copyWith(color: DefaultColors.textPrimary),
        titleMedium:
            TextPresets.title.copyWith(color: DefaultColors.textPrimary),
        titleSmall:
            TextPresets.titleSmall.copyWith(color: DefaultColors.textPrimary),

        // Body styles
        bodyLarge:
            TextPresets.bodyLarge.copyWith(color: DefaultColors.textPrimary),
        bodyMedium:
            TextPresets.bodyMedium.copyWith(color: DefaultColors.textPrimary),
        bodySmall:
            TextPresets.bodySmall.copyWith(color: DefaultColors.textPrimary),

        // Label styles
        labelLarge:
            TextPresets.labelLarge.copyWith(color: DefaultColors.textPrimary),
        labelMedium:
            TextPresets.label.copyWith(color: DefaultColors.textPrimary),
        labelSmall:
            TextPresets.labelSmall.copyWith(color: DefaultColors.textPrimary),
      ),
      colorScheme: ColorScheme.light(
        primary: DefaultColors.primary,
        secondary: DefaultColors.secondary,
        surface: DefaultColors.white,
        onPrimary: DefaultColors.white,
        onSecondary: DefaultColors.white,
        onSurface: DefaultColors.textPrimary,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: const Color(0xFF98ba82),
      focusColor: const Color(0xFF371B34),
      fontFamily: GoogleFonts.quicksand().fontFamily,
      textTheme: TextTheme(
        // Display styles
        displayLarge:
            TextPresets.displayLarge.copyWith(color: DefaultColors.white),
        displayMedium: TextPresets.display.copyWith(color: DefaultColors.white),
        displaySmall:
            TextPresets.displaySmall.copyWith(color: DefaultColors.white),

        // Headline styles
        headlineLarge:
            TextPresets.headlineLarge.copyWith(color: DefaultColors.white),
        headlineMedium:
            TextPresets.headline.copyWith(color: DefaultColors.white),
        headlineSmall:
            TextPresets.headlineSmall.copyWith(color: DefaultColors.white),

        // Title styles
        titleLarge: TextPresets.titleLarge.copyWith(color: DefaultColors.white),
        titleMedium: TextPresets.title.copyWith(color: DefaultColors.white),
        titleSmall: TextPresets.titleSmall.copyWith(color: DefaultColors.white),

        // Body styles
        bodyLarge: TextPresets.bodyLarge.copyWith(color: DefaultColors.white),
        bodyMedium: TextPresets.bodyMedium.copyWith(color: DefaultColors.white),
        bodySmall: TextPresets.bodySmall.copyWith(color: DefaultColors.white),

        // Label styles
        labelLarge: TextPresets.labelLarge.copyWith(color: DefaultColors.white),
        labelMedium: TextPresets.label.copyWith(color: DefaultColors.white),
        labelSmall: TextPresets.labelSmall.copyWith(color: DefaultColors.white),
      ),
      colorScheme: ColorScheme.dark(
        primary: DefaultColors.primary,
        secondary: DefaultColors.secondary,
        surface: DefaultColors.darksea,
        onPrimary: DefaultColors.white,
        onSecondary: DefaultColors.white,
        onSurface: DefaultColors.white,
      ),
      useMaterial3: true,
    );
  }
}

class DfBRadius {
  static BorderRadius defaultRadius = BorderRadius.circular(8.r);
}
