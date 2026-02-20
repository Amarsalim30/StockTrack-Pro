import 'package:flutter/material.dart';

class ProfessionalEmptyState extends StatelessWidget {
  final VoidCallback? onAddProduct;
  final String? searchQuery;

  const ProfessionalEmptyState({
    super.key,
    this.onAddProduct,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final isFiltered = searchQuery != null && searchQuery!.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: isMobile ? 100 : 120,
            height: isMobile ? 100 : 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(isMobile ? 50 : 60),
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background pattern
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                // Main icon
                Icon(
                  isFiltered ? Icons.search_off : Icons.inventory_2_outlined,
                  size: isMobile ? 40 : 48,
                  color: Colors.grey.shade400,
                ),
                // Accent decoration
                if (!isFiltered)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E2330).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 12,
                        color: const Color(0xFF0E2330),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            isFiltered ? 'No products match your search' : 'No products in your catalog',
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0E2330),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            isFiltered
                ? 'Try adjusting your search terms or filters to find what you\'re looking for.'
                : 'Start building your product catalog by adding your first product.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Action buttons
          if (isFiltered) ...[
            // Search suggestions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSuggestionChip(
                  'Clear filters',
                  Icons.clear_all,
                  onTap: () {
                    // TODO: Clear filters
                  },
                ),
                _buildSuggestionChip(
                  'Show all products',
                  Icons.visibility,
                  onTap: () {
                    // TODO: Show all products
                  },
                ),
                _buildSuggestionChip(
                  'Add new product',
                  Icons.add,
                  onTap: onAddProduct,
                ),
              ],
            ),
          ] else ...[
            // Add product button
            ElevatedButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text('Add Your First Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E2330),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Secondary actions
            isMobile
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Show import dialog
                          },
                          icon: const Icon(Icons.file_upload_outlined, size: 18),
                          label: const Text('Import CSV'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0E2330),
                            side: const BorderSide(color: Color(0xFF0E2330)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Download template
                          },
                          icon: const Icon(Icons.download_outlined, size: 18),
                          label: const Text('Get Template'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Show import dialog
                        },
                        icon: const Icon(Icons.file_upload_outlined, size: 18),
                        label: const Text('Import CSV'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0E2330),
                          side: const BorderSide(color: Color(0xFF0E2330)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Download template
                        },
                        icon: const Icon(Icons.download_outlined, size: 18),
                        label: const Text('Get Template'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade600,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}