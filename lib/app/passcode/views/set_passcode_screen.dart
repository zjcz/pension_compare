import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/passcode/views/widgets/passcode_field.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

class SetPasscodeScreen extends StatefulWidget {
  static const passcodeTextField = Key('passcode');
  static const repeatPasscodeTextField = Key('repeatPasscode');

  const SetPasscodeScreen({super.key});

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  bool _isPasscodeInvalid = false;
  TextEditingController passcodeController = TextEditingController();
  TextEditingController repeatPasscodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitPasscode() {
    if (_formKey.currentState!.validate()) {
      if (getIt<PasscodeService>().setPasscode(passcodeController.text)) {
        context.go(RouteDefs.home);
      } else {
        setState(() {
          _isPasscodeInvalid = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Passcode'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isPasscodeInvalid)
                  const Text('Passcode incorrect. Please try again.',
                      style: TextStyle(color: Colors.red)),
                const Text(
                  'Enter your 4 to 10 digit passcode:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                SizedBox(
                    width: 200,
                    child: PasscodeField(
                      key: SetPasscodeScreen.passcodeTextField,
                      passcodeController: passcodeController,
                      autoFocus: true,
                      passcodeInvalidMessage: 'Passcode is invalid',
                      onChanged: (_) {
                        if (_isPasscodeInvalid) {
                          setState(() {
                            _isPasscodeInvalid = false;
                          });
                        }
                      },
                    )),
                const SizedBox(height: 16),
                const Text(
                  'Repeat your passcode:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  child: PasscodeField(
                    key: SetPasscodeScreen.repeatPasscodeTextField,
                    passcodeController: repeatPasscodeController,
                    passcodeInvalidMessage: 'Repeat passcode is invalid',
                    onChanged: (_) {
                      if (_isPasscodeInvalid) {
                        setState(() {
                          _isPasscodeInvalid = false;
                        });
                      }
                    },
                    validator: (value) => value != passcodeController.text
                        ? 'Passcodes do not match'
                        : null,
                  ),
                ),
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
    );
  }
}
