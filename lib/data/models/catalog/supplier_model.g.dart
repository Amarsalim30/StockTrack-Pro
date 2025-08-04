// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) =>
    SupplierModel(
      id: json['id'] as String,
      name: json['name'] as String,
      contactInfo: (json['contactInfo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      rating: (json['rating'] as num?)?.toDouble(),
      paymentTerms: json['paymentTerms'] as String?,
    );

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contactInfo': instance.contactInfo,
      'rating': instance.rating,
      'paymentTerms': instance.paymentTerms,
    };
