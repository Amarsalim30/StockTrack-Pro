import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/catalog/product_model.dart';
import '../../data/models/catalog/supplier_model.dart';
import '../../data/models/general/location_model.dart';

class AddProductState {
  final String name;
  final String code;
  final String description;
  final String price;
  final String quantity;
  final String reorderLevel;
  final String reorderQuantity;
  final String category;
  final SupplierModel? selectedSupplier;
  final LocationModel? selectedLocation;
  final List<File> productImages;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final Map<String, String> fieldErrors;
  final List<SupplierModel> suppliers;
  final List<LocationModel> locations;

  AddProductState({
    this.name = '',
    this.code = '',
    this.description = '',
    this.price = '',
    this.quantity = '',
    this.reorderLevel = '',
    this.reorderQuantity = '',
    this.category = '',
    this.selectedSupplier,
    this.selectedLocation,
    this.productImages = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.fieldErrors = const {},
    this.suppliers = const [],
    this.locations = const [],
  });

  AddProductState copyWith({
    String? name,
    String? code,
    String? description,
    String? price,
    String? quantity,
    String? reorderLevel,
    String? reorderQuantity,
    String? category,
    SupplierModel? selectedSupplier,
    LocationModel? selectedLocation,
    List<File>? productImages,
    bool? isLoading,
    bool? isSaving,
    String? error,
    Map<String, String>? fieldErrors,
    List<SupplierModel>? suppliers,
    List<LocationModel>? locations,
  }) {
    return AddProductState(
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      reorderQuantity: reorderQuantity ?? this.reorderQuantity,
      category: category ?? this.category,
      selectedSupplier: selectedSupplier ?? this.selectedSupplier,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      productImages: productImages ?? this.productImages,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      suppliers: suppliers ?? this.suppliers,
      locations: locations ?? this.locations,
    );
  }
}

class AddProductViewModel extends StateNotifier<AddProductState> {
  AddProductViewModel() : super(AddProductState());

  final ImagePicker _imagePicker = ImagePicker();

  // Initialize with mock data
  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      // Mock suppliers data
      final mockSuppliers = [
        const SupplierModel(
          id: '1',
          name: 'Tech Supplies Inc.',
          contactInfo: {
            'email': 'john@techsupplies.com',
            'phoneNumber': '+1234567890',
          },
          rating: 4.5,
          paymentTerms: 'Net 30',
        ), const SupplierModel(
          id: '2',
          name: 'Global Supplies Inc.',
          contactInfo: {
            'email': 'john@techsupplies.com',
            'phoneNumber': '+1234567890',
          },
          rating: 4.5,
          paymentTerms: 'Net 30',
        ),
        const SupplierModel(
          id: '1',
          name: 'Tech Retails Inc.',
          contactInfo: {
            'email': 'john@techsupplies.com',
            'phoneNumber': '+1234567890',
          },
          rating: 4.5,
          paymentTerms: 'Net 30',
        ),
      ];

      // Mock locations data
      final mockLocations = [
        const LocationModel(
          id: '1',
          name: 'Main Warehouse',
          description: 'Central storage facility',
          latitude: 12.3456,
          longitude: 11.7890,
        ),
        const LocationModel(
          id: '2',
          name: 'Store Front',
          description: 'Central storage facility',
          latitude: 12.3456,
          longitude: 11.7890,
        ),
      ];

