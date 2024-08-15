import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const CustomDropdownButton({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Важность',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        DropdownButton<String>(
          value: value,
          elevation: 16,
          style: TextStyle(color: Colors.grey[600], fontSize: 15),
          underline: Container(
            height: 2,
            color: Colors.grey[200],
          ),
          onChanged: (dynamic newValue) {
            onChanged(newValue as String); // Приведение типа
          },
          items: options.map<DropdownMenuItem<String>>((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
