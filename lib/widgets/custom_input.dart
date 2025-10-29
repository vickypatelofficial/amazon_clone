import 'package:flutter/material.dart';
import '../core/app_colors.dart';

InputDecoration appInput(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primaryColor.withOpacity(0.7)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          BorderSide(color: AppColors.primaryColor.withOpacity(0.6), width: 2),
    ),
  );
}
