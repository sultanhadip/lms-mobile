import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../pages/admin_dashboard_page.dart';
import '../pages/master_courses_page.dart';
import '../pages/course_list_page.dart';
import '../pages/settings_page.dart';
import '../pages/activity_logs_page.dart';
import '../pages/log_categories_page.dart';
import '../pages/subjects_page.dart';
import '../pages/log_types_page.dart';
import '../pages/knowledge_analysis_page.dart';
import '../pages/my_knowledge_page.dart';
import '../pages/knowledge_list_page.dart';

class AdminSidebar extends StatefulWidget {
  final String activeMenu;
  const AdminSidebar({super.key, this.activeMenu = "Dashboard"});

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  // Expansion states
  bool _isKursusExpanded = true;
  bool _isPusatPengetahuanExpanded = true;
  bool _isAktivitasLogsExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Logo & Theme Toggle
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
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
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "E-Warkop",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            "Admin Panel",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.dark_mode_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "MAIN",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _sidebarItem(
                    Icons.grid_view,
                    "Dashboard",
                    isActive: widget.activeMenu == "Dashboard",
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardPage(),
                      ),
                    ),
                  ),

                  // KURSUS
                  _sidebarItem(
                    Icons.school_outlined,
                    "Kursus",
                    hasTrailing: true,
                    isExpanded: _isKursusExpanded,
                    onTap: () =>
                        setState(() => _isKursusExpanded = !_isKursusExpanded),
                  ),
                  if (_isKursusExpanded) ...[
                    _sidebarSubItem(
                      "Kursus Induk",
                      isActive: widget.activeMenu == "Kursus Induk",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MasterCoursesPage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem(
                      "Daftar Kursus",
                      isActive: widget.activeMenu == "Daftar Kursus",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CourseListPage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem("Kelola", isCategoryHeader: true),
                  ],

                  // PUSAT PENGETAHUAN
                  _sidebarItem(
                    Icons.library_books_outlined,
                    "Pusat Pengetahuan",
                    hasTrailing: true,
                    isExpanded: _isPusatPengetahuanExpanded,
                    onTap: () => setState(
                      () => _isPusatPengetahuanExpanded =
                          !_isPusatPengetahuanExpanded,
                    ),
                  ),
                  if (_isPusatPengetahuanExpanded) ...[
                    _sidebarSubItem(
                      "Daftar Pengetahuan",
                      isActive: widget.activeMenu == "Daftar Pengetahuan",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KnowledgeListPage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem(
                      "Pengetahuan Saya",
                      isActive: widget.activeMenu == "Pengetahuan Saya",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyKnowledgePage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem("Kelola", isCategoryHeader: true),
                    _sidebarSubItem(
                      "Subjek",
                      isActive: widget.activeMenu == "Subjek",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubjectsPage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem(
                      "Analisis",
                      isActive: widget.activeMenu == "Analisis",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KnowledgeAnalysisPage(),
                        ),
                      ),
                    ),
                  ],

                  // AKTIVITAS LOGS
                  _sidebarItem(
                    Icons.bar_chart,
                    "Aktivitas Logs",
                    hasTrailing: true,
                    isExpanded: _isAktivitasLogsExpanded,
                    onTap: () => setState(
                      () =>
                          _isAktivitasLogsExpanded = !_isAktivitasLogsExpanded,
                    ),
                  ),
                  if (_isAktivitasLogsExpanded) ...[
                    _sidebarSubItem(
                      "Data",
                      isActive: widget.activeMenu == "Data Log",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ActivityLogsPage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem(
                      "Kategori Log",
                      isActive: widget.activeMenu == "Kategori Log",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogCategoriesPage(),
                        ),
                      ),
                    ),
                    _sidebarSubItem(
                      "Tipe Log",
                      isActive: widget.activeMenu == "Tipe Log",
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogTypesPage(),
                        ),
                      ),
                    ),
                  ],

                  _sidebarItem(
                    Icons.settings_outlined,
                    "Pengaturan",
                    isActive: widget.activeMenu == "Pengaturan",
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Profile
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF334155),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            "SH",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sultan",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              "prabowoshad...",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _iconButton(
                        Icons.home_outlined,
                        Colors.orange,
                        const Color(0xFFFFF7ED),
                      ),
                      const SizedBox(width: 8),
                      _iconButton(
                        Icons.exit_to_app_rounded,
                        Colors.redAccent,
                        const Color(0xFFFEF2F2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.assignment_ind_outlined,
                              size: 14,
                              color: Color(0xFF64748B),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Superadmin",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _sidebarItem(
    IconData icon,
    String title, {
    bool isActive = false,
    bool hasTrailing = false,
    bool isExpanded = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryOrange : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : const Color(0xFF64748B),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontSize: 14,
            fontWeight: (isActive || isExpanded)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        trailing: hasTrailing
            ? Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: (isActive || isExpanded)
                    ? (isActive ? Colors.white : const Color(0xFF1E293B))
                    : const Color(0xFF64748B),
                size: 16,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _sidebarSubItem(
    String title, {
    bool isActive = false,
    bool isCategoryHeader = false,
    VoidCallback? onTap,
  }) {
    if (isCategoryHeader) {
      return Padding(
        padding: const EdgeInsets.only(left: 48, top: 12, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // The curved connector line
        Positioned(
          left: 28,
          top: 0,
          bottom: 0,
          child: CustomPaint(
            painter: SubMenuLinePainter(
              isLast: false,
            ), // In real implementation, would detect if last
            size: const Size(20, 48),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, bottom: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            dense: true,
            title: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

class SubMenuLinePainter extends CustomPainter {
  final bool isLast;
  SubMenuLinePainter({required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Vertical line
    path.moveTo(0, 0);
    path.lineTo(0, size.height * (isLast ? 0.5 : 1.0));

    // Curved branch
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(0, size.height * 0.5, 12, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
