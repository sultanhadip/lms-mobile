import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/theme/app_text_styles.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/core/widgets/app_menu.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _activeCategory = "Semua Topik";

  final List<String> _categories = [
    "Semua Topik",
    "Umum",
    "Kursus & Pembelajaran",
  ];

  final List<Map<String, String>> _faqs = [
    {
      "question": "Apa itu E-Warkop?",
      "answer":
          "E-Warkop adalah platform E-Learning resmi Pusdiklat BPS RI yang dirancang untuk mengakselerasi kompetensi SDM melalui inovasi pembelajaran digital terintegrasi.",
    },
    {
      "question": "Siapa yang bisa menggunakan E-Warkop?",
      "answer":
          "Seluruh pegawai BPS RI dan mitra statistik yang terdaftar dapat menggunakan platform ini untuk meningkatkan kompetensi mereka.",
    },
    {
      "question": "Apakah E-Warkop bisa diakses melalui mobile?",
      "answer":
          "Ya, E-Warkop didesain secara responsif dan dapat diakses melalui browser di perangkat mobile Anda dengan nyaman.",
    },
    {
      "question": "Bagaimana cara mendaftar kursus?",
      "answer":
          "Anda dapat membuka menu Katalog Kursus, pilih kursus yang diminati, lalu klik tombol 'Daftar Sekarang'.",
    },
    {
      "question": "Apakah ada batas waktu untuk menyelesaikan kursus?",
      "answer":
          "Setiap kursus memiliki kebijakan waktu yang berbeda-beda. Detail batas waktu dapat dilihat pada informasi kursus masing-masing.",
    },
    {
      "question": "Bagaimana cara mendapatkan sertifikat?",
      "answer":
          "Sertifikat akan tersedia secara otomatis setelah Anda menyelesaikan seluruh materi dan lulus ujian akhir kursus (jika ada).",
    },
    {
      "question": "Apakah saya bisa mengulang kursus yang sudah selesai?",
      "answer":
          "Ya, materi kursus yang telah diselesaikan tetap dapat diakses kembali untuk dipelajari ulang kapan saja.",
    },
  ];

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
                // SECTION 1: Header & Search
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Bagaimana kami dapat membantu Anda?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Cari jawaban cepat seputar penggunaan platform, manajemen akun, dan kendala teknis lainnya.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText:
                                "Cari pertanyaan (misal: sertifikat, login)...",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[100]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[100]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // SECTION 2: Filters & Accordion
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Filters
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isActive = cat == _activeCategory;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _activeCategory = cat),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primaryOrange
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.primaryOrange
                                        : Colors.grey[200]!,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : const Color(0xFF64748B),
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // FAQ List (Expansion Panels)
                      ..._faqs.map(
                        (faq) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          child: Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text(
                                faq['question']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: Text(
                                    faq['answer']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // SECTION 3: Support
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 60,
                  ),
                  color: Colors.white.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      const Text(
                        "Masih butuh bantuan?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Tim support kami siap membantu Anda menyelesaikan masalah yang tidak tercantum di atas.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText,
                      ),
                      const SizedBox(height: 40),

                      // Contact Cards
                      _buildContactCard(
                        icon: Icons.email_outlined,
                        iconColor: Colors.orange,
                        title: "Email Support",
                        subtitle: "support@ewarkop.bps.go.id",
                      ),
                      const SizedBox(height: 16),
                      _buildContactCard(
                        icon: Icons.phone_outlined,
                        iconColor: Colors.green,
                        title: "Call Center",
                        subtitle: "(021) 3841195",
                      ),
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

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
