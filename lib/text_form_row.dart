import 'package:flutter/material.dart';

class TextFormRow extends StatelessWidget {
  const TextFormRow({
    super.key,
    required this.label,
    this.errorText,
    this.onChanged,
    required this.controller,
  });

  final String label;
  final String? errorText;
  final void Function(String)? onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFfff4e9)),
            child: const Icon(
              Icons.lock_open,
              color: Color(0xffe5bd90),
            ),
          ),
          const SizedBox(width: 25.0),
          Flexible(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                errorText: errorText,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
