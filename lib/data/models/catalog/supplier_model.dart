import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/catalog/supplier.dart';

part 'supplier_model.g.dart';

@JsonSerializable()
class SupplierModel extends Equatable {
  final String id;
  final String name;
  final Map<String, String>? contactInfo; // e.g. {'email': ..., 'phone': ...}
  final double? rating;
  final String? paymentTerms;

  const SupplierModel({
    required this.id,
    required this.name,
    this.contactInfo,
    this.rating,
    this.paymentTerms,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);

  Supplier toDomain() => Supplier(
    id: id,
    name: name,
    contactInfo: contactInfo,
    rating: rating,
    paymentTerms: paymentTerms,
  );

  static SupplierModel fromDomain(Supplier ent) => SupplierModel(
    id: ent.id,
    name: ent.name,
    contactInfo: ent.contactInfo,
    rating: ent.rating,
    paymentTerms: ent.paymentTerms,
  );

  SupplierModel copyWith({
    String? id,
    String? name,
    Map<String, String>? contactInfo,
    double? rating,
    String? paymentTerms,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      rating: rating ?? this.rating,
      paymentTerms: paymentTerms ?? this.paymentTerms,
    );
  }

  @override
  List<Object?> get props => [id, name, contactInfo, rating, paymentTerms];
}
