import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
    height: 1.2,
  );

  static const TextStyle headingOrange = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryOrange,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primaryOrange,
    height: 1.2,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static const TextStyle chipText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textBlack,
  );

  static const TextStyle footerStatNumber = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle footerStatLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F172A), // Use dark blue like in image
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static const TextStyle footerHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle footerLink = TextStyle(
    fontSize: 14,
    color: Color(0xFFB0B8C4), // Light grey for footer links
    height: 2.0,
  );
}
