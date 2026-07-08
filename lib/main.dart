import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/splash_screen.dart';
import 'package:alkher/services/auth_provider.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider())
      ],
      child: MaterialApp(
        title: 'Alkher',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.background,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.borderFocus, width: 1.5),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}