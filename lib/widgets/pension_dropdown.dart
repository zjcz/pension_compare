import 'package:flutter/material.dart';
import 'package:pension_compare/database/database_service.dart';

class PensionDropdown extends StatelessWidget {
  final Future<List<Pension>> pensionList;
  final int? pensionId;
  final Function(int?) onChanged;
  final String? Function(int?) onValidate;

  const PensionDropdown(
      {super.key,
      required this.pensionList,
      this.pensionId,
      required this.onChanged,
      required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pension>>(
      future: pensionList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No pensions found.  Click + to add one'));
        } else {
          final List<Pension> pensions = snapshot.data!;
          return DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Pension"),
              value: pensionId,
              //items: [DropdownMenuItem<int>(value: 1, child: Text("Test"))],
              items: pensions.map((p) {
                return DropdownMenuItem<int>(
                  value: p.pensionId,
                  child: Text(p.name),
                );
              }).toList(),
              validator: onValidate,
              onChanged: onChanged);
        }
      },
    );
  }
}
