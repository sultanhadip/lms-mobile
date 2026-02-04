import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/presentation/widgets/custom_app_bar.dart';
import '../../../home/presentation/widgets/main_footer.dart';
import '../../../home/presentation/widgets/app_menu.dart';
import '../../../home/presentation/widgets/course_card.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // Dummy courses data
  final List<Map<String, String>> _allCourses = [
    {
      "title": "Pelatihan Innas Sensus Ekonomi 2026 Kelas C",
      "category": "Pelatihan Subject Matter Survey Sensus",
      "image": "",
      "instructor": "Budi Santoso",
      "students": "120",
    },
    {
      "title": "Pelatihan Sensus Ekonomi 2026 Kelas A",
      "category": "Sensus Ekonomi",
      "image": "",
      "instructor": "Siti Nurhaliza",
      "students": "85",
    },
    {
      "title": "Analisis Data Statistik Dasar",
      "category": "Statistik",
      "image": "",
      "instructor": "Ahmad Wijaya",
      "students": "250",
    },
    {
      "title": "Manajemen Data Besar I",
      "category": "Big Data",
      "image": "",
      "instructor": "Hadi Prabowo",
      "students": "45",
    },
    {
      "title": "Kepemimpinan Digital",
      "category": "Leadership",
      "image": "",
      "instructor": "Dr. Arifin",
      "students": "67",
    },
    {
      "title": "Visualisasi Data Modern",
      "category": "Data Science",
      "image": "",
      "instructor": "Rina Amalia",
      "students": "134",
    },
    {
      "title": "Pelatihan Innas Sensus Ekonomi 2026 Kelas D",
      "category": "Sensus Ekonomi",
      "image": "",
      "instructor": "Budi Santoso",
      "students": "92",
    },
    {
      "title": "Basic Python for Data Analyst",
      "category": "Data Science",
      "image": "",
      "instructor": "Andi Setiawan",
      "students": "310",
    },
  ];

  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pagination logic
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage < _allCourses.length)
        ? startIndex + _itemsPerPage
        : _allCourses.length;
    final currentCourses = _allCourses.sublist(startIndex, endIndex);
    final totalPages = (_allCourses.length / _itemsPerPage).ceil();

    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: const AppMenu(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100), // Space for sticky app bar
                // Header Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Semua Kursus", style: AppTextStyles.heading1),
                      const SizedBox(height: 8),
                      const Text(
                        "Jelajahi koleksi lengkap kursus profesional kami",
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Cari kursus...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Category Filter
                      _buildDropdown("Semua Kategori"),
                      const SizedBox(height: 12),

                      // Sort Filter
                      _buildDropdown("Urutkan"),
                      const SizedBox(height: 32),

                      // Course List
                      ...currentCourses.map(
                        (course) => CourseCard(
                          title: course['title']!,
                          category: course['category']!,
                          imageUrl: course['image']!,
                          instructor: course['instructor'] ?? "-",
                          studentCount:
                              int.tryParse(course['students'] ?? "0") ?? 0,
                          width: double.infinity,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pagination Text
                      Center(
                        child: Text(
                          "Menampilkan ${startIndex + 1}-${endIndex} dari ${_allCourses.length} kursus",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pagination Buttons
                      _buildPagination(totalPages),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),

                const MainFooter(),
              ],
            ),
          ),

          // Sticky App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: _isScrolled ? Colors.white : AppColors.background,
              child: SafeArea(
                bottom: false,
                child: Container(
                  decoration: BoxDecoration(
                    border: _isScrolled
                        ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                        : null,
                  ),
                  child: const CustomAppBar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textBlack)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final page = index + 1;
        final isActive = page == _currentPage;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentPage = page;
            });
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryOrange : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive ? AppColors.primaryOrange : Colors.grey[300]!,
              ),
            ),
            child: Text(
              page.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textBlack,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}
