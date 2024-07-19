import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/passcode/views/widgets/passcode_field.dart';
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
        title: const Text('Change Passcode'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isExistingPasscodeInvalid)
                    const Text('Existing passcode incorrect. Please try again.',
                        style: TextStyle(color: Colors.red)),
                  const Text(
                    'Enter your existing passcode:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: 200,
                      child: PasscodeField(
                        key: ChangePasscodeScreen.existingPasscodeTextField,
                        passcodeController: existingPasscodeController,
                        autoFocus: true,
                        passcodeInvalidMessage: 'Existing passcode is invalid',
                      )),
                  const SizedBox(height: 16),
                  if (_isNewPasscodeInvalid)
                    const Text('New passcode incorrect. Please try again.',
                        style: TextStyle(color: Colors.red)),
                  const Text(
                    'Enter your new 4 to 10 digit passcode:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: 200,
                      child: PasscodeField(
                        key: ChangePasscodeScreen.newPasscodeTextField,
                        passcodeController: newPasscodeController,
                        passcodeInvalidMessage: 'New passcode is invalid',
                      )),
                  const SizedBox(height: 16),
                  const Text(
                    'Repeat your new passcode:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: 200,
                      child: PasscodeField(
                        key: ChangePasscodeScreen.repeatPasscodeTextField,
                        passcodeController: repeatPasscodeController,
                        passcodeInvalidMessage: 'Repeat passcode is invalid',
                        validator: (passcode) {
                          if (passcode != newPasscodeController.text) {
                            return 'New passcodes do not match';
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
    );
  }
}
