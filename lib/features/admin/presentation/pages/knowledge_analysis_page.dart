import 'package:flutter/material.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import '../widgets/admin_sidebar.dart';

class KnowledgeAnalysisPage extends StatefulWidget {
  const KnowledgeAnalysisPage({super.key});

  @override
  State<KnowledgeAnalysisPage> createState() => _KnowledgeAnalysisPageState();
}

class _KnowledgeAnalysisPageState extends State<KnowledgeAnalysisPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AdminSidebar(activeMenu: "Analisis"),
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
                              "Analisis Pengetahuan",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Lihat statistik dan analisis knowledge center",
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

                // Overview Section
                _buildSectionTitle("Overview"),
                _buildMetricCard(
                  "Total Knowledge Centers",
                  "16",
                  Icons.bar_chart,
                  const Color(0xFFFFF7ED),
                  const Color(0xFFF97316),
                ),
                _buildMetricCard(
                  "Published",
                  "16",
                  Icons.description_outlined,
                  const Color(0xFFF0FDF4),
                  const Color(0xFF22C55E),
                ),
                _buildMetricCard(
                  "Scheduled",
                  "0",
                  Icons.calendar_today_outlined,
                  const Color(0xFFF5F3FF),
                  const Color(0xFF8B5CF6),
                ),
                _buildMetricCard(
                  "Draft",
                  "3",
                  Icons.insert_drive_file_outlined,
                  const Color(0xFFFFF7ED),
                  const Color(0xFFF97316),
                ),

                const SizedBox(height: 24),

                // Content Types Section
                _buildSectionTitle("Content Types"),
                _buildMetricCard(
                  "Webinars",
                  "8",
                  Icons.calendar_today_outlined,
                  const Color(0xFFF5F3FF),
                  const Color(0xFF8B5CF6),
                ),
                _buildMetricCard(
                  "Videos",
                  "0",
                  Icons.videocam_outlined,
                  const Color(0xFFFEF2F2),
                  const Color(0xFFEF4444),
                ),
                _buildMetricCard(
                  "PDF Documents",
                  "1",
                  Icons.insert_drive_file_outlined,
                  const Color(0xFFFFF7ED),
                  const Color(0xFFF97316),
                ),
                _buildMetricCard(
                  "Podcasts",
                  "1",
                  Icons.mic_none_outlined,
                  const Color(0xFFF0FDF4),
                  const Color(0xFF22C55E),
                ),
                _buildMetricCard(
                  "Articles",
                  "6",
                  Icons.insert_drive_file_outlined,
                  const Color(0xFFFFF7ED),
                  const Color(0xFFF97316),
                ),

                const SizedBox(height: 24),

                // Engagement Section
                _buildSectionTitle("Engagement"),
                _buildMetricCard(
                  "Total Likes",
                  "5",
                  Icons.thumb_up_alt_outlined,
                  const Color(0xFFF0FDF4),
                  const Color(0xFF22C55E),
                ),
                _buildMetricCard(
                  "Total Views",
                  "37",
                  Icons.visibility_outlined,
                  const Color(0xFFFFF7ED),
                  const Color(0xFFF97316),
                ),
                _buildMetricCard(
                  "Engagement Rate",
                  "13.5%",
                  Icons.trending_up,
                  const Color(0xFFF5F3FF),
                  const Color(0xFF8B5CF6),
                ),

                const SizedBox(height: 24),

                // Recent Activity Section
                _buildSectionTitle("Recent Activity"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Column(
                      children: [
                        _buildActivityItem(
                          title: "Mengenal Ilmu Ekonomi: ...",
                          time: "15 jam yang lalu",
                          tags: [
                            {"label": "Updated", "color": Colors.orange},
                            {"label": "Published", "color": Colors.green},
                          ],
                          views: 13,
                          likes: 1,
                          iconColor: const Color(0xFFF97316),
                        ),
                        _buildActivityItem(
                          title: "Mengenal Sistem Informa...",
                          time: "22 jam yang lalu",
                          tags: [
                            {"label": "Updated", "color": Colors.orange},
                            {"label": "Published", "color": Colors.green},
                          ],
                          views: 2,
                          likes: 1,
                          iconColor: const Color(0xFFF97316),
                        ),
                        _buildActivityItem(
                          title: "Artikel Uji Coba LMS NG",
                          time: "4 hari yang lalu",
                          tags: [
                            {"label": "Created", "color": Colors.teal},
                            {"label": "Published", "color": Colors.green},
                          ],
                          views: 0,
                          likes: 0,
                          iconColor: const Color(0xFF22C55E),
                        ),
                        _buildActivityItem(
                          title: "Webinar Pelatihan LMS NG",
                          time: "4 hari yang lalu",
                          tags: [
                            {"label": "Updated", "color": Colors.orange},
                            {"label": "Published", "color": Colors.green},
                          ],
                          views: 1,
                          likes: 0,
                          iconColor: const Color(0xFFF97316),
                        ),
                        _buildActivityItem(
                          title: "Artikel Komputer",
                          time: "4 hari yang lalu",
                          tags: [
                            {"label": "Deleted", "color": Colors.red},
                            {"label": "Published", "color": Colors.green},
                          ],
                          views: 0,
                          likes: 0,
                          isLast: true,
                          iconColor: const Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),

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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String time,
    required List<Map<String, dynamic>> tags,
    required int views,
    required int likes,
    required Color iconColor,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[50]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.insert_drive_file, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...tags.map(
                      (tag) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (tag['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: (tag['color'] as Color).withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          tag['label'],
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: tag['color'],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.visibility_outlined,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$views",
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$likes",
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
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
}
