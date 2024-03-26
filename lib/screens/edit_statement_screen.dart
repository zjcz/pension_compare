import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/widgets/date_field.dart';
import 'package:pension_compare/widgets/pension_dropdown.dart';
import 'package:flutter/services.dart';

// TODO - Add delete button
class EditStatementScreen extends StatefulWidget {
  static const pensionKey = Key('pensionId');
  static const statementDateKey = Key('statementDate');
  static const planValueKey = Key('planValue');
  static const projectedAnnualAmountKey = Key('projectedAnnualAmount');
  static const yearlyChargesKey = Key('yearlyCharges');
  static const transferValueKey = Key('transferValue');

  // If editing, this is the statement record we are editing.
  // If adding new this will be null
  final Statement? statement;
  final DatabaseService? databaseService;

  const EditStatementScreen({super.key, this.statement, this.databaseService});

  @override
  State<EditStatementScreen> createState() => _EditStatmentScreenState();
}

class _EditStatmentScreenState extends State<EditStatementScreen> {
  TextEditingController planValueController = TextEditingController();
  TextEditingController projectedAnnualAmountController =
      TextEditingController();
  TextEditingController yearlyChargesController = TextEditingController();
  TextEditingController transferValueController = TextEditingController();
  DateTime? _statementDate;
  int? _pensionId;
  Future<List<Pension>>? _pensions;

  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadData();

    if (widget.statement != null) {
      _pensionId = widget.statement!.pension;
      _statementDate = widget.statement!.statementDate;

      planValueController.text =
          CurrencyHelper.formatCurrency(widget.statement!.planValue);
      projectedAnnualAmountController.text = CurrencyHelper.formatCurrency(
          widget.statement!.projectedAnnualAmount);
      yearlyChargesController.text =
          CurrencyHelper.formatCurrency(widget.statement!.yearlyCharges);
      transferValueController.text =
          CurrencyHelper.formatCurrency(widget.statement!.transferValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                widget.statement == null ? 'Add Statement' : 'Edit Statement'),
            actions: [
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
                  PensionDropdown(
                      key: EditStatementScreen.pensionKey,
                      pensionList: _pensions!,
                      pensionId: _pensionId,
                      onChanged: (value) {
                        setState(() {
                          _pensionId = value;
                        });
                        _unsavedChanges = true;
                      },
                      onValidate: (value) {
                        if (value == null) {
                          return "Please select a valid pension";
                        }
                        return null;
                      }),
                  CustomStyles.spacerBox,
                  const Text(
                      'Enter the following values found on your annual statement:',
                      style: CustomStyles.infoTextStyle),
                  CustomStyles.spacerBox,
                  DateField(
                    key: EditStatementScreen.statementDateKey,
                    initialDate: _statementDate,
                    labelText: 'Statement Date',
                    onDateSelected: (DateTime? value) {
                      _statementDate = value;
                      _unsavedChanges = true;
                    },
                    onValidate: (DateTime? value) {
                      if (value == null) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  CustomStyles.spacerBox,
                  TextFormField(
                    key: EditStatementScreen.planValueKey,
                    controller: planValueController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Plan Value"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          CurrencyHelper.parseCurrency(value) == null) {
                        return "Please enter a value, or 0 if unknown";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  CustomStyles.spacerBox,
                  TextFormField(
                    key: EditStatementScreen.projectedAnnualAmountKey,
                    controller: projectedAnnualAmountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: "Projected Yearly Amount"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          CurrencyHelper.parseCurrency(value) == null) {
                        return "Please enter a value, or 0 if unknown";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  CustomStyles.spacerBox,
                  TextFormField(
                    key: EditStatementScreen.yearlyChargesKey,
                    controller: yearlyChargesController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: "Yearly Charges"),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (CurrencyHelper.parseCurrency(value) == null) {
                          return "Please enter a valid number";
                        }
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  CustomStyles.spacerBox,
                  TextFormField(
                    key: EditStatementScreen.transferValueKey,
                    controller: transferValueController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        const InputDecoration(labelText: "Transfer Value"),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (CurrencyHelper.parseCurrency(value) == null) {
                          return "Please enter a valid number";
                        }
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
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

  void _loadData() {
    DatabaseService db = _getDatabaseService();
    _pensions = db.getAllPensions();
  }

  Future<bool> _saveData() async {
    DatabaseService db = _getDatabaseService();

    if (widget.statement == null) {
      await db.createStatement(
          _pensionId!,
          _statementDate!,
          CurrencyHelper.parseCurrency(planValueController.text)!,
          CurrencyHelper.parseCurrency(projectedAnnualAmountController.text)!,
          CurrencyHelper.parseCurrency(yearlyChargesController.text),
          CurrencyHelper.parseCurrency(transferValueController.text));
    } else {
      await db.updateStatement(
          widget.statement!.statementId,
          _pensionId!,
          _statementDate!,
          double.parse(planValueController.text),
          double.parse(projectedAnnualAmountController.text),
          double.tryParse(yearlyChargesController.text),
          double.tryParse(transferValueController.text));
    }

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
