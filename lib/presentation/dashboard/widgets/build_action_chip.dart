import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildActionChip({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(6),
    child: Container(

      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: Colors.grey.shade300, style: BorderStyle.solid, width: 1),
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    ),
  );
}
