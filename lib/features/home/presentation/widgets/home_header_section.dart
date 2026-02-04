import 'package:flutter/material.dart';
import 'hero_section.dart';
import 'search_bar_widget.dart';
import 'category_filter.dart';
import 'illustration_section.dart';
import 'stats_footer.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight,
      child: Stack(
        children: [
          // Grid Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                'https://img.freepik.com/free-vector/grid-pattern-background_1409-960.jpg', // Placeholder
                color: Colors.orange[200],
                colorBlendMode: BlendMode.srcIn,
                repeat: ImageRepeat.repeat,
                errorBuilder: (_, __, ___) => const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFF8E5), Color(0xFFFFE0B2)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Alternative Pure Code Grid
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 140), // Spacing for Navbar
              HeroSection(),
              SearchBarWidget(),
              CategoryFilter(),
              Expanded(child: IllustrationSection()),
              StatsFooter(),
            ],
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.1)
      ..strokeWidth = 1;

    const double step = 40;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
