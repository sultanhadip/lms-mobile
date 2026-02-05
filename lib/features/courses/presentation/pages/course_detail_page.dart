import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/core/widgets/app_menu.dart';
import 'package:next/features/courses/data/models/course_model.dart';
import 'package:next/features/courses/data/models/course_content_model.dart';
import 'package:next/features/courses/data/services/course_service.dart';
import 'package:next/features/home/presentation/pages/home_page.dart';
import 'package:next/features/courses/presentation/pages/courses_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseModel course;

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final CourseService _courseService = CourseService();
  bool _isScrolled = false;
  String _activeTab = "Informasi";

  // Content Data
  List<SectionModel>? _sections;
  bool _isLoadingContent = false;
  String? _errorMessage;

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

    // Fetch contents initially
    _fetchCourseContents();
  }

  Future<void> _fetchCourseContents() async {
    setState(() {
      _isLoadingContent = true;
      _errorMessage = null;
    });

    try {
      final response = await _courseService.getCourseContents(widget.course.id);
      if (response.success) {
        setState(() {
          _sections = response.listSection;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      // For demo purposes, we might want to fail gracefully or show a message
      debugPrint("Error fetching contents: $e");
      setState(() {
        _errorMessage = "Gagal memuat konten kursus.";
      });
    } finally {
      setState(() {
        _isLoadingContent = false;
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
                const SizedBox(height: 140), // Space for sticky app bar
                // Breadcrumbs
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      _buildBreadcrumbItem(
                        "Beranda",
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      _buildBreadcrumbSeparator(),
                      _buildBreadcrumbItem(
                        "Kursus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CoursesPage(),
                            ),
                          );
                        },
                      ),
                      _buildBreadcrumbSeparator(),
                      Expanded(
                        child: Text(
                          widget.course.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Banner Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        image: widget.course.groupCourse.thumbnail.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.course.groupCourse.thumbnail,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.course.groupCourse.thumbnail.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Info Section (Under Banner)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.course.groupCourse.description.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Rating Card
                        _buildSummaryCard(
                          icon: Icons.star_rounded,
                          iconColor: Colors.orange,
                          bgColor: const Color(0xFFFFF7ED),
                          borderColor: const Color(0xFFFFEDD5),
                          title: "${widget.course.rating} / 5.0",
                          subtitle:
                              "Berdasarkan ${widget.course.totalUserRating} ulasan",
                        ),
                        const SizedBox(height: 12),

                        // Students Card
                        _buildSummaryCard(
                          icon: Icons.people_outline_rounded,
                          iconColor: const Color(0xFFF97316),
                          bgColor: const Color(0xFFF8FAFC),
                          borderColor: const Color(0xFFF1F5F9),
                          title: "Siswa Terdaftar",
                          subtitle: "${widget.course.activityCount}",
                        ),
                        const SizedBox(height: 24),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC2410C),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Daftar Sekarang",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Course Tabs / Selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.course.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _activeTab,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF64748B),
                            ),
                            items:
                                [
                                  "Informasi",
                                  "Konten Kursus",
                                  "Rating & Ulasan",
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() => _activeTab = newValue);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Dynamic Content Based on Tab
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildActiveTabContent(),
                ),

                const SizedBox(height: 60),
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

  Widget _buildBreadcrumbItem(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: onTap != null
              ? const Color(0xFF64748B)
              : const Color(0xFF94A3B8),
          fontWeight: onTap != null ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBreadcrumbSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        "/",
        style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required Color borderColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case "Informasi":
        return _buildInformasiTab();
      case "Konten Kursus":
        return _buildKontenTab();
      case "Rating & Ulasan":
        return _buildRatingTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInformasiTab() {
    return Column(
      children: [
        _buildInfoTile(
          Icons.menu_book_rounded,
          "METODE",
          widget.course.groupCourse.description.method.isNotEmpty
              ? "${widget.course.groupCourse.description.method[0].toUpperCase()}${widget.course.groupCourse.description.method.substring(1)}"
              : "-",
          const Color(0xFFF97316),
        ),
        _buildInfoTile(
          Icons.archive_outlined,
          "SILABUS",
          "Download Silabus",
          const Color(0xFFF97316),
          hasDownload: true,
          onTap: () async {
            final url = widget.course.groupCourse.description.silabus;
            if (url.isNotEmpty) {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                debugPrint("Could not launch $url");
              }
            }
          },
        ),
        _buildInfoTile(
          Icons.access_time_rounded,
          "TOTAL JAM PELAJARAN",
          "${widget.course.groupCourse.description.totalJp} JP",
          const Color(0xFFA855F7),
        ),
        _buildInfoTile(
          Icons.description_outlined,
          "KURIKULUM",
          widget.course.groupCourse.description.curriculum,
          const Color(0xFFEC4899),
        ),

        // Description Card
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.description_outlined, color: Color(0xFFF97316)),
                  SizedBox(width: 12),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.course.groupCourse.description.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value,
    Color color, {
    bool hasDownload = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: hasDownload
                                ? color
                                : const Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasDownload) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.file_download_outlined,
                          color: color,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKontenTab() {
    if (_isLoadingContent) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.grey)),
            TextButton(
              onPressed: _fetchCourseContents,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (_sections == null || _sections!.isEmpty) {
      return const Center(child: Text("Belum ada konten kursus."));
    }

    return Column(
      children: [
        // Content Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Color(0xFFC2410C)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kurikulum Kursus",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_sections!.length} bagian",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        ..._sections!.map((section) {
          // Sort contents by sequence ASC
          final sortedContents = List<ContentModel>.from(section.listContent)
            ..sort((a, b) => a.sequence.compareTo(b.sequence));

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildCourseSection(
              section.sequence.toString(),
              section.name,
              section.description,
              sortedContents,
              isExpanded: section.sequence == 1, // Expand first item by default
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCourseSection(
    String number,
    String title,
    String subtitle,
    List<ContentModel> items, {
    bool isExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF97316)),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Color(0xFFF97316),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF64748B),
                ),
              ],
            ),
          ),
          if (isExpanded && items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: items.map((item) => _buildSectionItem(item)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionItem(ContentModel content) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Icon(
            content.type == 'PDF'
                ? Icons.picture_as_pdf_outlined
                : Icons.lock_outline,
            color: const Color(0xFFCBD5E1),
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content.name,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingTab() {
    return Column(
      children: [
        // Summary Card
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Rating dan Ulasan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.course.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < widget.course.rating
                        ? Icons.star
                        : Icons.star_border,
                    color: index < widget.course.rating
                        ? Colors.orange
                        : const Color(0xFFCBD5E1),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Rating Kursus",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "(${widget.course.totalUserRating} ratings)",
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }
}
