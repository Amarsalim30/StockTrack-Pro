import '../../domain/entities/stock/stock_take.dart';

enum _StockTakeStatus { inProgress, completed, paused }

final List<StockTake> mockStockTakes = [
  StockTake(
    id: '1',
    name: 'January 2025 Stock Count',
    status: StockTakeStatus.completed,
    startDate: DateTime(2025, 3, 15),
    createdBy: '',
    assignedTo: [],
    totalItems: 1,
    countedItems: 15,
    discrepancies: 1,
  ),
  StockTake(
    id: '2',
    name: 'Mid-February Audit',
    status: StockTakeStatus.completed,
    startDate: DateTime(2025, 2, 25),
    createdBy: '',
    assignedTo: [],
    totalItems: 4,
    countedItems: 5,
    discrepancies: 7,
  ),
  StockTake(
    id: '3',
    name: 'End of Quarter Stock Check',
    status: StockTakeStatus.paused,
    startDate: DateTime(2025, 2, 15),
    createdBy: '',
    assignedTo: [],
    totalItems: 1,
    countedItems: 5,
    discrepancies: 7,
  ),
];
