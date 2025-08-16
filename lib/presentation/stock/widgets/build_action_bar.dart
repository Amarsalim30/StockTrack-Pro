import 'package:clean_arch_app/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildActionBar(BuildContext context, WidgetRef ref) {
  final vm = ref.read(stockViewModelProvider.notifier);
  final state = ref.watch(stockViewModelProvider);

  if (state.isBulkSelectionMode) {
    return Row(
      children: [
        _buildMinimalAction(
          label: "Export Selected",
          onPressed: vm.exportSelected,
          isPrimary: true,
        ),
        _buildMinimalAction(
          label: "Deselect All",
          onPressed: vm.clearSelection,
        ),
      ],
    );
  } else if (state.stocks.isEmpty) {
    return Row(
      children: [
        _buildMinimalAction(
          label: "Import New",
          onPressed: vm.importNew,
          isPrimary: true,
        ),
      ],
    );
  } else {
    return Row(
      children: [
        _buildMinimalAction(
          label: "Import New",
          onPressed: vm.importNew,
          isPrimary: true,
        ),
        _buildMinimalAction(
          label: "Append",
          onPressed: vm.appendData,
        ),
        _buildMinimalAction(
          label: "Export Template",
          onPressed: vm.exportTemplate,
        ),
      ],
    );
  }
}

Widget _buildMinimalAction({
  required String label,
  required VoidCallback onPressed,
  bool isPrimary = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 6),
    child: InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onPressed,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF0E2330), // subtle dark background
          borderRadius: BorderRadius.circular(4),    // slightly rectangular
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isPrimary
                ? Colors.blue // faint blue for primary actions
                : Colors.white.withOpacity(0.9),
            fontSize: 12, // compact
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}
