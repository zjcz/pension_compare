import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/currency_helper.dart';

class EditStatePensionScreen extends StatefulWidget {
  static const yearlyValueKey = Key('yearlyValue');

  final DatabaseService? databaseService;

  const EditStatePensionScreen({super.key, this.databaseService});

  @override
  State<EditStatePensionScreen> createState() => _EditStatePensionScreenState();
}

class _EditStatePensionScreenState extends State<EditStatePensionScreen> {
  TextEditingController yearlyValueController = TextEditingController();

  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('State Pension'), actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: context.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: Text('Save',
                style: TextStyle(
                  backgroundColor: context.primary,
                  color: context.onPrimary,
                )),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (!await _saveData()) {
                  // an error occurred and we cannot save?
                  // TODO Log and report error
                  return;
                }

                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            },
          ),
        ]),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            canPop: !_unsavedChanges,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              _showSaveChangesDialog();
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: EditStatePensionScreen.yearlyValueKey,
                    controller: yearlyValueController,
                    decoration:
                        const InputDecoration(labelText: "Yearly Value"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value, or 0 if unknown";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  CustomStyles.spacerBox,
                  const Text(
                      "This is the yearly value you will receive from your state pension.  If you don't know this you can find the amount here:",
                      style: CustomStyles.infoTextStyle),
                  const Text('gov.uk/check-state-pension'),
                ],
              ),
            ),
          ),
        ));
  }

  DatabaseService _getDatabaseService() {
    return (widget.databaseService == null)
        ? DatabaseService.withDefaultConnection()
        : widget.databaseService!;
  }

  Future<void> _loadData() async {
    DatabaseService db = _getDatabaseService();
    StatePension? pension = await db.getStatePension();
    if (pension != null) {
      yearlyValueController.text =
          CurrencyHelper.formatCurrency(pension.projectedAnnualAmount);
    }
  }

  Future<bool> _saveData() async {
    DatabaseService db = _getDatabaseService();
    await db.saveStatePension(double.tryParse(yearlyValueController.text) ?? 0);

    return true;
  }

  Future<void> _showSaveChangesDialog() async {
    final bool? shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Any unsaved changes will be lost!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes, discard my changes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('No, continue editing'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (shouldDiscard ?? false) {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
