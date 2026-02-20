import 'package:flutter/material.dart';
import '../../../domain/entities/catalog/product.dart';
import 'product_state.dart';
import 'product_view_model.dart';

class ProfessionalProductCard extends StatefulWidget {
  final Product product;
  final ProductState state;
  final ProductViewModel vm;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProfessionalProductCard({
    super.key,
    required this.product,
    required this.state,
    required this.vm,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ProfessionalProductCard> createState() => _ProfessionalProductCardState();
}

class _ProfessionalProductCardState extends State<ProfessionalProductCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.state.isProductSelected(widget.product.id);
    final isDeleting = widget.state.isProductDeleting(widget.product.id);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF0E2330), width: 2)
                          : Border.all(color: Colors.grey.shade200),
                    ),
                    child: Stack(
                      children: [
                        // Main content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with product image placeholder and status
                            _buildHeader(context, isSelected),

                            // Product details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product name
                                    Text(
                                      widget.product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0E2330),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 8),

                                    // SKU
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.qr_code,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            widget.product.sku,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontFamily: 'monospace',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Price and cost
                                    _buildPriceSection(),

                                    const Spacer(),

                                    // Quick info chips
                                    _buildQuickInfoChips(),

                                    const SizedBox(height: 12),

                                    // Action buttons
                                    _buildActionButtons(context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Loading overlay
                        if (isDeleting) _buildLoadingOverlay(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSelected) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
                  const Color(0xFF0E2330).withOpacity(0.1),
                  const Color(0xFF0E2330).withOpacity(0.05),
                ]
              : [
                  Colors.grey.shade50,
                  Colors.grey.shade100,
                ],
        ),
      ),
      child: Stack(
        children: [
          // Product image placeholder
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.inventory_2,
                size: 30,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // Selection checkbox
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => widget.vm.toggleProductSelection(widget.product.id),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                activeColor: const Color(0xFF0E2330),
              ),
            ),
          ),

          // Status indicator
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.product.isActive ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.product.isActive ? 'Active' : 'Inactive',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product.price != null) ...[
          Row(
            children: [
              Icon(
                Icons.sell,
                size: 14,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                '\$${widget.product.price!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
          if (widget.product.costPrice != null) ...[
            const SizedBox(height: 4),
            Text(
              'Cost: \$${widget.product.costPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            if (widget.product.hasValidPrice && widget.product.hasCostPrice) ...[
              const SizedBox(height: 2),
              Text(
                'Margin: ${widget.product.profitMargin.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.product.profitMargin > 0
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ] else ...[
          Text(
            'Price not set',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickInfoChips() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (widget.product.tags != null && widget.product.tags!.isNotEmpty)
          ...widget.product.tags!.take(2).map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        if (widget.product.createdAt != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatDate(widget.product.createdAt!),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onEdit,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: widget.onDelete,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size(40, 32),
          ),
          child: const Icon(
            Icons.delete_outline,
            size: 14,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(height: 8),
              Text(
                'Deleting...',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}