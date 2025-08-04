import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String name;
  final String type; // warehouse, store, etc.
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Location({
    required this.id,
    required this.name,
    required this.type,
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
    type,
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
