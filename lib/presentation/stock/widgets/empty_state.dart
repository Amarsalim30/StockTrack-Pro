import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

Widget emptyState(BuildContext context) {
  return ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.18),
      const Icon(LucideIcons.package, size: 64, color: Colors.black12),
      const SizedBox(height: 12),
      const Center(
        child: Text(
          'No items found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
      ),
      const SizedBox(height: 8),
      Center(child: Text('Tap "Add Stock" to create your first inventory item.', style: TextStyle(color: Colors.grey[700]))),
    ],
  );
}