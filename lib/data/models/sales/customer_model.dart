import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/sales/customer.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class CustomerModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? loyaltyId;

  const CustomerModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.loyaltyId,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);

  Customer toDomain() => Customer(
    id: id,
    name: name,
    email: email,
    phone: phone,
    loyaltyId: loyaltyId,
  );

  static CustomerModel fromDomain(Customer ent) => CustomerModel(
    id: ent.id,
    name: ent.name,
    email: ent.email,
    phone: ent.phone,
    loyaltyId: ent.loyaltyId,
  );

  CustomerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? loyaltyId,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      loyaltyId: loyaltyId ?? this.loyaltyId,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, loyaltyId];
}
