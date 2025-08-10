// lib/presentation/stock/widgets/styles.dart

import 'package:flutter/material.dart';

/// Design tokens for the Stock module.
/// These should be imported anywhere you need consistent colors, spacing, etc.
/// Keep this file small and flat — it's meant to be a constants-only definition.
class StockStyles {
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 12.0;
  static const double spaceLG = 16.0;
  static const double spaceXL = 24.0;

  // Border radius
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;

  // Breakpoints
  static const double bpMobileMax = 600.0;
  static const double bpTabletMax = 900.0;

  // Colors
  static const Color borderColor = Color(0xFFE6E9EE);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4D4D4D);
  static const Color background = Colors.white;

  // Status colors
  static const Color statusInStock = Color(0xFF4CAF50); // green
  static const Color statusLowStock = Color(0xFFFF9800); // orange
  static const Color statusOutOfStock = Color(0xFFF44336); // red

  // Quantity progress colors
  static const Color qtyBarBackground = Color(0xFFE0E0E0);
  static const Color qtyBarFill = Color(0xFF2196F3); // blue

  // Typography
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );
}
