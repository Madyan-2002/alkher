import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/login_screen.dart';
import 'package:alkher/screens/seller/seller_screen.dart';
import 'package:alkher/screens/user/main_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/services/token_services.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      duration: const Duration(milliseconds: 1200),
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

    final token = await TokenServices().getToken();
    final role = await TokenServices().getRole();

    Widget destination;

    if (token == null || token.isEmpty) {
      destination = const LoginScreen();
    } else {
      if (!mounted) return;

      // استرجاع بيانات المستخدم (اسم، إيميل) واستعادة المفضلة قبل التوجيه
      await context.read<AuthProvider>().loadUserFromStorage();
      await context.read<FavoriteProvider>().loadFavorites();

      if (role == 'seller') {
        destination = const SellerScreen();
      } else if (role == 'customer') {
        destination = const MainScreen();
      } else {
        destination = const LoginScreen();
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
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
                    child: Icon(
                      Icons.volunteer_activism,
                      size: 60,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'الخير',
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
                  SizedBox(
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