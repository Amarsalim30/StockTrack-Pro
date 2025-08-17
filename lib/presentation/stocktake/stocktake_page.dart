import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:clean_arch_app/presentation/stocktake/widgets/stock_take_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../di/injection.dart';
import '../../domain/entities/stock/stock_take.dart';
import 'widgets/selection_stock_take.dart';
import 'stock_state.dart';
import 'stocktake_view_model.dart';

class StockTakePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockTakeViewModelProvider);
    final viewModel = ref.watch(stockTakeViewModelProvider.notifier);

    return Scaffold(
      appBar: ProductionTopAppBar(),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? Center(child: Text('Error: ${state.error}'))
            : state.stockTakes.isEmpty
            ? const Center(
            child: Text('No stock take sessions available'))
            : ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 16),
          children: [
            // StockTakeStats(),
            FiltersSelection(),
            const SizedBox(height: 12),
            // ...state.stockTakes.map(
            //       (session) => ListTile(
            //     title: Text(session.name),
            //     subtitle: Text('Status: ${session.status.name}'),
            //     trailing: IconButton(
            //       icon: const Icon(Icons.arrow_forward_ios),
            //       onPressed: () {
            //         _navigateToSessionDetails(context, session);
            //       },
            //     ),
            //     onTap: () {
            //       ref
            //           .read(stockTakeViewModelProvider.notifier)
            //           .resumeSession(session.id);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSessionDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateSessionDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Session'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Session Name'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                ref
                    .read(stockTakeViewModelProvider.notifier)
                    .startNewSession(name: nameController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSessionDetails(BuildContext context, StockTake session) {
    context.push('/stocktake/${session.id}');
  }
}
