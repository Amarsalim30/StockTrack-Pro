import 'get_all_categories_usecase.dart';
import 'get_category_by_id_usecase.dart';
import 'create_category_usecase.dart';
import 'update_category_usecase.dart';
import 'delete_category_usecase.dart';
import 'search_categories_usecase.dart';
import 'get_categories_by_parent_usecase.dart';
import '../../../repositories/category_repository.dart';

class CategoryUseCases {
  final GetAllCategoriesUseCase getAllCategories;
  final GetCategoryByIdUseCase getCategoryById;
  final CreateCategoryUseCase createCategory;
  final UpdateCategoryUseCase updateCategory;
  final DeleteCategoryUseCase deleteCategory;
  final SearchCategoriesUseCase searchCategories;
  final GetCategoriesByParentUseCase getCategoriesByParent;

  CategoryUseCases({
    required this.getAllCategories,
    required this.getCategoryById,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
    required this.searchCategories,
    required this.getCategoriesByParent,
  });

  factory CategoryUseCases.fromRepository(CategoryRepository repository) {
    return CategoryUseCases(
      getAllCategories: GetAllCategoriesUseCase(repository),
      getCategoryById: GetCategoryByIdUseCase(repository),
      createCategory: CreateCategoryUseCase(repository),
      updateCategory: UpdateCategoryUseCase(repository),
      deleteCategory: DeleteCategoryUseCase(repository),
      searchCategories: SearchCategoriesUseCase(repository),
      getCategoriesByParent: GetCategoriesByParentUseCase(repository),
    );
  }
}