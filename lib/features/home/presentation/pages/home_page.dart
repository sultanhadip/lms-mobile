import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';
import 'package:next/core/theme/app_text_styles.dart';
import 'package:next/core/widgets/custom_app_bar.dart';
import 'package:next/core/widgets/main_footer.dart';
import 'package:next/core/widgets/app_menu.dart';
import '../widgets/home_header_section.dart';
import '../widgets/course_section.dart';
import '../widgets/testimonial_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
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
                // TOP HEADER SECTION with Grid Background
                const HomeHeaderSection(),

                // NEW SECTIONS
                const SizedBox(height: 40),

                // Kursus Terbaru
                CourseSection(
                  title: "Kursus Terbaru",
                  subtitle:
                      "Temukan kursus-kursus terbaru yang dirancang khusus untuk meningkatkan kompetensi pegawai BPS. Materi pembelajaran yang up to date.",
                  courses: [
                    {
                      "title": "Pelatihan Subject Matter Survey Sensus",
                      "category": "Pelatihan Subject Matter Survey Sensus",
                      "image": "",
                    },
                    {
                      "title": "Pelatihan Sensus Ekonomi 2026 V",
                      "category": "Sensus Ekonomi",
                      "image": "",
                    },
                    {
                      "title": "Analisis Data Statistik Lanjutan",
                      "category": "Statistik",
                      "image": "",
                    },
                    {
                      "title": "Manajemen Data Besar untuk Pemerintah",
                      "category": "Big Data",
                      "image": "",
                    },
                  ],
                ),

                // Kursus Populer
                CourseSection(
                  title: "Kursus Populer",
                  subtitle:
                      "Jelajahi kursus-kursus pilihan yang paling diminati oleh pegawai BPS. Tingkatkan kompetensi Anda dengan materi berkualitas.",
                  courses: [
                    {
                      "title": "Pelatihan Sensus Ekonomi 2026 III",
                      "category": "Sensus Ekonomi",
                      "image": "",
                    },
                    {
                      "title": "Data Science Basic for Statistician",
                      "category": "Data Science",
                      "image": "",
                    },
                    {
                      "title": "Kepemimpinan Strategis di Era Digital",
                      "category": "Leadership",
                      "image": "",
                    },
                    {
                      "title": "Visualisasi Data Menggunakan Python",
                      "category": "Data Science",
                      "image": "",
                    },
                  ],
                ),

                const SizedBox(height: 40),

                // Testimonials
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text("Kata Mereka", style: AppTextStyles.sectionTitle),
                      Container(
                        width: 60,
                        height: 3,
                        margin: const EdgeInsets.only(top: 4, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Text(
                        "Pengalaman rekan-rekan yang telah bergabung",
                        style: AppTextStyles.sectionSubtitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const TestimonialCard(
                        name: "Budi Santoso",
                        role: "L&D Manager, PT Telkom Indonesia",
                        content:
                            "Platform E-Warkop sangat membantu dalam meningkatkan kompetensi karyawan kami. Interface yang intuitif membuat proses pembelajaran jadi lebih efektif.",
                      ),
                      const TestimonialCard(
                        name: "Siti Nurhaliza",
                        role: "HR Director, Bank Mandiri",
                        content:
                            "Materi yang disajikan sangat relevan dengan kebutuhan industri saat ini. Fitur AI learning path sangat membantu saya fokus pada skill yang dibutuhkan.",
                      ),
                      const TestimonialCard(
                        name: "Ahmad Wijaya",
                        role: "Training Manager, Pertamina",
                        content:
                            "Sangat merekomendasikan platform ini untuk siapa saja yang ingin upgrade skill. Kemudahan akses dan kualitas kontennya luar biasa.",
                      ),
                    ],
                  ),
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
              color: _isScrolled
                  ? Colors.white
                  : Colors.transparent, // Change color on scroll
              child: SafeArea(
                bottom: false,
                child: Container(
                  decoration: BoxDecoration(
                    border: _isScrolled
                        ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                        : null,
                    boxShadow: _isScrolled
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
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
}
