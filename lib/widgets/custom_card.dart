import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../theme/app_colors.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height ?? 150,
        borderRadius: 16,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            AppColors.textWhite.withOpacity(0.1),
            AppColors.textWhite.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppColors.textWhite.withOpacity(0.2),
            AppColors.textWhite.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
