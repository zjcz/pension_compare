import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/widgets/analytics_opt_in.dart';
import 'package:pension_compare/widgets/date_field.dart';

class EditSettingsWidget extends ConsumerStatefulWidget {
  static const editSettingRetirementDateKey = Key('retirementDate');
  static const editSettingTargetIncomeKey = Key('targetIncome');
  static const editSettingOptIntoAnalyticsKey = Key('optIntoAnalytics');

  final EditSettingsData userSettings;
  final Function(EditSettingsData) onChanged;

  const EditSettingsWidget(
      {super.key, required this.userSettings, required this.onChanged});

  @override
  ConsumerState<EditSettingsWidget> createState() => _EditSettingsWidgetState();
}

class _EditSettingsWidgetState extends ConsumerState<EditSettingsWidget> {
  TextEditingController targetIncomeController = TextEditingController();
  DateTime? _retirementDate;
  bool _optIntoAnalyticsWarning = false;

  @override
  void initState() {
    super.initState();

    _retirementDate = widget.userSettings.retirementDate;
    targetIncomeController.text =
        CurrencyHelper.formatCurrency(widget.userSettings.targetIncome);
    _optIntoAnalyticsWarning = widget.userSettings.optIntoAnalyticsWarning;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DateField(
            key: EditSettingsWidget.editSettingRetirementDateKey,
            initialDate: _retirementDate,
            labelText: 'Planned Retirement Date',
            onDateSelected: (DateTime? value) {
              _retirementDate = value;
              _triggerOnChange();
            },
          ),
          CustomStyles.spacerBox,
          const Text('This is the date you plan to retire.',
              style: CustomStyles.infoTextStyle),
          CustomStyles.spacerBox,
          TextFormField(
            key: EditSettingsWidget.editSettingTargetIncomeKey,
            controller: targetIncomeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration:
                const InputDecoration(labelText: "Target Monthly Income"),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (CurrencyHelper.parseCurrency(value) == null) {
                  return "Please enter a valid number";
                }
              }
              return null;
            },
            onChanged: (val) {
              _triggerOnChange();
            },
          ),
          CustomStyles.spacerBox,
          const Text(
              'This is the amount you plan to receive as a monthly income when you retire.  If you are unsure you can leave this blank for now.',
              style: CustomStyles.infoTextStyle),
          CustomStyles.spacerBox,
          AnalyticsOptIn(
            key: EditSettingsWidget.editSettingOptIntoAnalyticsKey,
            optIntoAnalyticsValue: _optIntoAnalyticsWarning,
            onChanged: (newValue) {
              setState(() {
                _optIntoAnalyticsWarning = newValue;
              });
              _triggerOnChange();
            },
          ),
        ]);
  }

  void _triggerOnChange() {
    widget.onChanged(EditSettingsData(
        retirementDate: _retirementDate,
        targetIncome: CurrencyHelper.parseCurrency(targetIncomeController.text),
        optIntoAnalyticsWarning: _optIntoAnalyticsWarning));
  }

  @override
  void dispose() {
    targetIncomeController.dispose();

    super.dispose();
  }
}

class EditSettingsData {
  final DateTime? retirementDate;
  final double? targetIncome;
  final bool optIntoAnalyticsWarning;

  EditSettingsData(
      {this.retirementDate,
      this.targetIncome,
      required this.optIntoAnalyticsWarning});
}
