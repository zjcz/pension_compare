import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/date_helper.dart';

// TODO - Add delete button
class EditPensionScreen extends StatefulWidget {
  static const pensionNameKey = Key('name');
  static const pensionMaturityDateKey = Key('maturityDate');

  // If editing, this is the pension record we are editing.
  // If adding new this will be null
  final Pension? pension;
  final DatabaseService? databaseService;

  const EditPensionScreen({super.key, this.pension, this.databaseService});

  @override
  State<EditPensionScreen> createState() => _EditPensionScreenState();
}

class _EditPensionScreenState extends State<EditPensionScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController maturityDateController = TextEditingController();
  DateTime? _maturityDate;

  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.pension != null) {
      nameController.text = widget.pension!.name;
      maturityDateController.text =
          DateHelper.formatDate(widget.pension!.maturityDate);
      _maturityDate = widget.pension!.maturityDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(widget.pension == null ? 'Add Pension' : 'Edit Pension'),
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
                  TextFormField(
                    key: EditPensionScreen.pensionNameKey,
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _unsavedChanges = true;
                    },
                  ),
                  CustomStyles.spacerBox,
                  const Text(
                      'This is a unique name you use to identify a pension policy.  It could be the name of the pension provider or the name of the workplace associated with the pension.  The choice is yours.',
                      style: CustomStyles.infoTextStyle),
                  CustomStyles.spacerBox,
                  TextFormField(
                    key: EditPensionScreen.pensionMaturityDateKey,
                    controller: maturityDateController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Planned Retirement Date"),
                    readOnly: true, // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _maturityDate,
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        _maturityDate = pickedDate;
                        setState(() {
                          _unsavedChanges = true;
                          maturityDateController.text =
                              DateHelper.formatDate(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a date";
                      }
                      return null;
                    },
                  ),
                  CustomStyles.spacerBox,
                  const Text(
                      'This is the date you have set on this pension to retire.  You can have different dates for different pensions',
                      style: CustomStyles.infoTextStyle),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _saveData() async {
    DatabaseService db = (widget.databaseService == null)
        ? DatabaseService.withDefaultConnection()
        : widget.databaseService!;

    if (widget.pension == null) {
      await db.createPension(nameController.text, _maturityDate!);
    } else {
      await db.updatePension(
          widget.pension!.pensionId, nameController.text, _maturityDate!);
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
