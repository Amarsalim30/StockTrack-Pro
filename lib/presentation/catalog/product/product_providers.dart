import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../di/injection.dart';
import 'product_view_model.dart';
import 'product_state.dart';

final productViewModelProvider = StateNotifierProvider<ProductViewModel, ProductState>((ref) {
  final useCases = ref.read(productUsecasesProvider);
  return ProductViewModel(useCases);
});