import 'package:flutter/material.dart';

class AppColors {
  static const blueTop = Color(0xFF1FA2FF);
  static const blueMid = Color(0xFF12D8FA);
  static const blueBot = Color(0xFFA6FFCB);

  static const bg = Color(0xFFF7F7FB);
  static const card = Colors.white;
  static const textStrong = Color(0xFF1F2A44);
  static const textSubtle = Color(0xFF6B7280);
  static const bubbleMe = Color(0xFF2563EB);
  static const bubbleOther = Color(0xFFF0F3F8);
  static const accent = Color(0xFFFFB703);
}

class G {
  static BoxDecoration gradientAppbar() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.blueTop, AppColors.blueMid, AppColors.blueBot],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration softCard([double radius = 16]) => BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static Widget avatar(String url, {double size = 40, IconData icon = Icons.person}) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: (url.isNotEmpty) ? NetworkImage(url) : null,
      child: (url.isEmpty) ? Icon(icon, color: AppColors.textSubtle) : null,
    );
  }

  static InputDecoration pillInput(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.textSubtle),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide.none,
    ),
  );
}