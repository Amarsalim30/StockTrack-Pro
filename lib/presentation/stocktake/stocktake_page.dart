import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../di/injection.dart';
import '../../domain/entities/stock/stock_take.dart';
import 'stocktake_view_model.dart';

class StockTakePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockTakeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Take Sessions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateSessionDialog(context, ref);
            },
          ),
        ],
      ),
      body: _buildBody(state, ref),
    );
  }

  Widget _buildBody(StockTakeState state, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }
    if (state.stockTakes.isEmpty) {
      return const Center(child: Text('No stock take sessions available'));
    }
    return ListView.builder(
      itemCount: state.stockTakes.length,
      itemBuilder: (context, index) {
        final session = state.stockTakes[index];
        return ListTile(
          title: Text(session.name),
          subtitle: Text('Status: ${session.status.name}'),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              _navigateToSessionDetails(context, session);
            },
          ),
          onTap: () {
            ref
                .read(stockTakeViewModelProvider.notifier)
                .resumeSession(session.id);
          },
        );
      },
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
