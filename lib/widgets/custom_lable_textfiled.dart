import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final IconData icon;
  final bool readOnly;
  final String? hint;
  final TextInputType? keyboardType;
  final int? maxLength;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.readOnly = false,
    this.hint,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          enableInteractiveSelection: !readOnly,
          showCursor: !readOnly,
          autofocus: false,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            counterText: "",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey.shade200 : null,
          ),
        ),
      ],
    );
  }
}
