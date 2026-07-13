import 'package:flutter/material.dart';
import 'classmorphism/glassmorphism.dart'; // Glassmorphism package import
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;

  const GlassCard({
    Key? key,
    required this.child,
    this.height,
    this.width,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      borderRadius: borderRadius,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1E1E24).withOpacity(0.4),
          const Color(0xFF121216).withOpacity(0.2),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.glassBorderColor.withOpacity(0.5),
          AppTheme.primaryAccentColor.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}