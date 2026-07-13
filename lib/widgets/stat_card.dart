import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color glowColor;

  const StatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.glowColor = AppTheme.primaryAccentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Icon(icon, color: glowColor, size: 22),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: glowColor.withOpacity(0.8), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).scale(delay: 100.ms, duration: 400.ms);
  }
}