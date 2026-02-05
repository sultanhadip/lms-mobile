import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/theme/app_text_styles.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/core/widgets/app_menu.dart';
import 'package:next/core/widgets/course_card.dart';
import 'package:next/features/courses/data/services/course_service.dart';
import 'package:next/features/courses/data/models/course_model.dart';
import 'package:next/features/courses/presentation/pages/course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // API Service
  final CourseService _courseService = CourseService();

  // State management
  bool _isLoading = true;
  String? _errorMessage;
  List<CourseModel> _courses = [];
  PageMeta? _pageMeta;

  int _currentPage = 1;
  static const int _itemsPerPage = 8;

  String _selectedCategory = "Semua Kategori";
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

    // Fetch courses from API
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _courseService.getPublicCourses(
        page: _currentPage,
        perPage: _itemsPerPage,
      );

      setState(() {
        _courses = response.data;
        _pageMeta = response.pageMeta;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                  hintText: "Cari kursus...",
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

                      // Category Dropdown
                      _buildRealDropdown(
                        value: _selectedCategory,
                        items: [
                          "Semua Kategori",
                          "Sensus Ekonomi",
                          "Statistik",
                          "Data Science",
                          "Big Data",
                          "Leadership",
                        ],
                        onChanged: (val) {
                          setState(() => _selectedCategory = val!);
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

                      // Loading State
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ),

                      // Error State
                      if (_errorMessage != null && !_isLoading)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat data',
                                  style: AppTextStyles.sectionTitle,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: AppTextStyles.bodyText,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchCourses,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryOrange,
                                  ),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Course List
                      if (!_isLoading && _errorMessage == null)
                        ..._courses.map((course) {
                          // Get teacher names, if empty use manager name
                          String instructorName = course.teachers.isNotEmpty
                              ? course.teachers.map((t) => t.name).join(', ')
                              : course.manager.name;

                          return CourseCard(
                            title: course.name,
                            category: course.groupCourse.description.category,
                            imageUrl: course.groupCourse.thumbnail,
                            instructor: instructorName,
                            studentCount: course.activityCount,
                            rating: course.rating,
                            width: double.infinity,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetailPage(course: course),
                                ),
                              );
                            },
                          );
                        }),

                      const SizedBox(height: 24),

                      // Pagination Text
                      if (!_isLoading &&
                          _errorMessage == null &&
                          _pageMeta != null)
                        Center(
                          child: Text(
                            "Menampilkan ${_pageMeta!.showingFrom}-${_pageMeta!.showingTo} dari ${_pageMeta!.totalResultCount} kursus",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Pagination Buttons
                      if (!_isLoading &&
                          _errorMessage == null &&
                          _pageMeta != null)
                        _buildPagination(_pageMeta!.totalPageCount),

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
            setState(() {
              _currentPage = page;
            });
            _fetchCourses();
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
