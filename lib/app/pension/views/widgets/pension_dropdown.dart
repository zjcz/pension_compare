import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/pension/controllers/pension_controller.dart';

class PensionDropdown extends ConsumerWidget {
  final int? pensionId;
  final Function(int?) onChanged;
  final String? Function(int?) onValidate;

  const PensionDropdown(
      {super.key,
      this.pensionId,
      required this.onChanged,
      required this.onValidate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pensionsList = ref.watch(pensionControllerProvider);
    return pensionsList.when(
        data: (pensions) {
          if (pensions.isEmpty) {
            return const Center(
                child: Text('No pensions found.  Click + to add one'));
          }
          return DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Pension"),
              value: pensionId,
              items: pensions.map((p) {
                return DropdownMenuItem<int>(
                  value: p.pensionId,
                  child: Text(p.name),
                );
              }).toList(),
              validator: onValidate,
              onChanged: onChanged);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading data: $error')));
  }
}
