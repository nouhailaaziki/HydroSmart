import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ── Dark-mode styles (static, used throughout dark-mode widgets) ──────────

  // Heading Styles
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    letterSpacing: -0.5,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.3,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  // Body Styles
  static TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite,
  );

  static TextStyle bodyBold = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  // Caption Styles
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite70,
  );

  static TextStyle small = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite54,
  );

  // Special Styles
  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: 0.5,
  );

  static TextStyle greeting = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite70,
  );

  static TextStyle appTitle = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    letterSpacing: -0.5,
  );

  static TextStyle statValue = GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    letterSpacing: -0.5,
  );

  // ── Context-aware helpers (adapt to current theme brightness) ────────────

  static TextStyle getHeading1(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return heading1.copyWith(
      color: isDark ? AppColors.textWhite : AppColors.lightPrimaryText,
    );
  }

  static TextStyle getHeading2(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return heading2.copyWith(
      color: isDark ? AppColors.textWhite : AppColors.lightPrimaryText,
    );
  }

  static TextStyle getHeading3(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return heading3.copyWith(
      color: isDark ? AppColors.textWhite : AppColors.lightPrimaryText,
    );
  }

  static TextStyle getBody(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return body.copyWith(
      color: isDark ? AppColors.textWhite : AppColors.lightPrimaryText,
    );
  }

  static TextStyle getBodyBold(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return bodyBold.copyWith(
      color: isDark ? AppColors.textWhite : AppColors.lightPrimaryText,
    );
  }

  static TextStyle getCaption(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return caption.copyWith(
      color: isDark
          ? AppColors.textWhite70
          : AppColors.lightPrimaryText.withOpacity(0.6),
    );
  }

  static TextStyle getSmall(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return small.copyWith(
      color: isDark
          ? AppColors.textWhite54
          : AppColors.lightPrimaryText.withOpacity(0.45),
    );
  }

  static TextStyle getButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return button.copyWith(
      color: isDark ? AppColors.textWhite : Colors.white,
    );
  }

  static TextStyle getGreeting(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return greeting.copyWith(
      color: isDark
          ? AppColors.textWhite70
          : AppColors.lightPrimaryText.withOpacity(0.65),
    );
  }

  static TextStyle getStatValue(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return statValue.copyWith(
      color: isDark ? AppColors.textWhite : AppColors.lightPrimaryText,
    );
  }
}