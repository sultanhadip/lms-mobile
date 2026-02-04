import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  final List<String> categories = const [
    "Populer",
    "Statistik",
    "Data Science",
    "Leadership",
    "Pemerintahan",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 12.0,
        alignment: WrapAlignment.center,
        children: categories.map((category) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(category, style: AppTextStyles.chipText),
          );
        }).toList(),
      ),
    );
  }
}
