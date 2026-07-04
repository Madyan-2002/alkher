import 'package:alkher/screens/user/cart_screen_user.dart';
import 'package:alkher/screens/user/favorite_screen_user.dart';
import 'package:alkher/screens/user/home_screen.dart';
import 'package:alkher/screens/user/profile_screen_user.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final screens = [
    const HomeScreen(),
    const FavoriteScreenUser(),
    const CartScreenUser(),
    const ProfileScreenUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: screens[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            unselectedItemColor: AppColors.textHint,
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 400),
            items: [
              SalomonBottomBarItem(
                // 🛠️ إذا كانت الصفحة الحالية هي 0 اعرض الأيقونة ممتلئة، وإلا اعرضها مفرغة
                icon: Icon(
                  _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                ),
                title: const Text(
                  "الرئيسية",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                selectedColor: AppColors.primary,
              ),
              SalomonBottomBarItem(
                // تفاعل أيقونة المفضلة
                icon: Icon(
                  _currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
                ),
                title: const Text(
                  "المفضلة",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                selectedColor: AppColors.secondary,
              ),
              SalomonBottomBarItem(
                // تفاعل أيقونة السلة
                icon: Icon(
                  _currentIndex == 2
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                ),
                title: const Text(
                  "السلة",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                selectedColor: AppColors.primary,
              ),
              SalomonBottomBarItem(
                // تفاعل أيقونة الحساب
                icon: Icon(
                  _currentIndex == 3 ? Icons.person : Icons.person_outline,
                ),
                title: const Text(
                  "الحساب",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                selectedColor: AppColors.primaryDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
