import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import '../widgets/admin_sidebar.dart';
import 'package:next/features/courses/data/services/course_service.dart';
import 'package:next/features/courses/data/models/log_stats_model.dart';
import 'package:next/features/courses/data/models/activity_log_model.dart';
import 'package:intl/intl.dart';

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 1;
  final int _rowsPerPage = 25;

  final CourseService _courseService = CourseService();
  LogStats? _logStats;
  List<ActivityLog> _logs = [];
  PageMeta? _pageMeta;
  bool _isLoadingStats = true;
  bool _isLoadingLogs = true;

  @override
  void initState() {
    super.initState();
    _fetchLogStats();
    _fetchActivityLogs(1); // Fetch first page
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  Future<void> _fetchLogStats() async {
    try {
      final response = await _courseService.getLogStats();
      if (response.success && mounted) {
        setState(() {
          _logStats = response.data;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching log stats: $e");
      if (mounted) setState(() => _isLoadingStats = false);
    }
  }

  Future<void> _fetchActivityLogs(int page) async {
    setState(() => _isLoadingLogs = true);
    try {
      final response = await _courseService.getActivityLogs(
        page: page,
        perPage: _rowsPerPage,
      );
      if (response.success && mounted) {
        setState(() {
          _logs = response.data;
          _pageMeta = response.pageMeta;
          _currentPage = page;
          _isLoadingLogs = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching logs: $e");
      if (mounted) setState(() => _isLoadingLogs = false);
    }
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat("d MMM y, HH.mm.ss 'WIB'").format(date);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalLogs = _pageMeta?.totalResultCount ?? 0;
    int totalPages = _pageMeta?.totalPageCount ?? 1;
    int startIndex = _pageMeta?.showingFrom ?? 0;
    int endIndex = _pageMeta?.showingTo ?? 0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AdminSidebar(activeMenu: "Data Log"),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

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
                              "Data Log Aktivitas",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Pantau dan analisis aktivitas pengguna di seluruh platform",
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

                // Activity Summary Metrics
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ringkasan Aktivitas",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Metrik aktivitas sistem secara real-time",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Terakhir diperbarui:",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "08.46.42",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1E293B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_isLoadingStats)
                        const Center(child: CircularProgressIndicator())
                      else
                        Column(
                          children: [
                            _buildSummaryMetricCard(
                              "Total Log",
                              "${_logStats?.totalLogs ?? 0}",
                              Icons.bar_chart,
                              const Color(0xFFFFF7ED),
                              const Color(0xFFF97316),
                            ),
                            _buildSummaryMetricCard(
                              "Hari Ini",
                              "${_logStats?.todayCount ?? 0}",
                              Icons.calendar_today_outlined,
                              const Color(0xFFECFEFF),
                              const Color(0xFF06B6D4),
                            ),
                            _buildSummaryMetricCard(
                              "Minggu Ini",
                              "${_logStats?.weekCount ?? 0}",
                              Icons.show_chart,
                              const Color(0xFFFDF2F8),
                              const Color(0xFFEC4899),
                            ),
                            _buildSummaryMetricCard(
                              "Pengguna Aktif",
                              "${_logStats?.activeUsers ?? 0}",
                              Icons.people_outline,
                              const Color(0xFFF0FDF4),
                              const Color(0xFF22C55E),
                            ),
                            _buildSummaryMetricCard(
                              "Start Task", // Actually 'Most Active' label
                              _logStats?.mostActive ?? "N/A",
                              Icons.trending_up,
                              const Color(0xFFFFF7ED),
                              const Color(0xFFF97316),
                              isCustomValue: true,
                              titleOverride: "Paling Aktif",
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Log Table Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Log Aktivitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalLogs total log",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _actionButton(
                            Icons.filter_alt_outlined,
                            "Filter",
                            Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          _actionButton(
                            Icons.file_download_outlined,
                            "Ekspor",
                            Colors.white,
                            bgColor: const Color(0xFFF97316),
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Table Headers
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            _tableHeader(
                              Icons.calendar_today_outlined,
                              "WAKTU",
                              true,
                            ),
                            _tableHeader(Icons.bolt_outlined, "TIPE", true),
                            _tableHeader(Icons.label_outline, "KATEGORI", true),
                          ],
                        ),
                      ),

                      // Table Data
                      if (_isLoadingLogs)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_logs.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: const Center(
                            child: Text("Tidak ada data log."),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(color: Colors.grey[200]!),
                              right: BorderSide(color: Colors.grey[200]!),
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: _logs
                                .map((log) => _buildLogRow(log))
                                .toList(),
                          ),
                        ),

                      // Advanced Pagination
                      _buildAdvancedPagination(
                        totalPages,
                        totalLogs,
                        startIndex,
                        endIndex,
                      ),
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

  Widget _buildSummaryMetricCard(
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    bool isCustomValue = false,
    String? titleOverride,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: isCustomValue ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: isCustomValue
                  ? const Color(0xFFF97316)
                  : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titleOverride ?? title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color color, {
    Color? bgColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: textColor ?? color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor ?? color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(IconData icon, String label, bool hasSort) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          if (hasSort) ...[
            const SizedBox(width: 4),
            const Icon(Icons.swap_vert, size: 14, color: Color(0xFFCBD5E1)),
          ],
        ],
      ),
    );
  }

  Widget _buildLogRow(ActivityLog log) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[50]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatDate(log.timestamp),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Row(
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
                    log.logTypeName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    log.categoryLogTypeName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF97316),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedPagination(
    int totalPages,
    int totalLogs,
    int from,
    int to,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            "Menampilkan $from sampai $to dari $totalLogs Log",
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pagerButton(
                const Icon(Icons.chevron_left, size: 18),
                false,
                isDisabled: !_pageMeta!.hasPrev,
                onTap: () => _fetchActivityLogs(_currentPage - 1),
              ),
              const SizedBox(width: 8),
              _pagerButton(
                Text(
                  "$_currentPage",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                true, // Always active for current page
              ),
              const SizedBox(width: 8),
              _pagerButton(
                const Icon(Icons.chevron_right, size: 18),
                false,
                isDisabled: !_pageMeta!.hasNext,
                onTap: () => _fetchActivityLogs(_currentPage + 1),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tampilkan:",
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Text(
                      "$_rowsPerPage",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pagerButton(
    Widget content,
    bool isActive, {
    bool isDisabled = false,
    VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: (isDisabled || isActive) ? null : onTap,
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
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF1E293B),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
