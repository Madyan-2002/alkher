import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/admin/admin_dashboard_screen.dart';
import 'package:alkher/screens/intro_pages.dart';
import 'package:alkher/screens/login_screen.dart';
import 'package:alkher/screens/seller/seller_screen.dart';
import 'package:alkher/screens/user/main_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/services/token_services.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // 1. الفحص أولاً إذا كانت هذه هي المرة الأولى لفتح التطبيق أم لا
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (isFirstTime) {
      // توجيه المستخدم لصفحات المقدمة الـ Intro
      if (!mounted) return;
      _navigateTo(const IntroPages());
      return;
    }

    // 2. إذا لم تكن المرة الأولى، نتابع فحص الجلسة الطبيعي الخاص بك
    final token = await TokenServices().getToken();
    final role = await TokenServices().getRole();

    Widget destination;

    if (token == null || token.isEmpty) {
      destination = const LoginScreen();
    } else {
      if (!mounted) return;

      await context.read<AuthProvider>().loadUserFromStorage();
      await context.read<FavoriteProvider>().loadFavorites();

      if (role == 'seller') {
        destination = const SellerScreen();
      } else if (role == 'admin') {
        destination = const AdminDashboardScreen();
      } else if (role == 'customer') {
        destination = const MainScreen();
      } else {
        destination = const LoginScreen();
      }
    }

    if (!mounted) return;
    _navigateTo(destination);
  }

  // دالة مساعدة للتوجيه النظيف ومنع تكرار الكود
  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            colors: AppColors.primaryGradient,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      size: 60,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'أثر',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'معًا نصنع الخير',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textOnPrimary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textOnPrimary,
                      ),
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