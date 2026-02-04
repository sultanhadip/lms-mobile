import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'course_card.dart';

class CourseSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> courses;

  const CourseSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.sectionTitle),
                    Container(
                      width: 60,
                      height: 3,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber, // Underline color
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(subtitle, style: AppTextStyles.sectionSubtitle),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Horizontal List
          SizedBox(
            height: 320, // Adjust based on card height
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Added for better feel
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CourseCard(
                  title: course['title'],
                  category: course['category'],
                  imageUrl: course['image'],
                );
              },
            ),
          ),
          // Dots Indicator (Static for now)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(false),
                _dot(false),
                _dot(true), // Active
                _dot(false),
                _dot(false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primaryOrange : Colors.grey[300],
      ),
    );
  }
}
