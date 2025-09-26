import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/category.dart';
import '../../../domain/usecases/catalog/category/category_usecases.dart';
import 'category_state.dart';

class CategoryViewModel extends StateNotifier<CategoryState> {
  final CategoryUseCases _useCases;

  CategoryViewModel(this._useCases) : super(const CategoryState()) {
    _init();
  }

  void _init() {
    fetchAllCategories();
  }

  Future<void> fetchAllCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.getAllCategories.call();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (categories) => state = state.copyWith(
        isLoading: false,
        categories: categories,
        error: null,
      ),
    );
  }

  Future<void> createCategory(Category category) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.createCategory.call(category);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (newCategory) {
        final updatedCategories = [...state.categories, newCategory];
        state = state.copyWith(
          isLoading: false,
          categories: updatedCategories,
          error: null,
        );
      },
    );
  }

  Future<void> updateCategory(Category category) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.updateCategory.call(category);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (updatedCategory) {
        final updatedCategories = state.categories
            .map((cat) => cat.id == updatedCategory.id ? updatedCategory : cat)
            .toList();
        state = state.copyWith(
          isLoading: false,
          categories: updatedCategories,
          error: null,
        );
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.deleteCategory.call(id);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (_) {
        final updatedCategories = state.categories
            .where((cat) => cat.id != id)
            .toList();
        state = state.copyWith(
          isLoading: false,
          categories: updatedCategories,
          error: null,
        );
      },
    );
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      state = state.copyWith(filteredCategories: []);
    } else {
      final filtered = state.categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()) ||
              (category.description?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
      state = state.copyWith(filteredCategories: filtered);
    }
  }

  void selectCategory(Category? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}