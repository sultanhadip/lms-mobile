import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/theme/app_text_styles.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/core/widgets/app_menu.dart';
import 'package:next/core/widgets/my_course_card.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // Dummy my courses data with progress
  final List<Map<String, dynamic>> _myCourses = [
    {
      "title": "Pelatihan Innas Sensus Ekonomi 2026 Kelas C",
      "category": "Pelatihan Subject Matter Survey Sensus",
      "image": "",
      "progress": 0.35,
      "rating": 0.0,
    },
    {
      "title": "Analisis Data Statistik Dasar",
      "category": "Statistik",
      "image": "",
      "progress": 0.70,
      "rating": 0.0,
    },
    {
      "title": "Basic Python for Data Analyst",
      "category": "Data Science",
      "image": "",
      "progress": 1.0,
      "rating": 0.0,
    },
  ];

  int _currentPage = 1;
  static const int _itemsPerPage = 5;

  String _selectedStatus = "All Status";
  String _selectedSort = "Urutkan";

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
    final endIndex = (startIndex + _itemsPerPage < _myCourses.length)
        ? startIndex + _itemsPerPage
        : _myCourses.length;
    final currentCourses = _myCourses.sublist(startIndex, endIndex);
    final totalPages = (_myCourses.length / _itemsPerPage).ceil();

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
                const SizedBox(height: 140),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Kursus Saya", style: AppTextStyles.heading1),
                      const SizedBox(height: 8),
                      const Text(
                        "Lanjutkan pembelajaran Anda dan tingkatkan kompetensi diri",
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Color(0xFF94A3B8)),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Cari kursus saya...",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Status Dropdown
                      _buildRealDropdown(
                        value: _selectedStatus,
                        items: ["All Status", "Belum Selesai", "Sudah Selesai"],
                        onChanged: (val) {
                          setState(() => _selectedStatus = val!);
                        },
                      ),
                      const SizedBox(height: 12),

                      // Sort Dropdown
                      _buildRealDropdown(
                        value: _selectedSort,
                        items: ["Urutkan", "Judul (A-Z)", "Judul (Z-A)"],
                        onChanged: (val) {
                          setState(() => _selectedSort = val!);
                        },
                      ),
                      const SizedBox(height: 32),

                      // Course List
                      if (_myCourses.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Text(
                              "Anda belum memiliki kursus.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...currentCourses.map(
                          (course) => MyCourseCard(
                            title: course['title']!,
                            category: course['category']!,
                            imageUrl: course['image']!,
                            progress: course['progress'] ?? 0.0,
                            rating: course['rating'] ?? 0.0,
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Pagination Text
                      if (_myCourses.isNotEmpty) ...[
                        Center(
                          child: Text(
                            "Menampilkan ${startIndex + 1}-${endIndex} dari ${_myCourses.length} kursus",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPagination(totalPages),
                      ],

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

  Widget _buildRealDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: items.map((String item) {
            final isSelected = item == value;
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF64748B),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        color: Color(0xFF22C55E),
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final page = index + 1;
        final isActive = page == _currentPage;
        return GestureDetector(
          onTap: () {
            setState(() => _currentPage = page);
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
