import 'package:equatable/equatable.dart';
import '../../../domain/entities/catalog/category.dart';

class CategoryState extends Equatable {
  final List<Category> categories;
  final bool isLoading;
  final String searchQuery;
  final List<Category> filteredCategories;
  final String? error;
  final Category? selectedCategory;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.filteredCategories = const [],
    this.error,
    this.selectedCategory,
  });

  bool get hasError => error != null;
  bool get hasCategories => categories.isNotEmpty;

  List<Category> get displayCategories =>
    searchQuery.isEmpty ? categories : filteredCategories;

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? searchQuery,
    List<Category>? filteredCategories,
    String? error,
    Category? selectedCategory,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    isLoading,
    searchQuery,
    filteredCategories,
    error,
    selectedCategory
  ];
}