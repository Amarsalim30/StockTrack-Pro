import 'supplier_view_model.dart';
import '../../domain/entities/catalog/supplier.dart';

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
    contactInfo: {
      'contactPerson': 'Alice Mwende',
      'email': 'alice@techworld.com',
      'phoneNumber': '+254712345678',
      'address': '456 Westlands Road',
      'city': 'Nairobi',
      'state': 'Nairobi',
      'country': 'Kenya',
      'postalCode': '00100',
    },
    rating: 4.5,
    paymentTerms: 'Net 30',
  ),
  Supplier(
    id: 'sup2',
    name: 'OfficeMart Ltd.',
    contactInfo: {
      'contactPerson': 'John Otieno',
      'email': 'john@officemart.com',
      'phoneNumber': '+254799887766',
      'address': 'Industrial Area, Plot 42',
      'city': 'Mombasa',
      'state': 'Coast',
      'country': 'Kenya',
      'postalCode': '80100',
    },
    rating: 3.8,
    paymentTerms: 'Net 15',
  ),
  Supplier(
    id: 'sup3',
    name: 'AgroChemicals Inc.',
    contactInfo: {
      'contactPerson': 'Grace Wanjiru',
      'email': 'grace@agrochem.com',
      'phoneNumber': '+254723456789',
      'address': 'Thika Superhighway',
      'city': 'Thika',
      'state': 'Central',
      'country': 'Kenya',
      'postalCode': '01000',
    },
    rating: 4.2,
    paymentTerms: 'Net 45',
  ),
];
