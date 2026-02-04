import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/features/admin/presentation/widgets/admin_sidebar.dart';
import 'content_bank_page.dart';
import 'question_bank_page.dart';
import 'course_list_page.dart';

class MasterCoursesPage extends StatefulWidget {
  const MasterCoursesPage({super.key});

  @override
  State<MasterCoursesPage> createState() => _MasterCoursesPageState();
}

class _MasterCoursesPageState extends State<MasterCoursesPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 1;
  final int _itemsPerPage = 4;

  final List<Map<String, dynamic>> _masterCourses = List.generate(
    12,
    (index) => {
      "title": "Pelatihan Innas Sensus Ekonomi 2026 ${index + 1}",
      "category": "Pelatihan Subject Matter Survey Sensus",
      "status": "Aktif",
      "courseCount": 3,
      "date": "3 Feb 2026",
      "image": "https://placeholder.com/400x200", // Placeholder
    },
  );

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
  Widget build(BuildContext context) {
    int totalPages = (_masterCourses.length / _itemsPerPage).ceil();
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > _masterCourses.length) endIndex = _masterCourses.length;
    final currentCourses = _masterCourses.sublist(startIndex, endIndex);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AdminSidebar(activeMenu: "Kursus Induk"),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 140),

                // Header
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
                                color: Colors.black.withOpacity(0.05),
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
                              "Kursus Induk",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Bergabung dengan program pelatihan terstruktur bersama peserta lainnya",
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

                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      _buildSearchField(),
                      const SizedBox(height: 12),
                      _buildFilterDropdown("Semua Kategori"),
                      const SizedBox(height: 12),
                      _buildFilterDropdown("Urutkan"),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Course List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: currentCourses
                        .map(
                          (course) => GestureDetector(
                            onTap: () => _showActionDialog(course['title']),
                            child: _buildMasterCourseCard(course),
                          ),
                        )
                        .toList(),
                  ),
                ),

                // Pagination (Image 2)
                _buildPaginationFooter(totalPages),

                const SizedBox(height: 40),
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
              color: _isScrolled ? Colors.white : const Color(0xFFF8FAFC),
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

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Cari kursus...",
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildMasterCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              "https://images.unsplash.com/photo-1522071823991-b9671f9d7f1f?auto=format&fit=crop&q=80&w=800", // High quality dummy
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course['category'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Aktif",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  course['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${course['courseCount']} Course",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      course['date'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _paginationButton(const Icon(Icons.chevron_left, size: 18), false),
          const SizedBox(width: 8),
          ...List.generate(totalPages, (index) {
            int pageNum = index + 1;
            bool isActive = pageNum == _currentPage;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _paginationButton(
                Text(
                  pageNum.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isActive,
                onTap: () => setState(() => _currentPage = pageNum),
              ),
            );
          }),
          _paginationButton(const Icon(Icons.chevron_right, size: 18), false),
        ],
      ),
    );
  }

  Widget _paginationButton(
    Widget content,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.grey[200]!,
          ),
        ),
        child: Center(child: content),
      ),
    );
  }

  void _showActionDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        title: Column(
          children: [
            Text(
              'Pilih Aksi untuk "$title"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogButton(Icons.library_books_outlined, "Bank Konten", () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContentBankPage(),
                ),
              );
            }),
            const SizedBox(height: 12),
            _dialogButton(Icons.assignment_outlined, "Bank Soal", () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestionBankPage(),
                ),
              );
            }),
            const SizedBox(height: 12),
            _dialogButton(Icons.list_alt_rounded, "Lihat Semua Course", () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CourseListPage()),
              );
            }),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Batal",
                style: TextStyle(
                  color: Color(0xFFF97316),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF97316)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFF97316), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFF97316),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
