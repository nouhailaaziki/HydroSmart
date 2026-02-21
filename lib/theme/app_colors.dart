import 'package:flutter/material.dart';

class AppColors {
  // Monochromatic Blue Glassmorphism Palette
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF90CAF9);

  static const Color secondary = Color(0xFF42A5F5);
  static const Color secondaryDark = Color(0xFF1E88E5);
  static const Color secondaryLight = Color(0xFFE3F2FD);

  static const Color navy = Color(0xFF0D2051);
  static const Color navyMid = Color(0xFF0D2051);
  static const Color navyLight = Color(0xFF162060);

  static const Color teal = Color(0xFF42A5F5);       // kept for compatibility (now accent blue)
  static const Color tealLight = Color(0xFF90CAF9);  // kept for compatibility (now light blue)

  static const Color accent = Color(0xFF42A5F5);
  static const Color error = Color(0xFFEF5350);
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFCA28);
  static const Color info = Color(0xFF42A5F5);

  static const Color backgroundLight = Color(0xFFD0E1F9);
  static const Color backgroundDark = Color(0xFF0D2051);
  static const Color surfaceDark = Color(0xFF0D2051);
  static const Color textBlack = Color(0xFF0D2051);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Color(0xB3FFFFFF);
  static const Color textWhite54 = Color(0x8AFFFFFF);
  static const Color textWhite38 = Color(0x61FFFFFF);
  static const Color textGrey = Color(0xFFE3F2FD);   // light blue (renamed value from grey)

  // Dark mode glass effect colors (frosted white overlay)
  static const Color glassLight = Color(0x1AFFFFFF);
  static const Color glassMid = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBorderLight = Color(0x1AFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyLight, backgroundDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassLight, glassMid],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF162060), Color(0xFF0D2051)],
  );

  // ── Light Mode (Liquid + Glassmorphism) ──────────────────────────────────

  /// Dark accent – used for borders and strong contrast elements.
  static const Color lightDarkAccent = Color(0xFF121B2B);

  /// Primary deep-blue action colour.
  static const Color lightDeepBlue = Color(0xFF3282F6);

  /// Mid-cyan highlight / accent.
  static const Color lightMidCyan = Color(0xFF84D8FA);

  /// Light-cyan surface tint.
  static const Color lightCyanSurface = Color(0xFFE1F5FE);

  /// Gradient fade end-stop.
  static const Color lightGradientFade = Color(0xFFF0F9FF);

  /// Blue shadow tone for glass cards.
  static const Color lightShadowTone = Color(0xFF2A4B7C);

  /// Primary dark text colour.
  static const Color lightPrimaryText = Color(0xFF1A202C);

  // Light mode glass-effect colours (white overlays for glassmorphism cards)
  static const Color lightGlassOverlay = Color(0x1FFFFFFF); // ~12 % white
  static const Color lightGlassMid     = Color(0x33FFFFFF); // ~20 % white
  static const Color lightGlassBorder  = Color(0x4DFFFFFF); // ~30 % white
  static const Color lightGlassBorderLight = Color(0x26FFFFFF); // ~15 % white

  /// Radial mesh gradient for the light-mode main background.
  /// Transitions from [lightDeepBlue] (top-centre) to [lightGradientFade].
  static const RadialGradient lightBackgroundGradient = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.4,
    colors: [lightDeepBlue, lightGradientFade],
    stops: [0.0, 1.0],
  );

  /// Light-mode card gradient (white glass overlay).
  static const LinearGradient lightCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGlassOverlay, lightGlassMid],
  );

  /// Light-mode card border gradient.
  static const LinearGradient lightCardBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGlassBorder, lightGlassBorderLight],
  );
}