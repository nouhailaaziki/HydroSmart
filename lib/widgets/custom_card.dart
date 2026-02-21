import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const CustomCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height ?? 150,
        borderRadius: AppConstants.cardRadius,
        blur: 24,
        alignment: Alignment.center,
        border: 1.5,
        linearGradient: isDark
            ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.glassLight, AppColors.glassMid],
        )
            : AppColors.lightCardGradient,
        borderGradient: isDark
            ? const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.glassBorder, AppColors.glassBorderLight],
        )
            : AppColors.lightCardBorderGradient,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}