import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/catalog/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? parentCategoryId;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.parentCategoryId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toDomain() => Category(
    id: id,
    name: name,
    description: description,
    parentCategoryId: parentCategoryId,
  );

  static CategoryModel fromDomain(Category ent) => CategoryModel(
    id: ent.id,
    name: ent.name,
    description: ent.description,
    parentCategoryId: ent.parentCategoryId,
  );

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? parentCategoryId,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
    );
  }

  @override
  List<Object?> get props => [id, name, description, parentCategoryId];
}
