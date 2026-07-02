import 'package:alkher/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreenUser extends StatelessWidget {
  const ProfileScreenUser({super.key});

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) =>
          false, // هذا السطر يضمن حذف كل الصفحات السابقة من الكومة (Stack)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => logout(context),
        icon: const Icon(Icons.logout),
        label: const Text("تسجيل الخروج"),
      ),
    );
  }
}
