import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import 'product_state.dart';
import 'product_view_model.dart';
import 'product_providers.dart';

class CsvImportExportDialog extends ConsumerStatefulWidget {
  final List<Product> products;
  final bool isExport;

  const CsvImportExportDialog({
    super.key,
    required this.products,
    this.isExport = false,
  });

  @override
  ConsumerState<CsvImportExportDialog> createState() =>
      _CsvImportExportDialogState();
}

class _CsvImportExportDialogState extends ConsumerState<CsvImportExportDialog> {
  final TextEditingController _csvController = TextEditingController();
  String? _selectedFilePath;

  @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  widget.isExport ? Icons.upload_file : Icons.download,
                  color: const Color(0xFF0E2330),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.isExport
                      ? 'Export Products to CSV'
                      : 'Import Products from CSV',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2330),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: widget.isExport
                  ? _buildExportContent(productsState, vm)
                  : _buildImportContent(productsState, vm),
            ),

            // Actions
            const SizedBox(height: 24),
            _buildActionButtons(productsState, vm),
          ],
        ),
      ),
    );
  }

  Widget _buildExportContent(ProductState state, ProductViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Export info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Export Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.products.length} products will be exported to CSV format.',
              ),
              const SizedBox(height: 4),
              Text(
                'The CSV will include: Name, SKU, Description, Category, Supplier, Unit, Price, Cost Price, Tags, and Status.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // CSV Preview
        if (state.csvTemplate != null) ...[
          const Text(
            'CSV Preview:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SingleChildScrollView(
                child: Text(
                  state.csvTemplate!,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
        ] else if (state.isExporting) ...[
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating CSV...'),
              ],
            ),
          ),
        ] else ...[
          const Center(
            child: Text(
              'Click "Generate CSV" to preview the export data.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImportContent(ProductState state, ProductViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Import instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Import Instructions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Download the CSV template to see the required format',
              ),
              const Text('2. Fill in your product data following the template'),
              const Text('3. Upload the CSV file or paste the content below'),
              const Text('4. Validate the format before importing'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Template download
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => vm.getCsvTemplate(),
                icon: const Icon(Icons.download),
                label: const Text('Download Template'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E2330),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // CSV Content Input
        const Text(
          'CSV Content:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextField(
            controller: _csvController,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              hintText: 'Paste your CSV content here or select a file above...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                vm.validateCsvContent(value);
              }
            },
          ),
        ),

        // Validation status
        if (state.hasCsvValidationError) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.csvValidationError!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        ] else if (_csvController.text.isNotEmpty && !state.isValidating) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'CSV format is valid',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ],
            ),
          ),
        ],

        // Import progress
        if (state.isImporting) ...[
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Importing products... ${state.csvImportProgress ?? 0}/${state.csvTotalRows ?? 0}',
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: state.csvImportProgressPercentage,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(ProductState state, ProductViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        if (widget.isExport) ...[
          ElevatedButton.icon(
            onPressed: state.csvTemplate == null
                ? () => vm.exportProductsToCsv(widget.products)
                : null,
            icon: const Icon(Icons.refresh),
            label: const Text('Generate CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: state.csvTemplate != null
                ? () => _copyCsvToClipboard(state.csvTemplate!)
                : null,
            icon: const Icon(Icons.copy),
            label: const Text('Copy CSV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E2330),
              foregroundColor: Colors.white,
            ),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed:
                _csvController.text.isNotEmpty &&
                    !state.hasCsvValidationError &&
                    !state.isImporting
                ? () => vm.importProductsFromCsv(_csvController.text)
                : null,
            icon: const Icon(Icons.upload),
            label: const Text('Import Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E2330),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _copyCsvToClipboard(String csvContent) async {
    try {
      await Clipboard.setData(ClipboardData(text: csvContent));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV content copied to clipboard')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error copying to clipboard: $e')));
    }
  }
}
