import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildManageStockButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6),
    child: SizedBox(
      height: 36,
      width: 130,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E2330),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () {
          // navigate using GoRouter
          context.push('/manage-stock'); // make sure this route is defined in your GoRouter
        },
        child: const Text("Manage Stock"),
      ),
    ),
  );
}
