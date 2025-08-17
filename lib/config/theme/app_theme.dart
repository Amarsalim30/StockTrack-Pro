import 'package:clean_arch_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
  static ThemeData get darkTheme => lightTheme;

//
  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     brightness: Brightness.dark,
  //     primarySwatch: Colors.blue,
  //     primaryColor: Colors.blue,
  //     scaffoldBackgroundColor: Colors.grey[900],
  //     appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
  //     cardTheme: CardThemeData(
  //       elevation: 2,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       ),
  //     ),
  //     inputDecorationTheme: InputDecorationTheme(
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //       filled: true,
  //       fillColor: Colors.grey[800],
  //     ),
  //   );
  // }
}
