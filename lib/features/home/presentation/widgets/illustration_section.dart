import 'package:flutter/material.dart';

class IllustrationSection extends StatelessWidget {
  const IllustrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Image Placeholder (The Person)
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.person,
              size: 220, // Slightly larger since it's flexible now
              color: Colors.brown.withValues(alpha: 0.5), // Placeholder
            ),
          ),

          // Floating Icon 1 (Left - Book)
          Positioned(
            left: 40,
            top: 10,
            child: _FloatingIcon(icon: Icons.menu_book, color: Colors.orange),
          ),
          // Floating Icon 2 (Left - Bulb/Idea)
          Positioned(
            left: 30,
            bottom: 40,
            child: _FloatingIcon(
              icon: Icons.lightbulb_outline,
              color: Colors.yellow,
            ),
          ),
          // Floating Icon 3 (Right - Star)
          Positioned(
            right: 40,
            top: 40,
            child: _FloatingIcon(
              icon: Icons.star_border,
              color: Colors.purpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _FloatingIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
