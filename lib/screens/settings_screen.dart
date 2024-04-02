import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/settings/settings.dart';
import 'package:pension_compare/settings/settings_service.dart';
import 'package:pension_compare/widgets/date_field.dart';
import 'package:pension_compare/helpers/currency_helper.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  static const settingRetirementDateKey = Key('retirementDate');
  static const settingTargetIncomeKey = Key('targetIncome');

  const SettingsScreen({super.key, required this.settingsService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController targetIncomeController = TextEditingController();
  DateTime? _retirementDate;

  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings'), actions: [
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
        body: SafeArea(
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
                  child: FutureBuilder<Settings>(
                      future: widget.settingsService.getSettings(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading settings: ${snapshot.error}'));
                        } else {
                          final Settings settings = snapshot.data!;
                          _retirementDate = settings.retirementDate;
                          targetIncomeController.text =
                              CurrencyHelper.formatCurrency(
                                  settings.targetIncome);

                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DateField(
                                  key: SettingsScreen.settingRetirementDateKey,
                                  initialDate: _retirementDate,
                                  labelText: 'Planned Retirement Date',
                                  onDateSelected: (DateTime? value) {
                                    _retirementDate = value;
                                    _unsavedChanges = true;
                                  },
                                ),
                                CustomStyles.spacerBox,
                                const Text(
                                    'This is the date you plan to retire.',
                                    style: CustomStyles.infoTextStyle),
                                CustomStyles.spacerBox,
                                TextFormField(
                                  key: SettingsScreen.settingTargetIncomeKey,
                                  controller: targetIncomeController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: "Target Monthly Income"),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (CurrencyHelper.parseCurrency(value) ==
                                          null) {
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
                                const Text(
                                    'This is the amount you plan to receive as monthly income when you retire.  If you are unsure you can leave this blank for now.',
                                    style: CustomStyles.infoTextStyle),
                              ]);
                        }
                      })),
            ),
          ),
        ));
  }

  Future<bool> _saveData() async {
    widget.settingsService.saveSettings(Settings(
        retirementDate: _retirementDate,
        targetIncome:
            CurrencyHelper.parseCurrency(targetIncomeController.text)));

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