      state = state.copyWith(
        suppliers: mockSuppliers,
        locations: mockLocations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load data: $e',
        isLoading: false,
      );
    }
  }

  // Form field setters
  void setName(String value) {
    state = state.copyWith(name: value);
    _clearFieldError('name');
  }

  void setCode(String value) {
    state = state.copyWith(code: value);
    _clearFieldError('code');
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setPrice(String value) {
    state = state.copyWith(price: value);
    _clearFieldError('price');
  }

  void setQuantity(String value) {
    state = state.copyWith(quantity: value);
    _clearFieldError('quantity');
  }

  void setReorderLevel(String value) {
    state = state.copyWith(reorderLevel: value);
    _clearFieldError('reorderLevel');
  }

  void setReorderQuantity(String value) {
    state = state.copyWith(reorderQuantity: value);
    _clearFieldError('reorderQuantity');
  }

  void setCategory(String value) {
    state = state.copyWith(category: value);
    _clearFieldError('category');
  }

  void setSupplier(SupplierModel? supplier) {
    state = state.copyWith(selectedSupplier: supplier);
  }

  void setLocation(LocationModel? location) {
    state = state.copyWith(selectedLocation: location);
  }

  // Clear field error
  void _clearFieldError(String field) {
    if (state.fieldErrors.containsKey(field)) {
      final newErrors = Map<String, String>.from(state.fieldErrors);
      newErrors.remove(field);
      state = state.copyWith(fieldErrors: newErrors);
    }
  }

  // Clear general error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Image handling
  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        final newImages = List<File>.from(state.productImages);
        newImages.add(File(pickedFile.path));
        state = state.copyWith(productImages: newImages);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to pick image: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.productImages.length) {
      final newImages = List<File>.from(state.productImages);
      newImages.removeAt(index);
      state = state.copyWith(productImages: newImages);
    }
  }

  // Barcode scanner (placeholder for integration)
  Future<void> scanBarcode() async {
    try {
      // TODO: Integrate with barcode scanner package
      // For now, just simulate with a mock barcode
      state = state.copyWith(
        code: 'SCANNED-${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('Barcode scanner integration pending');
    } catch (e) {
      state = state.copyWith(error: 'Failed to scan barcode: $e');
    }
  }

  // Validation
  bool _validateForm() {
    final errors = <String, String>{};

    // Required field validation
    if (state.name.trim().isEmpty) {
      errors['name'] = 'Product name is required';
    }

    if (state.code.trim().isEmpty) {
      errors['code'] = 'Product code is required';
    }

    if (state.category.trim().isEmpty) {
      errors['category'] = 'Category is required';
    }

    // Numeric field validation
    if (state.price.trim().isEmpty) {
      errors['price'] = 'Price is required';
    } else {
      final price = double.tryParse(state.price);
      if (price == null || price < 0) {
        errors['price'] = 'Price must be a valid positive number';
      }
    }

    if (state.quantity.trim().isEmpty) {
      errors['quantity'] = 'Quantity is required';
    } else {
      final quantity = int.tryParse(state.quantity);
      if (quantity == null || quantity < 0) {
        errors['quantity'] = 'Quantity must be a valid positive integer';
      }
    }

    if (state.reorderLevel.trim().isEmpty) {
      errors['reorderLevel'] = 'Reorder level is required';
    } else {
      final reorderLevel = int.tryParse(state.reorderLevel);
      if (reorderLevel == null || reorderLevel < 0) {
        errors['reorderLevel'] =
            'Reorder level must be a valid positive integer';
      }
    }

    if (state.reorderQuantity.trim().isEmpty) {
      errors['reorderQuantity'] = 'Reorder quantity is required';
    } else {
      final reorderQuantity = int.tryParse(state.reorderQuantity);
      if (reorderQuantity == null || reorderQuantity <= 0) {
        errors['reorderQuantity'] =
            'Reorder quantity must be a positive integer';
      }
    }

    if (errors.isNotEmpty) {
      state = state.copyWith(fieldErrors: errors);
      return false;
    }

    state = state.copyWith(fieldErrors: {});
    return true;
  }

  // Save product
  Future<bool> saveProduct() async {
    if (!_validateForm()) {
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      // Create product model
      final product = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: state.name.trim(),
        sku: state.code.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        price: double.parse(state.price),
        costPrice: null,
        // Add cost price if needed
        categoryId: state.category.trim(),
        supplierId: state.selectedSupplier?.id ?? '',
        tags: [],
      );

      // TODO: Implement actual API call to save product
      // For now, just simulate a delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Upload images if any
      if (state.productImages.isNotEmpty) {
        debugPrint('Uploading ${state.productImages.length} images...');
        await Future.delayed(const Duration(seconds: 1));
      }

      debugPrint('Product saved: ${product.toJson()}');

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save product: $e',
        isSaving: false,
      );
      return false;
    }
  }

  // Reset form
  void resetForm() {
    state = AddProductState(
      suppliers: state.suppliers,
      locations: state.locations,
    );
  }
}

// Provider
final addProductViewModelProvider =
    StateNotifierProvider<AddProductViewModel, AddProductState>((ref) {
      return AddProductViewModel();
    });
