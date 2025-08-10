class ToggleStockSelectionUseCase {
  Set<String> call(Set<String> selectedIds, String stockId) {
    final updated = Set<String>.from(selectedIds);
    if (updated.contains(stockId)) {
      updated.remove(stockId);
    } else {
      updated.add(stockId);
    }
    return updated;
  }
}
