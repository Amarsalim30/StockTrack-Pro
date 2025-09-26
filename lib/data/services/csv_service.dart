import 'package:dartz/dartz.dart';
import '../../domain/entities/catalog/product.dart';
import '../../core/error/failures.dart';

class CsvService {
  static const String _csvHeader =
      'Name,SKU,Description,Category ID,Supplier ID,Unit ID,Price,Cost Price,Tags,Is Active';

  /// Export products to CSV format
  static Either<Failure, String> exportProductsToCsv(List<Product> products) {
    try {
      if (products.isEmpty) {
        return const Right(_csvHeader);
      }

      final csvLines = <String>[_csvHeader];

      for (final product in products) {
        final tags = product.tags?.join(';') ?? '';
        final isActive = product.isActive ? 'true' : 'false';

        final line = [
          _escapeCsvField(product.name),
          _escapeCsvField(product.sku),
          _escapeCsvField(product.description ?? ''),
          _escapeCsvField(product.categoryId),
          _escapeCsvField(product.supplierId),
          _escapeCsvField(product.unitId ?? ''),
          _escapeCsvField(product.price?.toString() ?? ''),
          _escapeCsvField(product.costPrice?.toString() ?? ''),
          _escapeCsvField(tags),
          _escapeCsvField(isActive),
        ].join(',');

        csvLines.add(line);
      }

      return Right(csvLines.join('\n'));
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to export products to CSV: ${e.toString()}',
        ),
      );
    }
  }

  /// Import products from CSV content
  static Either<Failure, List<Product>> importProductsFromCsv(
    String csvContent,
  ) {
    try {
      if (csvContent.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'CSV content is empty'));
      }

      final lines = csvContent.split('\n');
      if (lines.length < 2) {
        return const Left(
          ValidationFailure(
            message: 'CSV must have at least a header and one data row',
          ),
        );
      }

      // Skip header line
      final dataLines = lines
          .skip(1)
          .where((line) => line.trim().isNotEmpty)
          .toList();
      final products = <Product>[];

      for (int i = 0; i < dataLines.length; i++) {
        final line = dataLines[i];
        final fields = _parseCsvLine(line);

        if (fields.length < 10) {
          return Left(
            ValidationFailure(
              message:
                  'Row ${i + 2} has insufficient columns. Expected 10, got ${fields.length}',
            ),
          );
        }

        try {
          final product = _parseProductFromCsvFields(fields, i + 2);
          products.add(product);
        } catch (e) {
          return Left(
            ValidationFailure(
              message: 'Error parsing row ${i + 2}: ${e.toString()}',
            ),
          );
        }
      }

      return Right(products);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to import products from CSV: ${e.toString()}',
        ),
      );
    }
  }

  /// Validate CSV format
  static Either<Failure, bool> validateCsvFormat(String csvContent) {
    try {
      if (csvContent.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'CSV content is empty'));
      }

      final lines = csvContent.split('\n');
      if (lines.length < 2) {
        return const Left(
          ValidationFailure(
            message: 'CSV must have at least a header and one data row',
          ),
        );
      }

      // Check header
      final header = lines[0].trim();
      if (header != _csvHeader) {
        return const Left(
          ValidationFailure(message: 'Invalid CSV header format'),
        );
      }

      // Check data rows
      final dataLines = lines
          .skip(1)
          .where((line) => line.trim().isNotEmpty)
          .toList();
      for (int i = 0; i < dataLines.length; i++) {
        final line = dataLines[i];
        final fields = _parseCsvLine(line);

        if (fields.length != 10) {
          return Left(
            ValidationFailure(
              message: 'Row ${i + 2} has ${fields.length} columns, expected 10',
            ),
          );
        }

        // Validate required fields
        if (fields[0].trim().isEmpty) {
          return Left(
            ValidationFailure(message: 'Row ${i + 2}: Name is required'),
          );
        }
        if (fields[1].trim().isEmpty) {
          return Left(
            ValidationFailure(message: 'Row ${i + 2}: SKU is required'),
          );
        }
        if (fields[3].trim().isEmpty) {
          return Left(
            ValidationFailure(message: 'Row ${i + 2}: Category ID is required'),
          );
        }
        if (fields[4].trim().isEmpty) {
          return Left(
            ValidationFailure(message: 'Row ${i + 2}: Supplier ID is required'),
          );
        }
      }

      return const Right(true);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to validate CSV format: ${e.toString()}',
        ),
      );
    }
  }

  /// Get CSV template
  static Either<Failure, String> getCsvTemplate() {
    try {
      final template = [
        _csvHeader,
        'Sample Product,SKU001,Sample description,category_id_1,supplier_id_1,unit_id_1,10.50,8.00,tag1;tag2,true',
        'Another Product,SKU002,Another description,category_id_2,supplier_id_2,unit_id_2,25.00,20.00,tag3,true',
      ].join('\n');

      return Right(template);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to generate CSV template: ${e.toString()}',
        ),
      );
    }
  }

  /// Parse a CSV line handling quoted fields
  static List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          // Escaped quote
          buffer.write('"');
          i++; // Skip next quote
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        fields.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    fields.add(buffer.toString());
    return fields;
  }

  /// Escape CSV field for proper formatting
  static String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      // Escape quotes by doubling them and wrap in quotes
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }

  /// Parse product from CSV fields
  static Product _parseProductFromCsvFields(
    List<String> fields,
    int rowNumber,
  ) {
    final name = fields[0].trim();
    final sku = fields[1].trim();
    final description = fields[2].trim().isEmpty ? null : fields[2].trim();
    final categoryId = fields[3].trim();
    final supplierId = fields[4].trim();
    final unitId = fields[5].trim().isEmpty ? null : fields[5].trim();

    final price = fields[6].trim().isEmpty
        ? null
        : double.tryParse(fields[6].trim());
    final costPrice = fields[7].trim().isEmpty
        ? null
        : double.tryParse(fields[7].trim());

    final tagsString = fields[8].trim();
    final tags = tagsString.isEmpty
        ? null
        : tagsString
              .split(';')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList();

    final isActiveString = fields[9].trim().toLowerCase();
    final isActive =
        isActiveString == 'true' ||
        isActiveString == '1' ||
        isActiveString == 'yes';

    if (name.isEmpty) {
      throw Exception('Name is required');
    }
    if (sku.isEmpty) {
      throw Exception('SKU is required');
    }
    if (categoryId.isEmpty) {
      throw Exception('Category ID is required');
    }
    if (supplierId.isEmpty) {
      throw Exception('Supplier ID is required');
    }

    return Product(
      id: '', // Will be generated by the repository
      name: name,
      sku: sku,
      description: description,
      categoryId: categoryId,
      supplierId: supplierId,
      unitId: unitId,
      price: price,
      costPrice: costPrice,
      tags: tags,
      isActive: isActive,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
