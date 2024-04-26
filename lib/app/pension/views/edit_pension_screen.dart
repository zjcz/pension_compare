import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/widgets/date_field.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/app/pension/controllers/pension_controller.dart';

// TODO - Add delete button
class EditPensionScreen extends ConsumerStatefulWidget {
  static const pensionNameKey = Key('name');
  static const pensionMaturityDateKey = Key('maturityDate');
  static const pensionDeleteKey = Key('deleteButton');

  // If editing, this is the pension record we are editing.
  // If adding new this will be null
  final PensionModel? pension;

  const EditPensionScreen({super.key, this.pension});

  @override
  ConsumerState<EditPensionScreen> createState() => _EditPensionScreenState();
}

class _EditPensionScreenState extends ConsumerState<EditPensionScreen> {
  TextEditingController nameController = TextEditingController();
  DateTime? _maturityDate;
  String? _pensionNameValidationError;
  bool _unsavedChanges = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.pension != null) {
      nameController.text = widget.pension!.name;
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
                  if (await _validatePensionName(nameController.text)) {
                    if (_formKey.currentState!.validate()) {
                      if (!await _saveData()) {
                        // an error occurred and we cannot save?
                        // TODO Log and report error
                        return;
                      }

                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
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
                    decoration: InputDecoration(
                        labelText: "Name",
                        errorText: _pensionNameValidationError),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _pensionNameValidationError = null;
                      });
                      _unsavedChanges = true;
                    },
                  ),
                  CustomStyles.spacerBox,
                  const Text(
                      'This is a unique name you use to identify a pension policy.  It could be the name of the pension provider or the name of the workplace associated with the pension.  The choice is yours.',
                      style: CustomStyles.infoTextStyle),
                  CustomStyles.spacerBox,
                  DateField(
                    key: EditPensionScreen.pensionMaturityDateKey,
                    initialDate: _maturityDate,
                    labelText: 'Planned Retirement Date',
                    onDateSelected: (DateTime? value) {
                      _maturityDate = value;
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
                  const Text(
                      'This is the date you have set on this pension to retire.  You can have different dates for different pensions',
                      style: CustomStyles.infoTextStyle),
                  // only show the delete button and spacer if the pension has been saved
                  if (widget.pension != null) ...[
                    CustomStyles.spacerBox,
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          key: EditPensionScreen.pensionDeleteKey,
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

  Future<bool> _validatePensionName(String? pensionName) async {
    final controller = ref.read(pensionControllerProvider.notifier);
    String? validationMsg;

    if (pensionName != null && pensionName.isNotEmpty) {
      bool response = await controller.doesPensionNameExist(
          widget.pension?.pensionId, pensionName);

      if (response) {
        validationMsg = "This name is already in use";
      }
    }

    setState(() {
      _pensionNameValidationError = validationMsg;
    });

    return (validationMsg == null);
  }

  Future<bool> _saveData() async {
    final controller = ref.read(pensionControllerProvider.notifier);

    if (widget.pension == null) {
      await controller.createPension(nameController.text, _maturityDate!);
    } else {
      await controller.updatePension(
          widget.pension!.pensionId!, nameController.text, _maturityDate!);
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
      context.pop();
    }
  }

  Future<void> _showDeleteDialog() async {
    if (widget.pension != null && widget.pension!.pensionId != null) {
      final bool? shouldDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete This Pension?'),
            content: const Text(
                'Are you sure you want to delete this pension and any statements assigned to it?'),
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
        final controller = ref.read(pensionControllerProvider.notifier);
        await controller.deletePension(widget.pension!.pensionId!);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pension removed successfully!'),
          ),
        );

        context.go(RouteDefs.home);
      }
    }
  }
}
