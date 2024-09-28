import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/passcode/views/widgets/passcode_field.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/service_locator.dart';

class ChangePasscodeScreen extends StatefulWidget {
  static const existingPasscodeTextField = Key('existingPasscode');
  static const newPasscodeTextField = Key('newPasscode');
  static const repeatPasscodeTextField = Key('repeatPasscode');

  final DatabaseService databaseService;
  const ChangePasscodeScreen({super.key, required this.databaseService});

  @override
  State<ChangePasscodeScreen> createState() => _ChangePasscodeScreenState();
}

class _ChangePasscodeScreenState extends State<ChangePasscodeScreen> {
  bool _isExistingPasscodeInvalid = false;
  bool _isNewPasscodeInvalid = false;
  TextEditingController existingPasscodeController = TextEditingController();
  TextEditingController newPasscodeController = TextEditingController();
  TextEditingController repeatPasscodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitPasscode() async {
    if (_formKey.currentState!.validate()) {
      final PasscodeService passcodeService = getIt<PasscodeService>();
      if (await passcodeService.testPasscode(existingPasscodeController.text)) {
        if (passcodeService.changePasscode(
            newPasscodeController.text, widget.databaseService)) {
          TextInput.finishAutofillContext();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully!'),
            ),
          );

          if (!mounted) return;
          context.pop();
        } else {
          setState(() {
            _isNewPasscodeInvalid = true;
          });
        }
      } else {
        setState(() {
          _isExistingPasscodeInvalid = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isExistingPasscodeInvalid)
                      const Text(
                          'Existing password incorrect. Please try again.',
                          style: TextStyle(color: Colors.red)),
                    const Text(
                      'Enter your existing password:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                        width: 200,
                        child: PasscodeField(
                          key: ChangePasscodeScreen.existingPasscodeTextField,
                          passcodeController: existingPasscodeController,
                          autoFocus: true,
                          passcodeInvalidMessage:
                              'Existing password is invalid',
                          autofillHint: AutofillHints.password,
                        )),
                    const SizedBox(height: 16),
                    if (_isNewPasscodeInvalid)
                      const Text('New password incorrect. Please try again.',
                          style: TextStyle(color: Colors.red)),
                    const Text(
                      'Enter your new password:',
                      style: TextStyle(fontSize: 18),
                    ),
                    CustomStyles.spacerBox,
                    const Text(
                        'Password can be any combination of letters, numbers and symbols (!@#%^&*(),.?":{}|<>), between 8 and 64 characters in length.',
                        style: CustomStyles.infoTextStyle),
                    const SizedBox(height: 16),
                    SizedBox(
                        width: 200,
                        child: PasscodeField(
                          key: ChangePasscodeScreen.newPasscodeTextField,
                          passcodeController: newPasscodeController,
                          passcodeInvalidMessage: 'New password is invalid',
                          autofillHint: AutofillHints.newPassword,
                        )),
                    const SizedBox(height: 16),
                    const Text(
                      'Repeat your new password:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                        width: 200,
                        child: PasscodeField(
                          key: ChangePasscodeScreen.repeatPasscodeTextField,
                          passcodeController: repeatPasscodeController,
                          passcodeInvalidMessage: 'Repeat password is invalid',
                          autofillHint: AutofillHints.newPassword,
                          validator: (passcode) {
                            if (passcode != newPasscodeController.text) {
                              return 'New passwords do not match';
                            } else {
                              return null;
                            }
                          },
                        )),
                    const SizedBox(height: 16),
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            onPressed: _submitPasscode,
                            style: TextButton.styleFrom(
                                side: BorderSide(color: context.primary),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                            child: const Text('Continue'))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    existingPasscodeController.dispose();
    newPasscodeController.dispose();
    repeatPasscodeController.dispose();

    super.dispose();
  }
}
