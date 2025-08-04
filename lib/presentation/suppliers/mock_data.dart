import 'supplier_view_model.dart';
import '../../domain/entities/supplier.dart';

enum MockStatus { active, inactive }

class MockSupplier {
  final String id;
  final String name;
  final String contactPerson;
  final String email;
  final MockStatus status;

  MockSupplier({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.email,
    required this.status,
  });
}

final List<Supplier> mockSuppliers = [
  Supplier(
    id: 'sup1',
    name: 'TechWorld Supplies',
    contactPerson: 'Alice Mwende',
    email: 'alice@techworld.com',
    phoneNumber: '+254712345678',
    address: '456 Westlands Road',
    city: 'Nairobi',
    state: 'Nairobi',
    country: 'Kenya',
    postalCode: '00100',
    isActive: true,
    createdAt: DateTime.now().subtract(Duration(days: 15)),
    updatedAt: DateTime.now().subtract(Duration(days: 1)),
  ),
  Supplier(
    id: 'sup2',
    name: 'OfficeMart Ltd.',
    contactPerson: 'John Otieno',
    email: 'john@officemart.com',
    phoneNumber: '+254799887766',
    address: 'Industrial Area, Plot 42',
    city: 'Mombasa',
    state: 'Coast',
    country: 'Kenya',
    postalCode: '80100',
    isActive: false,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now().subtract(Duration(days: 10)),
  ),
  Supplier(
    id: 'sup3',
    name: 'AgroChemicals Inc.',
    contactPerson: 'Grace Wanjiru',
    email: 'grace@agrochem.com',
    phoneNumber: '+254723456789',
    address: 'Thika Superhighway',
    city: 'Thika',
    state: 'Central',
    country: 'Kenya',
    postalCode: '01000',
    isActive: true,
    createdAt: DateTime.now().subtract(Duration(days: 90)),
    updatedAt: DateTime.now().subtract(Duration(days: 5)),
  ),
];
