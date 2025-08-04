import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String id;
  final String name;
  final String? contactPerson;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Supplier({
    required this.id,
    required this.name,
    this.contactPerson,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    contactPerson,
    email,
    phoneNumber,
    address,
    city,
    state,
    country,
    postalCode,
    isActive,
    createdAt,
    updatedAt,
  ];
}
