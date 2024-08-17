import 'package:flutter/material.dart';

class CustomDataPicker extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;
  final String formattedDate;

  const CustomDataPicker({
    super.key,
    required this.date,
    required this.onDateSelected,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сделать до',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        TextButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              locale: const Locale('ru', 'RU'),
              builder: (context, child) {
                return Theme(
                  data: theme.copyWith(
                    colorScheme: theme.colorScheme.copyWith(
                      primary: theme.primaryColor,
                      onSurface: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.primaryColor,
            padding: const EdgeInsets.all(0),
          ),
          child: Text(
            formattedDate,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
