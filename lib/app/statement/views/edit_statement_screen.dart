import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/statement/controllers/statement_controller.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/widgets/date_field.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';

class EditStatementScreen extends ConsumerStatefulWidget {
  static const pensionKey = Key('pensionId');
  static const statementDateKey = Key('statementDate');
  static const planValueKey = Key('planValue');
  static const projectedAnnualAmountKey = Key('projectedAnnualAmount');
  static const yearlyChargesKey = Key('yearlyCharges');
  static const transferValueKey = Key('transferValue');
  static const paidInValueKey = Key('paidInValue');
  static const statementDeleteKey = Key('deleteButton');

  // If editing, this is the statement record we are editing.
  // If adding new this will be null
  final StatementModel? statement;
  final PensionModel? parentPension;

  const EditStatementScreen({super.key, this.parentPension, this.statement});

  @override
  ConsumerState<EditStatementScreen> createState() =>
      _EditStatmentScreenState();
}

class _EditStatmentScreenState extends ConsumerState<EditStatementScreen> {
  TextEditingController planValueController = TextEditingController();
  TextEditingController projectedAnnualAmountController =
      TextEditingController();
  TextEditingController yearlyChargesController = TextEditingController();
  TextEditingController transferValueController = TextEditingController();
  TextEditingController paidInValueController = TextEditingController();
  DateTime? _statementDate;
  int? _pensionId;
  String? _statementDateValidationError;

  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

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
      paidInValueController.text =
          CurrencyHelper.formatCurrency(widget.statement!.amountPaidIn);
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
                  if (await _validateStatementDate(_statementDate)) {
                    if (_formKey.currentState!.validate()) {
                      if (!await _saveData()) {
                        // an error occurred and we cannot save?
                        // TODO Log and report error
                        return;
                      }

                      if (!context.mounted) return;
                      if (_pensionId == null) {
                        Navigator.of(context).pop();
                      } else {
                        context.go('${RouteDefs.pensionOverview}/$_pensionId');
                      }
                    }
                  }
                },
              ),
            ]),
        body: SafeArea(
          minimum: const EdgeInsets.all(10.0),
          child: Container(
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
                      errorText: _statementDateValidationError,
                      onDateSelected: (DateTime? value) {
                        _statementDateValidationError = null;
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
                      decoration:
                          const InputDecoration(labelText: "Plan Value"),
                      validator: (value) {
                        if (!CurrencyHelper.validateCurrencyValue(value)) {
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
                        if (!CurrencyHelper.validateCurrencyValue(value)) {
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
                        if (!CurrencyHelper.validateCurrencyValue(value,
                            allowNull: true)) {
                          return "Please enter a valid number";
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
                        if (!CurrencyHelper.validateCurrencyValue(value,
                            allowNull: true)) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _unsavedChanges = true;
                      },
                    ),
                    CustomStyles.spacerBox,
                    TextFormField(
                      key: EditStatementScreen.paidInValueKey,
                      controller: paidInValueController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: false),
                      decoration:
                          const InputDecoration(labelText: "Amount Paid In"),
                      validator: (value) {
                        if (!CurrencyHelper.validateCurrencyValue(value,
                            allowNull: true)) {
                          return "Please enter a valid number";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        _unsavedChanges = true;
                      },
                    ),
                    const Text(
                        'This is the amount paid in during the statement period, not the total amount paid into the pension.',
                        style: CustomStyles.infoTextStyle),
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
          ),
        ));
  }

  Future<bool> _validateStatementDate(DateTime? statementDate) async {
    final controller = ref.read(statementControllerProvider(0).notifier);
    String? validationMsg;

    if (statementDate != null && _pensionId != null) {
      bool response = await controller.doesStatementDateExist(
          widget.statement?.statementId, _pensionId!, statementDate);

      if (response) {
        validationMsg = "A statement for this date already exists";
      }
    }

    setState(() {
      _statementDateValidationError = validationMsg;
    });

    return (validationMsg == null);
  }

  Future<bool> _saveData() async {
    final controller = ref.read(statementControllerProvider(0).notifier);

    if (widget.statement == null) {
      await controller.createStatement(
          _pensionId!,
          _statementDate!,
          CurrencyHelper.parseCurrency(planValueController.text)!,
          CurrencyHelper.parseCurrency(projectedAnnualAmountController.text)!,
          CurrencyHelper.parseCurrency(yearlyChargesController.text),
          CurrencyHelper.parseCurrency(transferValueController.text),
          CurrencyHelper.parseCurrency(paidInValueController.text));
    } else {
      await controller.updateStatement(
          widget.statement!.statementId!,
          _pensionId!,
          _statementDate!,
          CurrencyHelper.parseCurrency(planValueController.text)!,
          CurrencyHelper.parseCurrency(projectedAnnualAmountController.text)!,
          CurrencyHelper.parseCurrency(yearlyChargesController.text),
          CurrencyHelper.parseCurrency(transferValueController.text),
          CurrencyHelper.parseCurrency(paidInValueController.text));
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
    if (widget.statement != null && widget.statement!.statementId != null) {
      final bool? shouldDelete = await showDialog<bool>(
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
                  Navigator.pop(context, true);
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

      if (shouldDelete ?? false) {
        final controller = ref.read(statementControllerProvider(0).notifier);
        await controller.deleteStatement(widget.statement!.statementId!);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Statement removed successfully!'),
          ),
        );

        if (!context.mounted) return;
        context.go('${RouteDefs.pensionOverview}/${widget.statement!.pension}');
      }
    }
  }

  @override
  void dispose() {
    planValueController.dispose();
    projectedAnnualAmountController.dispose();
    yearlyChargesController.dispose();
    transferValueController.dispose();
    paidInValueController.dispose();

    super.dispose();
  }
}
