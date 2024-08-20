import 'package:flutter/material.dart';

class CustomDataPicker extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onDateSelected;
  final String formattedDate;

  const CustomDataPicker({
    required this.date,
    required this.onDateSelected,
    required this.formattedDate,
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2030),
              locale: const Locale('ru', 'RU'),
              builder: (final context, final child) => Theme(
                data: theme.copyWith(
                  colorScheme: theme.colorScheme.copyWith(
                    primary: theme.primaryColor,
                    onSurface: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                child: child!,
              ),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.primaryColor,
            padding: EdgeInsets.zero,
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
