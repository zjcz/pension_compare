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
  static const statementDeleteKey = Key('deleteButton');

  // If editing, this is the statement record we are editing.
  // If adding new this will be null
  final Statement? statement;
  final Pension? parentPension;
  final DatabaseService databaseService;

  const EditStatementScreen(
      {super.key,
      this.parentPension,
      this.statement,
      required this.databaseService});

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
    } else if (widget.parentPension != null) {
      _pensionId = widget.parentPension!.pensionId;
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
                  // only show the delete button and spacer if the statement has been saved
                  if (widget.statement != null) ...[
                    CustomStyles.spacerBox,
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          key: EditStatementScreen.statementDeleteKey,
                          onPressed: () async {
                            await _showDeleteDialog();
                          },
                          style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          )),
                    )
                  ],
                ],
              ),
            ),
          ),
        ));
  }

  void _loadData() {
    DatabaseService db = widget.databaseService;
    _pensions = db.getAllPensions();
  }

  Future<bool> _saveData() async {
    DatabaseService db = widget.databaseService;

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
          CurrencyHelper.parseCurrency(planValueController.text)!,
          CurrencyHelper.parseCurrency(projectedAnnualAmountController.text)!,
          CurrencyHelper.parseCurrency(yearlyChargesController.text),
          CurrencyHelper.parseCurrency(transferValueController.text));
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

  Future<void> _showDeleteDialog() async {
    if (widget.statement != null) {
      final bool? shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete This Statement?'),
            content:
                const Text('Are you sure you want to delete this statement?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  await widget.databaseService
                      .deleteStatement(widget.statement!.statementId);

                  if (!context.mounted) return;
                  Navigator.pop(context, false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Statement removed successfully!'),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
