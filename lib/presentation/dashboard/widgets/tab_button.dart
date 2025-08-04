import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const TabButton({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.indigo : Colors.grey,
        ),
      ),
    );
  }
}
