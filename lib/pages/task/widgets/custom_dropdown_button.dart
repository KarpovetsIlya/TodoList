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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Важность',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        DropdownButton<String>(
          value: value,
          elevation: 16,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodyLarge?.color,
          ),
          underline: Container(
            height: 2,
            color: theme.dividerColor,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
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
