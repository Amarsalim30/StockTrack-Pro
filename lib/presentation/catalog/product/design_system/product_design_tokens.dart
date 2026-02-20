import 'package:flutter/material.dart';

/// Design tokens for the Product Catalog system
/// Provides consistent spacing, colors, typography, and component specs
class ProductDesignTokens {
  ProductDesignTokens._();

  // ============================================================================
  // COLOR SYSTEM
  // ============================================================================

  /// Primary brand colors
  static const Color primaryColor = Color(0xFF0E2330);
  static const Color primaryLight = Color(0xFF1A3441);
  static const Color primaryDark = Color(0xFF0A1B24);

  /// Semantic colors
  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  /// Surface colors
  static const Color surfacePrimary = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8FAFC);
  static const Color surfaceTertiary = Color(0xFFF1F5F9);

  /// Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Border colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color borderStrong = Color(0xFF94A3B8);

  // ============================================================================
  // SPACING SYSTEM (8pt grid)
  // ============================================================================

  static const double spaceXS = 4.0;   // 0.5 * 8
  static const double spaceSM = 8.0;   // 1 * 8
  static const double spaceMD = 16.0;  // 2 * 8
  static const double spaceLG = 24.0;  // 3 * 8
  static const double spaceXL = 32.0;  // 4 * 8
  static const double space2XL = 48.0; // 6 * 8
  static const double space3XL = 64.0; // 8 * 8

  // ============================================================================
  // BORDER RADIUS SYSTEM
  // ============================================================================

  static const double radiusXS = 4.0;
  static const double radiusSM = 6.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusRound = 999.0;

  // ============================================================================
  // ELEVATION SYSTEM
  // ============================================================================

  static const double elevationNone = 0.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;

  // ============================================================================
  // TYPOGRAPHY SYSTEM
  // ============================================================================

  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.01,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // ============================================================================
  // BREAKPOINTS SYSTEM
  // ============================================================================

  static const double breakpointMobile = 480;
  static const double breakpointTablet = 768;
  static const double breakpointDesktop = 1024;
  static const double breakpointLarge = 1280;

  // ============================================================================
  // COMPONENT SPECIFIC TOKENS
  // ============================================================================

  // Product Card
  static const double productCardMinHeight = 200.0;
  static const double productCardMaxWidth = 400.0;
  static const EdgeInsets productCardPadding = EdgeInsets.all(spaceMD);
  static const BorderRadius productCardRadius = BorderRadius.all(Radius.circular(radiusLG));

  // Action Buttons
  static const double buttonMinHeight = 44.0; // Accessibility minimum
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: spaceMD,
    vertical: spaceSM,
  );
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(radiusMD));

  // Statistics Cards
  static const double statCardMinWidth = 120.0;
  static const EdgeInsets statCardPadding = EdgeInsets.all(spaceMD);
  static const BorderRadius statCardRadius = BorderRadius.all(Radius.circular(radiusMD));

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Returns appropriate spacing based on screen size
  static double responsiveSpacing(BuildContext context, {
    double mobile = spaceMD,
    double tablet = spaceLG,
    double desktop = spaceXL,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpointDesktop) return desktop;
    if (screenWidth >= breakpointTablet) return tablet;
    return mobile;
  }

  /// Returns responsive padding based on screen size
  static EdgeInsets responsivePadding(BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpointDesktop) {
      return desktop ?? const EdgeInsets.all(spaceXL);
    }
    if (screenWidth >= breakpointTablet) {
      return tablet ?? const EdgeInsets.all(spaceLG);
    }
    return mobile ?? const EdgeInsets.all(spaceMD);
  }

  /// Returns if screen is mobile size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < breakpointTablet;
  }

  /// Returns if screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= breakpointTablet && width < breakpointDesktop;
  }

  /// Returns if screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= breakpointDesktop;
  }

  /// Returns shadow for elevation level
  static List<BoxShadow> getShadow(double elevation) {
    switch (elevation) {
      case elevationSM:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ];
      case elevationMD:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
      case elevationLG:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ];
      case elevationXL:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ];
      default:
        return [];
    }
  }
}