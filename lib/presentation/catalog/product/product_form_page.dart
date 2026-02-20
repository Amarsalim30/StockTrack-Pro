import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import '../../../di/injection.dart';
import 'product_view_model.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final Product? product;
  final bool isEditing;

  const ProductFormPage({super.key, this.product, this.isEditing = false});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedSupplierId;
  String? _selectedUnitId;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.product != null) {
      _populateForm(widget.product!);
    }
  }

  void _populateForm(Product product) {
    _nameController.text = product.name;
    _skuController.text = product.sku;
    _descriptionController.text = product.description ?? '';
    _priceController.text = product.price?.toString() ?? '';
    _costPriceController.text = product.costPrice?.toString() ?? '';
    _tagsController.text = product.tags?.join(', ') ?? '';
    _selectedCategoryId = product.categoryId;
    _selectedSupplierId = product.supplierId;
    _selectedUnitId = product.unitId;
    _isActive = product.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(productViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Edit Product' : 'Add Product',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0E2330),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (widget.isEditing)
            IconButton(
              onPressed: () => _showDeleteConfirmation(context, vm),
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Product',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Card
              _buildCard(
                title: 'Basic Information',
                icon: Icons.info_outline,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Product Name',
                    hint: 'Enter product name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _skuController,
                    label: 'SKU',
                    hint: 'Enter SKU',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'SKU is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Enter product description',
                    maxLines: 3,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category and Supplier Card
              _buildCard(
                title: 'Category & Supplier',
                icon: Icons.category,
                children: [
                  _buildDropdownField(
                    label: 'Category',
                    value: _selectedCategoryId,
                    items: const [
                      DropdownMenuItem(
                        value: 'cat1',
                        child: Text('Electronics'),
                      ),
                      DropdownMenuItem(value: 'cat2', child: Text('Clothing')),
                      DropdownMenuItem(value: 'cat3', child: Text('Books')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedCategoryId = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Supplier',
                    value: _selectedSupplierId,
                    items: const [
                      DropdownMenuItem(
                        value: 'sup1',
                        child: Text('Supplier A'),
                      ),
                      DropdownMenuItem(
                        value: 'sup2',
                        child: Text('Supplier B'),
                      ),
                      DropdownMenuItem(
                        value: 'sup3',
                        child: Text('Supplier C'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedSupplierId = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a supplier';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Unit',
                    value: _selectedUnitId,
                    items: const [
                      DropdownMenuItem(value: 'unit1', child: Text('Piece')),
                      DropdownMenuItem(value: 'unit2', child: Text('Kilogram')),
                      DropdownMenuItem(value: 'unit3', child: Text('Liter')),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedUnitId = value),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Pricing Card
              _buildCard(
                title: 'Pricing',
                icon: Icons.attach_money,
                children: [
                  _buildTextField(
                    controller: _priceController,
                    label: 'Selling Price',
                    hint: 'Enter selling price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final price = double.tryParse(value);
                        if (price == null || price < 0) {
                          return 'Please enter a valid price';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _costPriceController,
                    label: 'Cost Price',
                    hint: 'Enter cost price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final costPrice = double.tryParse(value);
                        if (costPrice == null || costPrice < 0) {
                          return 'Please enter a valid cost price';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Additional Information Card
              _buildCard(
                title: 'Additional Information',
                icon: Icons.more_horiz,
                children: [
                  _buildTextField(
                    controller: _tagsController,
                    label: 'Tags',
                    hint: 'Enter tags separated by commas',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Product is available for sale'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeColor: const Color(0xFF0E2330),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF0E2330)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _saveProduct(vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E2330),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              widget.isEditing
                                  ? 'Update Product'
                                  : 'Create Product',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF0E2330), size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E2330),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0E2330), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0E2330), width: 2),
        ),
      ),
    );
  }

  Future<void> _saveProduct(ProductViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final product = Product(
        id: widget.product?.id ?? '',
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        supplierId: _selectedSupplierId!,
        unitId: _selectedUnitId,
        price: _priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text)
            : null,
        costPrice: _costPriceController.text.isNotEmpty
            ? double.tryParse(_costPriceController.text)
            : null,
        tags: tags.isEmpty ? null : tags,
        isActive: _isActive,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.isEditing) {
        await vm.updateProduct(product);
      } else {
        await vm.addProduct(product);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Product updated successfully'
                  : 'Product created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, ProductViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete "${widget.product?.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (widget.product != null) {
                await vm.deleteProduct(widget.product!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
