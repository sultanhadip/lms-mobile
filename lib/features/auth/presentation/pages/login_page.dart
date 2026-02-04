import 'package:flutter/material.dart';
import 'package:next/core/theme/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F9FF), // Very light blue-ish
              Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // BPS Top Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBpsIcon(),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "BADAN PUSAT STATISTIK",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            "PUSAT PENDIDIKAN DAN PELATIHAN",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),

                  // Login Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 48,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // E-WARKOP Logo matching the image structure
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    Color(0xFFF97316),
                                    Color(0xFF22C55E),
                                    Color(0xFF3B82F6),
                                    Color(0xFFF97316),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.donut_large_rounded,
                                    color: Color(0xFFF97316),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "E-WARKOP",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: AppColors
                                    .primaryOrange, // Adjusted to theme orange
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Selamat datang, silakan login terlebih dahulu",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          "Dari mana anda berasal?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Green button from image, but let's use theme orange primary
                        _buildLoginButton(
                          onPressed: () {},
                          icon: Icons.business_rounded,
                          label: "Badan Pusat Statistik",
                          isPrimary: true,
                        ),
                        const SizedBox(height: 16),
                        _buildLoginButton(
                          onPressed: () {},
                          icon: Icons.language_rounded,
                          label: "Selain Badan Pusat Statistik",
                          isPrimary: false,
                        ),

                        const SizedBox(height: 48),
                        // Terms and Policy
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                                height: 1.6,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "Dengan mengakses dan menggunakan layanan kami, berarti anda telah menyetujui ",
                                ),
                                TextSpan(
                                  text: "Term of Services",
                                  style: TextStyle(
                                    color: AppColors.primaryOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: " dan "),
                                TextSpan(
                                  text: "Privacy Policies.",
                                  style: TextStyle(
                                    color: AppColors.primaryOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Back to Home
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text(
                            "Kembali ke Beranda",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                  // Bottom Logos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBerAkhlakLogo(),
                      const SizedBox(width: 32),
                      _buildBanggaMelayaniLogo(),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBpsIcon() {
    return Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Image.network(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Lambang_Badan_Pusat_Statistik_%28BPS%29_Indonesia.svg/1200px-Lambang_Badan_Pusat_Statistik_%28BPS%29_Indonesia.svg.png",
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.grid_view_rounded,
          color: Color(0xFF00A9E0), // BPS blue
          size: 20,
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange, // Using theme orange
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF475569),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 22, color: const Color(0xFF64748B)),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBerAkhlakLogo() {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Ber",
              style: TextStyle(
                color: Color(0xFFBE123C),
                fontWeight: FontWeight.w900,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              "AKHLAK",
              style: TextStyle(
                color: Color(0xFFBE123C),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Text(
          "Berorientasi Pelayanan Akuntabel Kompeten\nHarmonis Loyal Adaptif Kolaboratif",
          style: TextStyle(fontSize: 4, color: Color(0xFFBE123C)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBanggaMelayaniLogo() {
    return Row(
      children: [
        const Icon(
          Icons.volunteer_activism_rounded,
          color: Color(0xFFBE123C),
          size: 24,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "bangga",
              style: TextStyle(
                color: Color(0xFFBE123C),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                height: 0.9,
              ),
            ),
            Text(
              "melayani",
              style: TextStyle(
                color: Color(0xFFBE123C),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                height: 0.9,
              ),
            ),
            Text(
              "bangsa",
              style: TextStyle(
                color: Color(0xFFBE123C),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                height: 0.9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
