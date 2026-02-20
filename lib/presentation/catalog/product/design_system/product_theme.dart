import 'package:flutter/material.dart';
import 'product_design_tokens.dart';

/// Product Catalog Theme System
/// Provides consistent theming for all product catalog components
class ProductTheme {
  ProductTheme._();

  // ============================================================================
  // TEXT THEMES
  // ============================================================================

  static TextTheme get textTheme => TextTheme(
    headlineLarge: ProductDesignTokens.headingLarge.copyWith(
      color: ProductDesignTokens.textPrimary,
    ),
    headlineMedium: ProductDesignTokens.headingMedium.copyWith(
      color: ProductDesignTokens.textPrimary,
    ),
    headlineSmall: ProductDesignTokens.headingSmall.copyWith(
      color: ProductDesignTokens.textPrimary,
    ),
    titleLarge: ProductDesignTokens.titleLarge.copyWith(
      color: ProductDesignTokens.textPrimary,
    ),
    titleMedium: ProductDesignTokens.titleMedium.copyWith(
      color: ProductDesignTokens.textPrimary,
    ),
    bodyLarge: ProductDesignTokens.bodyLarge.copyWith(
      color: ProductDesignTokens.textSecondary,
    ),
    bodyMedium: ProductDesignTokens.bodyMedium.copyWith(
      color: ProductDesignTokens.textSecondary,
    ),
    bodySmall: ProductDesignTokens.bodySmall.copyWith(
      color: ProductDesignTokens.textTertiary,
    ),
    labelLarge: ProductDesignTokens.labelLarge.copyWith(
      color: ProductDesignTokens.textSecondary,
    ),
    labelMedium: ProductDesignTokens.labelMedium.copyWith(
      color: ProductDesignTokens.textSecondary,
    ),
    labelSmall: ProductDesignTokens.labelSmall.copyWith(
      color: ProductDesignTokens.textTertiary,
    ),
  );

  // ============================================================================
  // COMPONENT THEMES
  // ============================================================================

