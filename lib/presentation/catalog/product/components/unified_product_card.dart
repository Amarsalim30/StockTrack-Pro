import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/catalog/product.dart';
import '../design_system/product_design_tokens.dart';
import '../design_system/product_theme.dart';
import '../product_state.dart';
import '../product_view_model.dart';

/// Unified Product Card Component
/// Consolidates all product card variants with consistent design system
class UnifiedProductCard extends ConsumerStatefulWidget {
  final Product product;
  final ProductCardVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSelect;
  final bool isSelected;
  final bool isLoading;
  final bool showActions;
  final bool showSelection;

  const UnifiedProductCard({
    super.key,
    required this.product,
    this.variant = ProductCardVariant.standard,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSelect,
    this.isSelected = false,
    this.isLoading = false,
    this.showActions = true,
    this.showSelection = false,
  });

  @override
  ConsumerState<UnifiedProductCard> createState() => _UnifiedProductCardState();
}

class _UnifiedProductCardState extends ConsumerState<UnifiedProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: ProductDesignTokens.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: ProductDesignTokens.elevationSM,
      end: ProductDesignTokens.elevationMD,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildCard(context),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Semantics(
      label: 'Product: ${widget.product.name}',
      button: true,
      selected: widget.isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: ProductDesignTokens.productCardRadius,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: ProductDesignTokens.productCardMinHeight,
              maxWidth: ProductDesignTokens.productCardMaxWidth,
            ),
            decoration: _getCardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showSelection || _shouldShowHeader())
                  _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: ProductDesignTokens.productCardPadding,
                    child: _buildContent(context),
                  ),
                ),
                if (widget.showActions) _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getCardDecoration() {
    return BoxDecoration(
      color: ProductDesignTokens.surfacePrimary,
      borderRadius: ProductDesignTokens.productCardRadius,
      border: Border.all(
        color: widget.isSelected
            ? ProductDesignTokens.primaryColor
            : ProductDesignTokens.borderLight,
        width: widget.isSelected ? 2 : 1,
      ),
      boxShadow: ProductDesignTokens.getShadow(_elevationAnimation.value),
    );
  }

  bool _shouldShowHeader() {
    return widget.variant == ProductCardVariant.detailed ||
        widget.variant == ProductCardVariant.professional;
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ProductDesignTokens.spaceMD),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? ProductDesignTokens.primaryColor.withOpacity(0.05)
            : ProductDesignTokens.surfaceSecondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ProductDesignTokens.radiusLG),
          topRight: Radius.circular(ProductDesignTokens.radiusLG),
        ),
      ),
      child: Row(
        children: [
          if (widget.showSelection) ...[
            Semantics(
              label: widget.isSelected ? 'Selected' : 'Not selected',
              child: Checkbox(
                value: widget.isSelected,
                onChanged: (_) => widget.onSelect?.call(),
                activeColor: ProductDesignTokens.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ProductDesignTokens.radiusXS),
                ),
              ),
            ),
            const SizedBox(width: ProductDesignTokens.spaceSM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKU: ${widget.product.sku}',
                  style: ProductTheme.getTextStyle(context, 'labelSmall')?.copyWith(
                    fontFamily: 'monospace',
                    color: ProductDesignTokens.textTertiary,
                  ),
                ),
                if (widget.variant == ProductCardVariant.detailed &&
                    widget.product.createdAt != null) ...[
                  const SizedBox(height: ProductDesignTokens.spaceXS),
                  Text(
                    'Created: ${_formatDate(widget.product.createdAt!)}',
                    style: ProductTheme.getTextStyle(context, 'labelSmall')?.copyWith(
                      color: ProductDesignTokens.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product name and status
        Row(
          children: [
            Expanded(
              child: Text(
                widget.product.name,
                style: ProductTheme.getTextStyle(context, 'titleLarge')?.copyWith(
                  color: ProductDesignTokens.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!widget.product.isActive) _buildInactiveChip(),
          ],
        ),

        if (widget.variant != ProductCardVariant.compact) ...[
          const SizedBox(height: ProductDesignTokens.spaceSM),

          // SKU (if not shown in header)
          if (!_shouldShowHeader())
            Text(
              'SKU: ${widget.product.sku}',
              style: ProductTheme.getTextStyle(context, 'labelMedium')?.copyWith(
                fontFamily: 'monospace',
                color: ProductDesignTokens.textTertiary,
              ),
            ),

          // Description
          if (widget.product.description?.isNotEmpty == true) ...[
            const SizedBox(height: ProductDesignTokens.spaceSM),
            Text(
              widget.product.description!,
              style: ProductTheme.getTextStyle(context, 'bodyMedium'),
              maxLines: widget.variant == ProductCardVariant.compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: ProductDesignTokens.spaceMD),

          // Price and cost information
          _buildPriceInfo(context),

          // Tags
          if (widget.product.tags?.isNotEmpty == true &&
              widget.variant != ProductCardVariant.compact) ...[
            const SizedBox(height: ProductDesignTokens.spaceMD),
            _buildTags(context),
          ],
        ],

        // Spacer to push actions to bottom
        const Spacer(),
      ],
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    if (widget.product.price == null && widget.product.costPrice == null) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: ProductDesignTokens.spaceSM,
      runSpacing: ProductDesignTokens.spaceXS,
      children: [
        if (widget.product.price != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ProductDesignTokens.spaceSM,
              vertical: ProductDesignTokens.spaceXS,
            ),
            decoration: ProductTheme.successIndicator,
            child: Text(
              '\$${widget.product.price!.toStringAsFixed(2)}',
              style: ProductTheme.getTextStyle(context, 'labelMedium')?.copyWith(
                color: ProductDesignTokens.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (widget.product.costPrice != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ProductDesignTokens.spaceSM,
              vertical: ProductDesignTokens.spaceXS,
            ),
            decoration: ProductTheme.infoIndicator,
            child: Text(
              'Cost: \$${widget.product.costPrice!.toStringAsFixed(2)}',
              style: ProductTheme.getTextStyle(context, 'labelSmall')?.copyWith(
                color: ProductDesignTokens.infoColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: ProductDesignTokens.spaceXS,
      runSpacing: ProductDesignTokens.spaceXS,
      children: widget.product.tags!
          .take(3) // Limit to 3 tags for space
          .map((tag) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ProductDesignTokens.spaceSM,
                  vertical: ProductDesignTokens.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: ProductDesignTokens.surfaceTertiary,
                  borderRadius: BorderRadius.circular(ProductDesignTokens.radiusSM),
                  border: Border.all(
                    color: ProductDesignTokens.borderLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: ProductTheme.getTextStyle(context, 'labelSmall')?.copyWith(
                    color: ProductDesignTokens.textSecondary,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildInactiveChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDesignTokens.spaceSM,
        vertical: ProductDesignTokens.spaceXS,
      ),
      decoration: ProductTheme.errorIndicator,
      child: Text(
        'Inactive',
        style: ProductTheme.getTextStyle(context, 'labelSmall')?.copyWith(
          color: ProductDesignTokens.errorColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: widget.product.isActive
            ? ProductDesignTokens.successColor
            : ProductDesignTokens.errorColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (!widget.showActions) return const SizedBox.shrink();

    final actions = <Widget>[];

    if (widget.variant != ProductCardVariant.compact) {
      actions.addAll([
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onTap,
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('View'),
            style: ProductTheme.getButtonStyle('secondary').copyWith(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: ProductDesignTokens.spaceSM,
                  vertical: ProductDesignTokens.spaceSM,
                ),
              ),
              textStyle: MaterialStateProperty.all(
                ProductTheme.getTextStyle(context, 'labelSmall'),
              ),
            ),
          ),
        ),
        const SizedBox(width: ProductDesignTokens.spaceSM),
      ]);
    }

    actions.addAll([
      Expanded(
        child: OutlinedButton.icon(
          onPressed: widget.isLoading ? null : widget.onEdit,
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit'),
          style: ProductTheme.getButtonStyle('secondary').copyWith(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: ProductDesignTokens.spaceSM,
                vertical: ProductDesignTokens.spaceSM,
              ),
            ),
            textStyle: MaterialStateProperty.all(
              ProductTheme.getTextStyle(context, 'labelSmall'),
            ),
          ),
        ),
      ),
      const SizedBox(width: ProductDesignTokens.spaceSM),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: widget.isLoading ? null : widget.onDelete,
          icon: Icon(
            widget.isLoading ? Icons.hourglass_empty : Icons.delete,
            size: 16,
          ),
          label: Text(widget.isLoading ? 'Deleting...' : 'Delete'),
          style: ProductTheme.getButtonStyle('destructive').copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(ProductDesignTokens.errorColor),
            side: MaterialStateProperty.all(
              const BorderSide(color: ProductDesignTokens.errorColor),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(
                horizontal: ProductDesignTokens.spaceSM,
                vertical: ProductDesignTokens.spaceSM,
              ),
            ),
            textStyle: MaterialStateProperty.all(
              ProductTheme.getTextStyle(context, 'labelSmall'),
            ),
          ),
        ),
      ),
    ]);

    return Container(
      padding: const EdgeInsets.all(ProductDesignTokens.spaceMD),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ProductDesignTokens.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(children: actions),
    );
  }

  void _onHover(bool isHovered) {
    if (mounted) {
      setState(() {
        _isHovered = isHovered;
      });
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

/// Product card display variants
enum ProductCardVariant {
  /// Standard card with all information
  standard,

  /// Compact card for dense layouts
  compact,

  /// Detailed card with additional metadata
  detailed,

  /// Professional card with enhanced styling
  professional,
}