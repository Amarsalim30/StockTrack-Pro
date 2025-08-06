import 'package:clean_arch_app/domain/entities/catalog/supplier.dart';
import 'package:clean_arch_app/domain/entities/general/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_product_view_model.dart';
import '../../data/models/catalog/supplier_model.dart';
import '../../data/models/general/location_model.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductViewModelProvider.notifier);
    final state = ref.watch(addProductViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: viewModel.scanBarcode,
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField(
                    label: 'Product Name',
                    value: state.name,
                    onChanged: viewModel.setName,
                    errorText: state.fieldErrors['name'],
                  ),
                  _buildTextField(
                    label: 'Product Code',
                    value: state.code,
                    onChanged: viewModel.setCode,
                    errorText: state.fieldErrors['code'],
                  ),
                  _buildTextField(
                    label: 'Description',
                    value: state.description,
                    onChanged: viewModel.setDescription,
                    errorText: state.fieldErrors['description'],
                    maxLines: 3,
                  ),
                  _buildTextField(
                    label: 'Price',
                    value: state.price,
                    onChanged: viewModel.setPrice,
                    errorText: state.fieldErrors['price'],
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    label: 'Quantity',
                    value: state.quantity,
                    onChanged: viewModel.setQuantity,
                    errorText: state.fieldErrors['quantity'],
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    label: 'Reorder Level',
                    value: state.reorderLevel,
                    onChanged: viewModel.setReorderLevel,
                    errorText: state.fieldErrors['reorderLevel'],
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    label: 'Reorder Quantity',
                    value: state.reorderQuantity,
                    onChanged: viewModel.setReorderQuantity,
                    errorText: state.fieldErrors['reorderQuantity'],
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    label: 'Category',
                    value: state.category,
                    onChanged: viewModel.setCategory,
                    errorText: state.fieldErrors['category'],
                  ),
                  _buildDropdownField<Supplier>(
                    label: 'Supplier',
                    value: state.selectedSupplier,
                    items: state.suppliers,
                    onChanged: viewModel.setSupplier,
                    errorText: state.fieldErrors['supplier'],
                  ),
                  _buildDropdownField<Location>(
                    label: 'Location',
                    value: state.selectedLocation,
                    items: state.locations,
                    onChanged: viewModel.setLocation,
                    errorText: state.fieldErrors['location'],
                  ),
                  _buildImagePicker(context, viewModel),
                  if (state.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        state.error!,
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: state.isSaving
                              ? null
                              : () async {
                                  if (await viewModel.saveProduct()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Product saved successfully',
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                          child: state.isSaving
                              ? const CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                )
                              : const Text('Save'),
                        ),
                        OutlinedButton(
                          onPressed: state.isSaving
                              ? null
                              : () {
                                  viewModel.resetForm();
                                },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    String? errorText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            onChanged: onChanged,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(
    BuildContext context,
    AddProductViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: viewModel.state.productImages.asMap().entries.map((entry) {
            final index = entry.key;
            final image = entry.value;
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Image.file(image, width: 80, height: 80, fit: BoxFit.cover),
                Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => viewModel.removeImage(index),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        ElevatedButton.icon(
          onPressed: () => viewModel.pickImage(),
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}

extension on ThemeData {
  Color get errorColor => colorScheme.error;
}
