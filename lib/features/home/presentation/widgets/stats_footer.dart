import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/theme/app_text_styles.dart';

class StatsFooter extends StatelessWidget {
  const StatsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.footerOrange,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(number: "15k+", label: "Peserta Aktif"),
          _StatItem(number: "500+", label: "Kursus Tersedia"),
          _StatItem(number: "25k+", label: "Sertifikat Terbit"),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(number, style: AppTextStyles.footerStatNumber),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.footerStatLabel),
      ],
    );
  }
}
