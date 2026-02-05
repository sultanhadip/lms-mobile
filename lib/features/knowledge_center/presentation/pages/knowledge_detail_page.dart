import 'package:flutter/material.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';

class KnowledgeDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;
  const KnowledgeDetailPage({super.key, required this.item});

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 140), // Space for AppBar
                // Back and Share Actions
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),

                // Hero Image
                Container(
                  width: double.infinity,
                  height: 250,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.item['image'] ??
                            "https://images.unsplash.com/photo-1590283603385-17ffb3a7f29f?auto=format&fit=crop&q=80&w=800",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Content Padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-header metadata
                      Row(
                        children: [
                          _tag(widget.item['type']?.toUpperCase() ?? "ARTICLE"),
                          _dot(),
                          _metaText("sekitar 1 bulan yang lalu"),
                          _dot(),
                          _metaText(widget.item['category'] ?? "Ekonomi"),
                          _dot(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _metaText("${widget.item['views'] ?? 15} views"),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        widget.item['title'] ??
                            "Mengenal Ilmu Ekonomi: Konsep Dasar, Ruang Lingkup, dan Penerapannya",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Author Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Falana Rofako Hakam",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  widget.item['source'] ??
                                      "Pusat Pendidikan dan Pelatihan",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),

                      // Intro Text
                      Text(
                        widget.item['snippet'] ??
                            "Artikel ini bertujuan memberikan pemahaman dasar mengenai ilmu ekonomi, mulai dari konsep utama, ruang lingkup kajiannya, hingga penerapannya dalam kehidupan sehari-hari.",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF475569),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Metadata Cards
                      _infoCard(
                        Icons.insert_drive_file_outlined,
                        "Knowledge Type",
                        "Content - ${widget.item['type'] ?? "ARTICLE"}",
                      ),
                      _infoCard(
                        Icons.book_outlined,
                        "Subject",
                        widget.item['category'] ?? "Ekonomi",
                      ),
                      _infoCard(
                        Icons.group_outlined,
                        "Organizer",
                        widget.item['source'] ??
                            "Pusat Pendidikan dan Pelatihan",
                      ),
                      _infoCard(
                        Icons.calendar_today_outlined,
                        "Published",
                        "24 Desember 2025, 07.44 WIB",
                      ),

                      const SizedBox(height: 24),

                      // Footer Interactions
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${widget.item['likes'] ?? 1}",
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Icon(
                            Icons.visibility,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${widget.item['views'] ?? 15}",
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // Body Content
                      _sectionTitle("Pendahuluan"),
                      _sectionParagraph(
                        "Ilmu ekonomi menjadi salah satu disiplin penting dalam memahami bagaimana individu, masyarakat, dan negara mengelola sumber daya yang terbatas untuk memenuhi kebutuhan yang tidak terbatas. Hampir setiap keputusan, baik pada tingkat pribadi maupun kebijakan publik, memiliki dimensi ekonomi. Oleh karena itu, pemahaman dasar tentang ekonomi sangat relevan bagi siapa saja.",
                      ),

                      _sectionTitle("Pembahasan"),
                      _sectionParagraph(
                        "Ilmu ekonomi mempelajari perilaku manusia dalam memilih dan menggunakan sumber daya yang terbatas untuk mencapai tujuan tertentu. Konsep dasar seperti kebutuhan, kelangkaan, pilihan, dan biaya peluang menjadi fondasi utama dalam analisis ekonomi.\n\nIlmu ekonomi secara umum terbagi menjadi ekonomi mikro dan makro. Ekonomi mikro berfokus pada perilaku agen ekonomi individu seperti konsumen dan perusahaan, sedangkan ekonomi makro mencakup fenomena ekonomi yang lebih luas seperti inflasi, pertumbuhan ekonomi, dan pengangguran.",
                      ),

                      _sectionTitle("Kesimpulan"),
                      _sectionParagraph(
                        "Ilmu ekonomi memberikan kerangka berpikir untuk memahami berbagai fenomena sosial dan ekonomi yang terjadi di sekitar kita. Dengan memahami konsep dasar, ruang lingkup, dan penerapannya, pembaca dapat membuat keputusan yang lebih bijak. Langkah selanjutnya adalah memperdalam pemahaman ekonomi agar mampu menganalisis permasalahan secara lebih kritis dan komprehensif.",
                      ),

                      _sectionTitle("Referensi"),
                      _bulletPoint("Mankiw, N. G. Principles of Economics."),
                      _bulletPoint(
                        "Samuelson, P. A., & Nordhaus, W. D. Economics.",
                      ),
                      _bulletPoint(
                        "https://www.investopedia.com/economics-4689801",
                      ),

                      const SizedBox(height: 48),

                      // Tags
                      const Text(
                        "Tags",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          _tagChip("#artikel ekonomi"),
                          _tagChip("#dasar"),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // Related Content
                      const Text(
                        "Related Content",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _relatedCard(),

                      const SizedBox(height: 40),
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
              color: _isScrolled ? Colors.white : Colors.white,
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

  Widget _tag(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _dot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text("•", style: TextStyle(color: Color(0xFF94A3B8))),
    );
  }

  Widget _metaText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF64748B)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _sectionParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF475569),
        height: 1.6,
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontSize: 15, color: Color(0xFF475569)),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _relatedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
            child: Stack(
              children: [
                Image.network(
                  "https://images.unsplash.com/photo-1454165833767-027ffea9e778?auto=format&fit=crop&q=80&w=800",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.video_call, size: 14, color: Colors.purple),
                        SizedBox(width: 4),
                        Text(
                          "Webinar",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Ekonomi",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Webinar Pengantar Makro Ekonomi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Webinar Pengantar Makro Ekonomi bertujuan memberikan pemahaman dasar mengenai konsep dan kerangka berpikir dalam...",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Selesai",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "1",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.thumb_up_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "0",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Text(
                      "Pusat Pendidikan dan Pelatihan",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
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
