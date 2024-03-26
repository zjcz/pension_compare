import 'package:flutter/material.dart';
import 'package:pension_compare/helpers/date_helper.dart';

class DateField extends StatelessWidget {
  final String? labelText;
  final DateTime? initialDate;
  final Function(DateTime?)? onDateSelected;
  final String? Function(DateTime?)? onValidate;
  final TextEditingController fieldController = TextEditingController();

  DateField(
      {super.key,
      this.initialDate,
      this.labelText,
      this.onDateSelected,
      this.onValidate});

  @override
  Widget build(BuildContext context) {
    fieldController.text =
        (initialDate == null ? "" : DateHelper.formatDate(initialDate!));

    return TextFormField(
      controller: fieldController,
      decoration: InputDecoration(
          icon: const Icon(Icons.calendar_today), //icon of text field
          labelText: labelText),
      readOnly: true, // when true user cannot edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          if (onDateSelected != null) {
            onDateSelected!(pickedDate);

            fieldController.text = DateHelper.formatDate(pickedDate);
          }
        }
      },
      validator: (value) {
        if (onValidate != null) {
          DateTime? dtValue = (value == null || value.isEmpty)
              ? null
              : DateHelper.parseDate(value);

          return onValidate!(dtValue);
        }
        return null;
      },
    );
  }
}
