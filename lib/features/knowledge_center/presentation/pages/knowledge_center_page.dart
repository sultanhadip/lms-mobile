import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/widgets/app_menu.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/knowledge_card.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/features/knowledge_center/presentation/pages/knowledge_detail_page.dart';
import 'package:next/features/knowledge_center/data/services/knowledge_service.dart';
import 'package:next/features/knowledge_center/data/models/knowledge_stats_model.dart';
import 'package:next/features/knowledge_center/data/models/knowledge_subject_model.dart';
import 'package:next/features/knowledge_center/data/models/knowledge_content_model.dart';

class KnowledgeCenterPage extends StatefulWidget {
  const KnowledgeCenterPage({super.key});

  @override
  State<KnowledgeCenterPage> createState() => _KnowledgeCenterPageState();
}

class _KnowledgeCenterPageState extends State<KnowledgeCenterPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _activeTab = "Semua";
  bool _showAllSubjects = false;
  String _selectedSort = "Terbaru";

  // Stats
  final KnowledgeService _knowledgeService = KnowledgeService();
  KnowledgeStatsModel? _stats;
  bool _isLoadingStats = true;

  // Subjects
  List<KnowledgeSubjectModel> _subjectsList = [];
  bool _isLoadingSubjects = true;

  // Knowledge List
  List<KnowledgeContentModel> _knowledgeList = [];
  bool _isLoadingKnowledge = true;

  // Trending List
  List<KnowledgeContentModel> _trendingList = [];
  bool _isLoadingTrending = true;

  final List<String> _tabs = ["Semua", "Webinars", "Konten"];

  // Replaced static _subjects with _subjectsList logic

  Future<void> _fetchStats() async {
    try {
      final response = await _knowledgeService.getKnowledgeStats();
      if (response.success) {
        setState(() {
          _stats = response.data;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching stats: $e");
      setState(() => _isLoadingStats = false);
    }
  }

  Future<void> _fetchSubjects() async {
    try {
      final response = await _knowledgeService.getKnowledgeSubjects();
      if (response.success) {
        final sortedList = List<KnowledgeSubjectModel>.from(response.data);
        sortedList.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );

        setState(() {
          _subjectsList = sortedList;
          _isLoadingSubjects = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching subjects: $e");
      setState(() => _isLoadingSubjects = false);
    }
  }

  Future<void> _fetchKnowledgeList() async {
    try {
      final response = await _knowledgeService.getKnowledgeList(
        page: 1,
        perPage: 12,
        orderBy: 'createdAt',
      );
      if (response.success) {
        setState(() {
          _knowledgeList = response.data;
          _isLoadingKnowledge = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching knowledge list: $e");
      setState(() => _isLoadingKnowledge = false);
    }
  }

  Future<void> _fetchTrendingList() async {
    try {
      final response = await _knowledgeService.getKnowledgeList();
      if (response.success) {
        setState(() {
          _trendingList = response.data;
          _isLoadingTrending = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching trending list: $e");
      setState(() => _isLoadingTrending = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _fetchSubjects();
    _fetchKnowledgeList();
    _fetchTrendingList();
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
                _buildHeaderSection(),
                _buildStatsGrid(),
                _buildSubjectBrowser(),
                _buildContentList(),
                _buildPaginationFooter(),
                const SizedBox(height: 40),
                _buildUpcomingWebinars(),
                const SizedBox(height: 40),
                _buildTrendingKnowledge(),
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

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 14, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "Selamat Datang di Knowledge Center",
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Pusat Pengetahuan",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF7C2D12),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Pusat pembelajaran dan berbagi pengetahuan untuk Badan Pusat Statistik |",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildMiniInfoCard(
                  icon: Icons.grid_view_rounded,
                  iconColor: Colors.orange,
                  label: "Total Subjek",
                  value: "8 Subjek",
                  bgColor: const Color(0xFFFFF7ED),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMiniInfoCard(
                  icon: Icons.auto_stories_outlined,
                  iconColor: Colors.green,
                  label: "Format",
                  value: "Video, PDF, Audio",
                  bgColor: const Color(0xFFF0FDF4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari materi...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: _tabs.map((tab) {
              final isActive = tab == _activeTab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _activeTab = tab),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFD84B16) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? Colors.transparent
                            : Colors.grey[100]!,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tab == "Semua"
                              ? Icons.grid_view
                              : (tab == "Webinars"
                                    ? Icons.calendar_today_outlined
                                    : Icons.menu_book_outlined),
                          size: 16,
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tab,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    if (_isLoadingStats) {
      return const Center(child: CircularProgressIndicator());
    }

    final stats =
        _stats ??
        KnowledgeStatsModel(
          totalKnowledge: 0,
          totalWebinars: 0,
          totalViews: 0,
          totalLikes: 0,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        children: [
          _buildStatVerticalCard(
            count: stats.totalKnowledge.toString(),
            label: "Total Konten",
            icon: Icons.menu_book_outlined,
            bgColor: const Color(0xFFF97316),
            isFullColor: true,
          ),
          _buildStatVerticalCard(
            count: stats.totalWebinars.toString(),
            label: "Total Webinar",
            icon: Icons.people_outline,
            bgColor: const Color(0xFFF0FDF4),
            indicatorColor: const Color(0xFF22C55E),
          ),
          _buildStatVerticalCard(
            count: stats.totalViews.toString(),
            label: "Total Dilihat",
            icon: Icons.visibility_outlined,
            bgColor: const Color(0xFFFDF4FF),
            indicatorColor: const Color(
              0xFF10B981,
            ), // Fixed color to match request/design if needed or keep green
          ),
          _buildStatVerticalCard(
            count: stats.totalLikes.toString(),
            label: "Total Disukai",
            icon: Icons.thumb_up_outlined,
            bgColor: const Color(0xFFFFF7ED),
            indicatorColor: const Color(0xFFF97316),
          ),
        ],
      ),
    );
  }

  Widget _buildStatVerticalCard({
    required String count,
    required String label,
    required IconData icon,
    required Color bgColor,
    Color? indicatorColor,
    bool isFullColor = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 90,
      decoration: BoxDecoration(
        color: isFullColor ? bgColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isFullColor ? null : Border.all(color: bgColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color:
                    (isFullColor ? Colors.white : (indicatorColor ?? bgColor))
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isFullColor
                        ? Colors.white.withValues(alpha: 0.2)
                        : (indicatorColor ?? bgColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isFullColor
                            ? Colors.white
                            : (indicatorColor ?? const Color(0xFF1E293B)),
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isFullColor
                            ? Colors.white.withValues(alpha: 0.8)
                            : const Color(0xFF64748B),
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

  Widget _buildSubjectBrowser() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 20, color: Colors.orange),
              const SizedBox(width: 12),
              const Text(
                "Telusuri Berdasarkan Subjek",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari subjek...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_view, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Semua Subjek",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _isLoadingSubjects
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: _subjectsList
                      .take(_showAllSubjects ? _subjectsList.length : 2)
                      .map((s) => _buildSubjectBtn(s.name, _getIcon(s.icon)))
                      .toList(),
                ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _showAllSubjects = !_showAllSubjects),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _showAllSubjects
                          ? "Tampilkan Lebih Sedikit"
                          : "Tampilkan Lebih Banyak",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showAllSubjects
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.orange,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBtn(String name, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 16),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'file-check':
        return Icons.description_outlined;
      case 'brain-circuit':
        return Icons.psychology_outlined;
      case 'circle-dollar-sign':
        return Icons.monetization_on_outlined;
      case 'users':
        return Icons.people_outline;
      case 'computer':
        return Icons.computer_outlined;
      case 'sprout':
        return Icons.eco_outlined;
      case 'message-square-code':
        return Icons.chat_bubble_outline;
      case 'baby':
        return Icons.child_care;
      default:
        return Icons.grid_view;
    }
  }

  Widget _buildContentList() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Semua Materi",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "8 item ditemukan",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari materi...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRealDropdown(
            value: _selectedSort,
            items: ["Terbaru", "Paling Disukai", "Terpopuler"],
            onChanged: (val) {
              setState(() => _selectedSort = val!);
            },
          ),
          const SizedBox(height: 24),
          if (_isLoadingKnowledge)
            const Center(child: CircularProgressIndicator())
          else if (_knowledgeList.isEmpty)
            const Center(child: Text("Belum ada materi."))
          else
            ..._knowledgeList.map(
              (item) => KnowledgeCard(
                item: {
                  'title': item.title,
                  'snippet': item.description,
                  'type': item.type,
                  'category': item
                      .subject, // Using subject as category badge as requested/inferred
                  'views': item.viewCount,
                  'likes': item.likeCount,
                  'source': item.penyelenggara,
                  'image': item.thumbnail,
                  'contentType': item.contentType,
                },
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KnowledgeDetailPage(
                      item: {
                        'title': item.title,
                        'snippet': item.description,
                        'type': item.type,
                        'category': item.subject,
                        'views': item.viewCount,
                        'likes': item.likeCount,
                        'source': item.penyelenggara,
                        'image': item.thumbnail,
                      },
                    ), // You might want to pass the actual model to detail page too eventually
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

  Widget _buildPaginationFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          const Text(
            "Menampilkan 1 sampai 8 dari 8 Pengetahuan",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tampilkan:",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Row(
                  children: [
                    Text(
                      "12",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Colors.grey,
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

  Widget _buildUpcomingWebinars() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Text(
                "Acara Mendatang",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Webinar Mendatang",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C2D12),
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Ikuti webinar terbaru dan tingkatkan pengetahuan Anda",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 40,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Belum Ada Webinar Terjadwal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Saat ini tidak ada webinar yang dijadwalkan. Pantau terus halaman ini untuk update webinar mendatang.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Jelajahi Semua Konten",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingKnowledge() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF7ED).withValues(
        alpha: 0.3,
      ), // Light orange background for the entire section
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.trending_up, size: 14, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  "Paling Populer",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              // Decorative Diamond
              Transform.rotate(
                angle: 0.785398, // 45 degrees
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFED7AA).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Text(
                "Pengetahuan Trending",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C2D12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Temukan materi yang paling disukai oleh komunitas kami",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ),
          const SizedBox(height: 40),

          if (_isLoadingTrending)
            const Center(child: CircularProgressIndicator())
          else if (_trendingList.isEmpty)
            const Center(child: Text("Belum ada materi trending."))
          else
            SizedBox(
              height: 420, // Adjusted height for cards
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: _trendingList.length,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = _trendingList[index];
                  return SizedBox(
                    width:
                        300, // Slightly wider as per image suggestion potentially
                    child: KnowledgeCard(
                      item: {
                        'title': item.title,
                        'snippet': item.description,
                        'type': item.type,
                        'category': item.subject,
                        'views': item.viewCount,
                        'likes': item.likeCount,
                        'source': item.penyelenggara,
                        'image': item.thumbnail,
                        'contentType': item.contentType,
                      },
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KnowledgeDetailPage(
                            item: {
                              'title': item.title,
                              'snippet': item.description,
                              'type': item.type,
                              'category': item.subject,
                              'views': item.viewCount,
                              'likes': item.likeCount,
                              'source': item.penyelenggara,
                              'image': item.thumbnail,
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
