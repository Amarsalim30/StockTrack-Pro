
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

AppBar buildAppBar() {
  return AppBar(
    backgroundColor: AppColors.slate[900],
    elevation: 0,
    titleSpacing: 16.0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'StockTrackPro',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Professional Inventory Management',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    ),
    centerTitle: false,
    actions: [
      IconButton(
        tooltip: 'Notifications',
        onPressed: () {},
        icon: const Icon(Icons.notifications_none, color: Colors.white),
      ),
      IconButton(
        tooltip: 'Account',
        onPressed: () {},
        icon: const Icon(Icons.account_circle_rounded, color: Colors.white),
      ),
      const SizedBox(width: 8),
    ],
  );
}