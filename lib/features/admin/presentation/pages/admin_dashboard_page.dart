import 'package:flutter/material.dart';
import 'package:next/features/admin/presentation/widgets/admin_sidebar.dart';
import 'package:next/features/courses/data/services/course_service.dart';
import 'package:next/features/courses/data/models/top_courses_model.dart';
import 'package:next/features/courses/data/models/course_category_model.dart';
import 'package:next/features/courses/data/models/monthly_enrollment_model.dart';
import 'package:next/features/courses/data/models/total_statistics_model.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Data Services
  final CourseService _courseService = CourseService();

  // State
  TopCoursesData? _topCoursesData;
  CourseCategoryStats? _categoryStats;
  MonthlyEnrollmentData? _monthlyEnrollmentData;
  TotalStatistics? _totalStatistics;
  bool _isLoadingDashboard = true;
  bool _showTopPopular = true; // Toggle for Top Courses chart
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  Future<void> _fetchDashboardData() async {
    try {
      final results = await Future.wait([
        _courseService.getTopCourses().catchError(
          (e) => TopCoursesResponse(
            success: false,
            status: 500,
            message: e.toString(),
            data: TopCoursesData(topEnrolledCourses: [], topRatedCourses: []),
          ),
        ),
        _courseService.getCourseCategories().catchError(
          (e) => CourseCategoryResponse(
            success: false,
            status: 500,
            message: e.toString(),
            data: CourseCategoryStats(totalCategories: 0, categoryData: []),
          ),
        ),
        _courseService
            .getMonthlyEnrollments(2026)
            .catchError(
              (e) => MonthlyEnrollmentResponse(
                success: false,
                status: 500,
                message: e.toString(),
                data: MonthlyEnrollmentData(
                  year: 2026,
                  totalEnrollments: 0,
                  monthlyData: [],
                ),
              ),
            ),
        _courseService.getTotalStatistics().catchError(
          (e) => TotalStatisticsResponse(
            success: false,
            status: 500,
            message: e.toString(),
            data: TotalStatistics(
              totalGroupCourses: 0,
              totalKnowledgeCenters: 0,
              totalStudentsEnrolled: 0,
              totalForums: 0,
            ),
          ),
        ),
      ]);

      if (!mounted) return;

      setState(() {
        _errorMessage = null;

        // Top Courses
        if (results[0] is TopCoursesResponse) {
          final res = results[0] as TopCoursesResponse;
          if (res.success) {
            _topCoursesData = res.data;
          } else {
            _errorMessage ??= res.message;
          }
        }

        // Categories
        if (results[1] is CourseCategoryResponse) {
          final res = results[1] as CourseCategoryResponse;
          if (res.success) {
            _categoryStats = res.data;
          } else {
            _errorMessage ??= res.message;
          }
        }

        // Monthly
        if (results[2] is MonthlyEnrollmentResponse) {
          final res = results[2] as MonthlyEnrollmentResponse;
          if (res.success) {
            _monthlyEnrollmentData = res.data;
          } else {
            _errorMessage ??= res.message;
          }
        }

        // Total
        if (results[3] is TotalStatisticsResponse) {
          final res = results[3] as TotalStatisticsResponse;
          if (res.success) {
            _totalStatistics = res.data;
          } else {
            _errorMessage ??= res.message;
          }
        }

        _isLoadingDashboard = false;
      });
    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
      if (mounted) {
        setState(() {
          _isLoadingDashboard = false;
          _errorMessage = "Exception: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AdminSidebar(activeMenu: "Dashboard"),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Header with Side Menu Trigger
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.grid_view_rounded,
                            size: 24,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang, Sultan Hadi Prabowo!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Berikut ini ringkasan dashboard admin Anda.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SUMMARY CARDS (Image 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _isLoadingDashboard
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            _buildSummaryCard(
                              "Total Kursus",
                              (_totalStatistics?.totalCourses != 0
                                  ? "${_totalStatistics?.totalCourses ?? 0}"
                                  : "${_categoryStats?.categoryData.fold(0, (sum, item) => sum + item.courseCount) ?? 0}"),
                              Icons.menu_book_outlined,
                              const Color(0xFFF97316),
                            ),
                            _buildSummaryCard(
                              "Grup Kursus",
                              "${_totalStatistics?.totalGroupCourses ?? 0}",
                              Icons.folder_open_outlined,
                              const Color(0xFFA855F7),
                            ),
                            _buildSummaryCard(
                              "Knowledge Center",
                              "${_totalStatistics?.totalKnowledgeCenters ?? 0}",
                              Icons.library_books_outlined,
                              const Color(0xFF22C55E),
                            ),
                            _buildSummaryCard(
                              "Total Forum",
                              "${_totalStatistics?.totalForums ?? 0}",
                              Icons.chat_bubble_outline,
                              const Color(0xFFF97316),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 16),

                // TREND CHART (Image 2)
                _buildChartContainer(
                  title: "Trend Pendaftaran Bulanan (2026)",
                  subtitle: "Jumlah peserta yang mendaftar kursus setiap bulan",
                  child: SizedBox(
                    height: 200,
                    child: _isLoadingDashboard
                        ? const Center(child: CircularProgressIndicator())
                        : _monthlyEnrollmentData == null
                        ? Center(
                            child: Text(
                              _errorMessage ?? "Data tidak tersedia",
                              textAlign: TextAlign.center,
                            ),
                          )
                        : CustomPaint(
                            painter: LineChartPainter(
                              monthlyData: _monthlyEnrollmentData!.monthlyData,
                            ),
                            size: Size.infinite,
                          ),
                  ),
                ),

                // CATEGORY CHART (Image 3)
                // CATEGORY CHART (Image 3)
                _buildChartContainer(
                  title: "Kategori Kursus",
                  subtitle: "Distribusi kursus berdasarkan kategori",
                  child: _isLoadingDashboard
                      ? const Center(child: CircularProgressIndicator())
                      : _categoryStats == null
                      ? Center(
                          child: Text(
                            _errorMessage ?? "Data kategori tidak tersedia",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    painter: DonutChartPainter(
                                      categories: _categoryStats!.categoryData,
                                    ),
                                    size: const Size(180, 180),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "${_categoryStats?.categoryData.fold(0, (sum, item) => sum + item.courseCount) ?? 0}",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const Text(
                                        "Total",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildChartLegend(_categoryStats!.categoryData),
                          ],
                        ),
                ),

                // TOP 5 KURSUS (Image 4)
                _buildChartContainer(
                  title: "Top 5 Kursus",
                  subtitle: "Kursus paling diminati dan rating terbaik",
                  child: _isLoadingDashboard
                      ? const Center(child: CircularProgressIndicator())
                      : _topCoursesData == null
                      ? Center(
                          child: Text(
                            _errorMessage ?? "Data tidak tersedia",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _showTopPopular = true),
                                  child: _buildChartTab(
                                    "Terpopuler",
                                    _showTopPopular,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _showTopPopular = false),
                                  child: _buildChartTab(
                                    "Rating Tertinggi",
                                    !_showTopPopular,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            ...(_showTopPopular
                                    ? _topCoursesData!.topEnrolledCourses
                                    : _topCoursesData!.topRatedCourses)
                                .take(5)
                                .map((course) {
                                  // Normalize data for progress bar
                                  // For popularity: max enrollment could be dynamic, let's pick largest in list or just normalized
                                  final maxVal =
                                      (_showTopPopular
                                              ? _topCoursesData!
                                                    .topEnrolledCourses
                                              : _topCoursesData!
                                                    .topRatedCourses)
                                          .map(
                                            (e) => _showTopPopular
                                                ? e.enrollmentCount.toDouble()
                                                : e.rating,
                                          )
                                          .reduce((a, b) => a > b ? a : b);

                                  final currentVal = _showTopPopular
                                      ? course.enrollmentCount.toDouble()
                                      : course.rating;
                                  final progress = maxVal == 0
                                      ? 0.0
                                      : currentVal / maxVal;

                                  return _buildBarItem(
                                    course.name,
                                    progress,
                                    _showTopPopular
                                        ? "${course.enrollmentCount} users"
                                        : "${course.rating} ★",
                                  );
                                }),
                          ],
                        ),
                ),

                const SizedBox(height: 40),
                const SizedBox(height: 60),
              ],
            ),
          ),

          // Sticky App Bar
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _buildChartTab(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF1F5F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isActive ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            text == "Terpopuler" ? Icons.people_outline : Icons.star_outline,
            size: 14,
            color: isActive ? const Color(0xFF334155) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? const Color(0xFF334155)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(String title, double progress, String trailingText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[100]!,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            trailingText,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(List<CourseCategoryData> data) {
    // Sort by count desc and take top 5, group rest as "Lainnya" if needed
    // The requirement says "ambil data", implies listing them.
    // For the chart legend and aesthetic, let's take top 5 categories by count.

    final sortedData = List<CourseCategoryData>.from(data)
      ..sort((a, b) => b.courseCount.compareTo(a.courseCount));

    final topCategories = sortedData.take(5).toList();
    // If there are more, we could conceptually group them, but for the legend let's just show top 5 colors

    final List<Color> colors = [
      const Color(0xFFF97316),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: topCategories.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final color = colors[index % colors.length];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.category,
              style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<MonthlyData> monthlyData;

  LineChartPainter({required this.monthlyData});

  @override
  void paint(Canvas canvas, Size size) {
    if (monthlyData.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFFF97316)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFF97316).withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Determine max value for Y-axis scaling
    int maxY = monthlyData
        .map((e) => e.enrollmentCount)
        .reduce((a, b) => a > b ? a : b);
    if (maxY == 0) maxY = 10; // Avoid division by zero, default scale

    // Add some padding to top
    final double yMaxScale = maxY * 1.2;

    final path = Path();

    // Draw the line
    for (int i = 0; i < monthlyData.length; i++) {
      final x = (size.width / (monthlyData.length - 1)) * i;
      // Invert Y because canvas 0 is top
      final y =
          size.height -
          ((monthlyData[i].enrollmentCount / yMaxScale) * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Cubic bezier for smooth curve is complex without helper, use lineTo for standard graph or simple smooth
        // Simple smoothing: control points
        final prevX = (size.width / (monthlyData.length - 1)) * (i - 1);
        final prevY =
            size.height -
            ((monthlyData[i - 1].enrollmentCount / yMaxScale) * size.height);

        final controlPoint1 = Offset(prevX + (x - prevX) / 2, prevY);
        final controlPoint2 = Offset(prevX + (x - prevX) / 2, y);

        path.cubicTo(
          controlPoint1.dx,
          controlPoint1.dy,
          controlPoint2.dx,
          controlPoint2.dy,
          x,
          y,
        );

        // path.lineTo(x, y); // If cubicTo is too weird
      }
    }

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw Grid Lines & Labels
    final gridPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // X-Axis Labels (Months)
    // We have 12 months. Draw roughly.
    final List<String> shortMonths = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Ags",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];

    for (int i = 0; i < monthlyData.length; i++) {
      final x = (size.width / (monthlyData.length - 1)) * i;

      // Only draw some labels to avoid crowding? Or all 12 if space permits.
      // Let's try drawing selected ones like the image: Jan, Feb, Mar, Apr, Mei, Jun, Jul, Sep, Okt, Des
      // Image skips Aug, Nov?
      // Let's draw all but with small font.

      if (i < shortMonths.length) {
        textPainter.text = TextSpan(
          text: shortMonths[i],
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, size.height + 5),
        );
      }
    }

    // Y-Axis Grid & Labels (0, 30, 60, 90, 120 e.g.)
    // Let's draw 5 lines
    for (int i = 0; i < 5; i++) {
      double y =
          size.height -
          (size.height * (i / 4)); // 0%, 25%, 50%, 75%, 100% of height
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);

      // Label value
      int value = ((yMaxScale * (i / 4))).round();
      textPainter.text = TextSpan(
        text: value.toString(),
        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-25, y - 6));
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) => true;
}

class DonutChartPainter extends CustomPainter {
  final List<CourseCategoryData> categories;

  DonutChartPainter({required this.categories});

  @override
  void paint(Canvas canvas, Size size) {
    if (categories.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 30.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double startAngle = -1.57; // -90 degrees in radians

    final sortedData = List<CourseCategoryData>.from(categories)
      ..sort((a, b) => b.courseCount.compareTo(a.courseCount));

    final topCategories = sortedData.take(5).toList();
    final totalCount = sortedData.fold(
      0,
      (sum, item) => sum + item.courseCount,
    );

    final List<Color> colors = [
      const Color(0xFFF97316),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
    ];

    // Calculate total of top 5 to see if we need 'Others' segment logic or just paint proportional to total
    // The requirement implies visualizing the distribution. Let's paint top 5 specifically.

    for (int i = 0; i < topCategories.length; i++) {
      final item = topCategories[i];
      final color = colors[i % colors.length];

      paint.color = color;

      // Calculate sweep based on its share of TOTAL count, not just top 5 sum
      final sweepAngle = 2 * 3.14159 * (item.courseCount / totalCount);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Optionally paint "Others" in grey if there's remainder?
    // The prompt just said "ambil data", implies mirroring the original logic but with dynamic data.
    // The provided image shows a colorful ring. I'll stick to Top 5 for now.
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) => true; // Repaint if data changes
}

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const CommonText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = const Color(0xFF1E293B),
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
