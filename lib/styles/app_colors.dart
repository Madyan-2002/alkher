import 'package:flutter/material.dart';

class AppColors {
  // ── Primary (أخضر - رمز الخير والنماء) ─────
  static const primary        = Color(0xFF2E7D32);
  static const primaryDark    = Color(0xFF1B5E20);
  static const primaryLight   = Color(0xFFE8F5E9);

  // ── Secondary / Accent ───────────────────
  static const secondary      = Color(0xFF66BB6A);
  static const accent         = Color(0xFFA5D6A7);

  // ── Background ───────────────────────────
  static const background     = Color(0xFFF5F5F5);
  static const surface        = Color(0xFFFFFFFF);

  // ── Text ─────────────────────────────────
  static const textPrimary    = Color(0xFF1A1A1A);
  static const textSecondary  = Color(0xFF757575);
  static const textHint       = Color(0xFFBDBDBD);
  static const textOnPrimary  = Color(0xFFFFFFFF);

  // ── Border ───────────────────────────────
  static const border         = Color(0xFFE0E0E0);
  static const borderFocus    = Color(0xFF2E7D32);

  // ── Status ───────────────────────────────
  static const success        = Color(0xFF34A853);
  static const error          = Color(0xFFEA4335);
  static const warning        = Color(0xFFFBBC04);

  // ── Gradient (للـ Splash وأي خلفيات مميزة) ─
  static const gradientStart  = Color(0xFF1B5E20);
  static const gradientMid    = Color(0xFF2E7D32);
  static const gradientEnd    = Color(0xFF81C784);

  static const List<Color> primaryGradient = [
    gradientStart,
    gradientMid,
    gradientEnd,
  ];
}