import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/buy_screen.dart';
import 'package:alkher/screens/user/donation_screen.dart';
import 'package:alkher/screens/user/jobs_screen.dart';
import 'package:alkher/screens/user/other_screen.dart';
import 'package:alkher/screens/user/profile_screen_user.dart';
import 'package:alkher/screens/user/search_results_screen.dart';
import 'package:alkher/screens/user/widgets/ad_section.dart';
import 'package:alkher/screens/user/widgets/big_category_card.dart';
import 'package:alkher/screens/user/widgets/section_title.dart';
import 'package:alkher/screens/user/widgets/small_category_card.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:alkher/screens/seller/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAllTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'استكشف الأقسام'),
                    const SizedBox(height: 14),
                    _buildCategoriesLayout(context),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'أحدث الإعلانات'),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OtherScreen(),
                            ),
                          ),
                          child: const Text(
                            'عرض الكل',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: AdSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: BigCategoryCard(
            title: 'التبرعات',
            subtitle: 'ساهم بمبلغ أو غرض\nوكن جزءًا من الخير',
            icon: Icons.volunteer_activism_rounded,
            colors: const [AppColors.primaryDark, AppColors.primary],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonationScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              SmallCategoryCard(
                title: 'الشراء',
                icon: Icons.shopping_bag_rounded,
                colors: const [Color(0xFF1976D2), Color(0xFF42A5F5)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BuyScreen()),
                ),
              ),
              const SizedBox(height: 12),
              SmallCategoryCard(
                title: 'الوظائف',
                icon: Icons.work_rounded,
                colors: const [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobsScreen()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════
// Header
// ═══════════════════════════════════════════════
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.name;
    final displayName = (userName != null && userName.isNotEmpty)
        ? userName
        : 'زائر';
    final imageName = authProvider.profileImageName;
    final hasImage = imageName != null && imageName.isNotEmpty;

    return Container(
      padding: const EdgeInsets.only(top: 55, bottom: 26, left: 22, right: 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
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
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreenUser(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surface,
                    backgroundImage: hasImage
                        ? NetworkImage(ProductCard.getImageUrl(imageName))
                        : null,
                    child: !hasImage
                        ? const Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: 28,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أهلاً بك، $displayName 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'كل الخير في مكان واحد',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
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
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchResultsScreen(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'ابحث عن منتج، تبرع، وظيفة...',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                      Container(width: 1, height: 22, color: AppColors.border),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.tune_rounded,
                        color: AppColors.textSecondary.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
