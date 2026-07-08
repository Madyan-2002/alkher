import 'package:alkher/screens/login_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreenUser extends StatelessWidget {
  const ProfileScreenUser({super.key});

  void logout(BuildContext context) {
    // تنظيف بيانات المستخدم من الـ Provider عند تسجيل الخروج
    context.read<AuthProvider>().logoutUser();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    final userName = authProvider.currentUser?.name ?? "مستخدم زائر";
    final userEmail = authProvider.currentUser?.email ?? "لا يوجد بريد إلكتروني";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 35, left: 20, right: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, size: 55, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // الاسم الحقيقي المستلم من السيرفر
                  Text(
                    userName, 
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // البريد الإلكتروني الحقيقي
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textOnPrimary.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── قائمة خيارات الإعدادات والبطاقات العصرية ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.person_outline,
                    title: "تعديل الملف الشخصي",
                    onTap: () {},
                  ),
                  _buildProfileTile(
                    icon: Icons.shopping_bag_outlined,
                    title: "إعلاناتي / منتجاتي",
                    onTap: () {},
                  ),
                  _buildProfileTile(
                    icon: Icons.favorite_border,
                    title: "المفضلة",
                    onTap: () {},
                  ),
                  _buildProfileTile(
                    icon: Icons.settings_outlined,
                    title: "الإعدادات",
                    onTap: () {},
                  ),
                  _buildProfileTile(
                    icon: Icons.help_outline,
                    title: "مركز المساعدة والدعم",
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 20),

                  // ── زر تسجيل الخروج العصري (ElevatedButton) ──
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => logout(context),
                      icon: const Icon(Icons.logout, size: 22),
                      label: const Text(
                        "تسجيل الخروج",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error.withOpacity(0.1),
                        foregroundColor: AppColors.error,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الـ Widget المساعد لبناء عناصر القائمة بشكل موحد وعصري متناسق مع ألوانك
  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22), // تم إزالة const هنا لتفادي الخطأ السابق
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textHint),
      ),
    );
  }
}