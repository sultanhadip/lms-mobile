import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A), // Dark Blue
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Desc
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                "E-Warkop",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Platform E-Learning resmi Pusdiklat BPS RI. Mengakselerasi kompetensi SDM melalui inovasi pembelajaran digital terintegrasi.",
            style: TextStyle(color: Color(0xFF94A3B8), height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _socialIcon(Icons.facebook),
              const SizedBox(width: 12),
              _socialIcon(Icons.camera_alt), // Instagram placeholder
              const SizedBox(width: 12),
              _socialIcon(Icons.flutter_dash), // Twitter placeholder
              const SizedBox(width: 12),
              _socialIcon(Icons.play_arrow), // Youtube placeholder
            ],
          ),
          const SizedBox(height: 40),

          // Jelajahi
          const Text("Jelajahi", style: AppTextStyles.footerHeading),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _footerLink("Dashboard"),
              _footerLink("Katalog Kursus"),
              _footerLink("Kursus Saya"),
              _footerLink("Knowledge Center"),
              _footerLink("FAQ"),
            ],
          ),
          const SizedBox(height: 40),

          // Hubungi Kami
          const Text("Hubungi Kami", style: AppTextStyles.footerHeading),
          const SizedBox(height: 16),
          _contactItem(
            Icons.location_on_outlined,
            "Jl. Raya Jagakarsa No.70, Jakarta Selatan 12620",
          ),
          const SizedBox(height: 12),
          _contactItem(Icons.phone_outlined, "(021) 7873781"),
          const SizedBox(height: 12),
          _contactItem(Icons.email_outlined, "pusdiklat@bps.go.id"),

          const SizedBox(height: 40),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "© 2026 Pusdiklat BPS RI. All rights reserved.",
              style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _footerLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF94A3B8),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.footerLink),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryOrange, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF94A3B8), height: 1.5),
          ),
        ),
      ],
    );
  }
}