  /// Primary button theme for main actions
  static ButtonStyle get primaryButtonTheme => ElevatedButton.styleFrom(
    backgroundColor: ProductDesignTokens.primaryColor,
    foregroundColor: ProductDesignTokens.textInverse,
    elevation: ProductDesignTokens.elevationNone,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: ProductDesignTokens.buttonRadius,
    ),
    padding: ProductDesignTokens.buttonPadding,
    minimumSize: const Size(0, ProductDesignTokens.buttonMinHeight),
    textStyle: ProductDesignTokens.labelLarge,
  );

  /// Secondary button theme for less important actions
  static ButtonStyle get secondaryButtonTheme => OutlinedButton.styleFrom(
    foregroundColor: ProductDesignTokens.primaryColor,
    side: const BorderSide(
      color: ProductDesignTokens.borderMedium,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: ProductDesignTokens.buttonRadius,
    ),
    padding: ProductDesignTokens.buttonPadding,
    minimumSize: const Size(0, ProductDesignTokens.buttonMinHeight),
    textStyle: ProductDesignTokens.labelLarge,
  );

  /// Destructive button theme for delete actions
  static ButtonStyle get destructiveButtonTheme => ElevatedButton.styleFrom(
    backgroundColor: ProductDesignTokens.errorColor,
    foregroundColor: ProductDesignTokens.textInverse,
    elevation: ProductDesignTokens.elevationNone,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: ProductDesignTokens.buttonRadius,
    ),
    padding: ProductDesignTokens.buttonPadding,
    minimumSize: const Size(0, ProductDesignTokens.buttonMinHeight),
    textStyle: ProductDesignTokens.labelLarge,
  );

  /// Success button theme for positive actions
  static ButtonStyle get successButtonTheme => ElevatedButton.styleFrom(
    backgroundColor: ProductDesignTokens.successColor,
    foregroundColor: ProductDesignTokens.textInverse,
    elevation: ProductDesignTokens.elevationNone,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: ProductDesignTokens.buttonRadius,
    ),
    padding: ProductDesignTokens.buttonPadding,
    minimumSize: const Size(0, ProductDesignTokens.buttonMinHeight),
    textStyle: ProductDesignTokens.labelLarge,
  );

  /// Text button theme for tertiary actions
  static ButtonStyle get textButtonTheme => TextButton.styleFrom(
    foregroundColor: ProductDesignTokens.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: ProductDesignTokens.buttonRadius,
    ),
    padding: ProductDesignTokens.buttonPadding,
    minimumSize: const Size(0, ProductDesignTokens.buttonMinHeight),
    textStyle: ProductDesignTokens.labelLarge,
  );

  /// Card decoration for consistent card styling
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: ProductDesignTokens.surfacePrimary,
    borderRadius: ProductDesignTokens.productCardRadius,
    boxShadow: ProductDesignTokens.getShadow(ProductDesignTokens.elevationSM),
    border: Border.all(
      color: ProductDesignTokens.borderLight,
      width: 1,
    ),
  );

  /// Elevated card decoration for important content
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: ProductDesignTokens.surfacePrimary,
    borderRadius: ProductDesignTokens.productCardRadius,
    boxShadow: ProductDesignTokens.getShadow(ProductDesignTokens.elevationMD),
  );

  /// Input field decoration
  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hintText,
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: ProductDesignTokens.surfaceSecondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
      borderSide: const BorderSide(
        color: ProductDesignTokens.borderLight,
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
      borderSide: const BorderSide(
        color: ProductDesignTokens.borderLight,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
      borderSide: const BorderSide(
        color: ProductDesignTokens.primaryColor,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
      borderSide: const BorderSide(
        color: ProductDesignTokens.errorColor,
        width: 1,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: ProductDesignTokens.spaceMD,
      vertical: ProductDesignTokens.spaceMD,
    ),
    hintStyle: textTheme.bodyMedium?.copyWith(
      color: ProductDesignTokens.textTertiary,
    ),
    labelStyle: textTheme.labelMedium?.copyWith(
      color: ProductDesignTokens.textSecondary,
    ),
  );

  // ============================================================================
  // STATUS INDICATORS
  // ============================================================================

  /// Success indicator decoration
  static BoxDecoration get successIndicator => BoxDecoration(
    color: ProductDesignTokens.successColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(ProductDesignTokens.radiusSM),
    border: Border.all(
      color: ProductDesignTokens.successColor.withOpacity(0.3),
      width: 1,
    ),
  );

  /// Warning indicator decoration
  static BoxDecoration get warningIndicator => BoxDecoration(
    color: ProductDesignTokens.warningColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(ProductDesignTokens.radiusSM),
    border: Border.all(
      color: ProductDesignTokens.warningColor.withOpacity(0.3),
      width: 1,
    ),
  );

  /// Error indicator decoration
  static BoxDecoration get errorIndicator => BoxDecoration(
    color: ProductDesignTokens.errorColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(ProductDesignTokens.radiusSM),
    border: Border.all(
      color: ProductDesignTokens.errorColor.withOpacity(0.3),
      width: 1,
    ),
  );

  /// Info indicator decoration
  static BoxDecoration get infoIndicator => BoxDecoration(
    color: ProductDesignTokens.infoColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(ProductDesignTokens.radiusSM),
    border: Border.all(
      color: ProductDesignTokens.infoColor.withOpacity(0.3),
      width: 1,
    ),
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Returns text style with color override
  static TextStyle? getTextStyle(
    BuildContext context,
    String styleName, {
    Color? color,
  }) {
    final theme = Theme.of(context).textTheme;
    TextStyle? style;

    switch (styleName) {
      case 'headlineLarge':
        style = theme.headlineLarge;
        break;
      case 'headlineMedium':
        style = theme.headlineMedium;
        break;
      case 'headlineSmall':
        style = theme.headlineSmall;
        break;
      case 'titleLarge':
        style = theme.titleLarge;
        break;
      case 'titleMedium':
        style = theme.titleMedium;
        break;
      case 'bodyLarge':
        style = theme.bodyLarge;
        break;
      case 'bodyMedium':
        style = theme.bodyMedium;
        break;
      case 'bodySmall':
        style = theme.bodySmall;
        break;
      case 'labelLarge':
        style = theme.labelLarge;
        break;
      case 'labelMedium':
        style = theme.labelMedium;
        break;
      case 'labelSmall':
        style = theme.labelSmall;
        break;
    }

    return color != null ? style?.copyWith(color: color) : style;
  }

  /// Returns appropriate button style based on variant
  static ButtonStyle getButtonStyle(String variant) {
    switch (variant) {
      case 'primary':
        return primaryButtonTheme;
      case 'secondary':
        return secondaryButtonTheme;
      case 'destructive':
        return destructiveButtonTheme;
      case 'success':
        return successButtonTheme;
      case 'text':
        return textButtonTheme;
      default:
        return secondaryButtonTheme;
    }
  }

  /// Returns appropriate status color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'approved':
        return ProductDesignTokens.successColor;
      case 'warning':
      case 'pending':
        return ProductDesignTokens.warningColor;
      case 'error':
      case 'failed':
      case 'inactive':
        return ProductDesignTokens.errorColor;
      case 'info':
      case 'draft':
        return ProductDesignTokens.infoColor;
      default:
        return ProductDesignTokens.textTertiary;
    }
  }

  /// Returns appropriate status decoration
  static BoxDecoration getStatusDecoration(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'active':
      case 'approved':
        return successIndicator;
      case 'warning':
      case 'pending':
        return warningIndicator;
      case 'error':
      case 'failed':
      case 'inactive':
        return errorIndicator;
      case 'info':
      case 'draft':
        return infoIndicator;
      default:
        return infoIndicator;
    }
  }
}