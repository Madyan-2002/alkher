import 'package:flutter/material.dart';
import 'package:alkher/screens/user/buy_screen.dart';
import 'package:alkher/screens/user/donation_screen.dart';
import 'package:alkher/screens/user/jobs_screen.dart';
import 'package:alkher/styles/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // استخدام لون الخلفية الموحد
      body: SafeArea(
        top: false, // يمنح الهيدر مظهراً ممتداً خلف الـ Status Bar
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: GridView(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.90,
                  ),
                  children: [
                    _Tile(
                      title: "التبرعات",
                      subtitle: "استعرض التبرعات",
                      icon: Icons.volunteer_activism_rounded,
                      colors: AppColors
                          .primaryGradient, // التدرج الرئيسي الكامل من ملفك
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DonationScreen(),
                        ),
                      ),
                    ),
                    _Tile(
                      title: "الشراء",
                      subtitle: "تصفح المنتجات",
                      icon: Icons.shopping_bag_rounded,
                      colors: const [
                        AppColors.primaryDark,
                        AppColors.primary, // تدرج داكن فخم
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BuyScreen()),
                      ),
                    ),
                    _Tile(
                      title: "الوظائف",
                      subtitle: "استعرض الفرص",
                      icon: Icons.business_center_rounded,
                      colors: const [
                        AppColors.primary,
                        AppColors.secondary, // تدرج حيوي متوسط
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const JobsScreen()),
                      ),
                    ),
                    _Tile(
                      title: "الاستكشاف",
                      subtitle: "كل الأقسام",
                      icon: Icons.explore_rounded,
                      colors: const [
                        AppColors.secondary,
                        AppColors.accent, // تدرج فاتح ومريح
                      ],
                      onTap: () {
                        // وجهتك القادمة هنا
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─── HEADER DESIGN ─────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 22, right: 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient, // استخدام تدرجك الخاص بالهيدر
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surface.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.surface, // الأبيض النقي من ملفك
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "أهلاً بك 👋",
                      style: TextStyle(
                        color: AppColors
                            .textOnPrimary, // لون النص المخصص فوق الأخضر
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "كل الخير في مكان واحد",
                      style: TextStyle(
                        color: Colors.white70, // نص خفيف شفاف متناسق مع الأخضر
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // زر الإشعارات العصري الشفاف
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surface.withOpacity(0.1)),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.textOnPrimary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          /// 🔍 شريط البحث الذكي باللون الأبيض الموحد وسياق التلميح
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
              ), // لون الحدود الافتراضي
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              textAlign: TextAlign.right,
              cursorColor: AppColors.borderFocus, // الأخضر عند الكتابة
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: "ابحث عما تريد...",
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 14,
                ), // لون التلميح من ملفك
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textHint,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── TILE DESIGN ───────────────────────────────────
class _Tile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const _Tile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(
              0.25,
            ), // ظل ناعم مأخوذ من نفس لون البطاقة الذاتي
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.surface.withOpacity(0.15),
          highlightColor: AppColors.surface.withOpacity(0.05),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.textOnPrimary,
                          size: 26,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textOnPrimary.withOpacity(0.4),
                        size: 14,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textOnPrimary.withOpacity(0.75),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
