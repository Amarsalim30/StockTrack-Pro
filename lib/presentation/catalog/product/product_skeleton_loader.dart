import 'package:flutter/material.dart';

class ProductSkeletonLoader extends StatefulWidget {
  const ProductSkeletonLoader({super.key});

  @override
  State<ProductSkeletonLoader> createState() => _ProductSkeletonLoaderState();
}

class _ProductSkeletonLoaderState extends State<ProductSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header skeleton
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.grey.shade100.withValues(alpha: _animation.value),
                ),
                child: Stack(
                  children: [
                    // Image placeholder
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    // Checkbox placeholder
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Status placeholder
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 50,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content skeleton
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name placeholder
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // SKU placeholder
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Price placeholders
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Tags placeholder
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 30,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Action buttons placeholder
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200.withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 40,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}