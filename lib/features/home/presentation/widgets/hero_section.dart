import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Selamat Datang di\n",
                  style: AppTextStyles.heading1,
                ),
                TextSpan(
                  text: "E-Warkop NG",
                  style: AppTextStyles.headingOrange,
                ),
                TextSpan(text: " BPS", style: AppTextStyles.heading1),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Platform pembelajaran online yang menyajikan berbagai materi pelatihan, pengetahuan, dan webinar yang dapat diakses oleh seluruh pegawai Badan Pusat Statistik dan masyarakat umum.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText,
          ),
        ],
      ),
    );
  }
}
