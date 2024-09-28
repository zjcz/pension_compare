import 'package:flutter/material.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/service_locator.dart';

class PasscodeField extends StatelessWidget {
  final TextEditingController passcodeController;
  final bool autoFocus;
  final String passcodeInvalidMessage;
  final Function(String)? validator;
  final Function(String)? onChanged;
  final String? autofillHint;

  const PasscodeField(
      {super.key,
      this.validator,
      this.onChanged,
      required this.passcodeController,
      this.autoFocus = false,
      this.autofillHint,
      this.passcodeInvalidMessage = 'Passcode is invalid'});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      autofillHints: [autofillHint ?? AutofillHints.password],
      controller: passcodeController,
      keyboardType: TextInputType.visiblePassword,
      maxLength: PasscodeService.maxPasscodeLength,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        counterText: '',
      ),
      validator: (passcode) {
        if (passcode == null ||
            passcode.isEmpty ||
            !getIt<PasscodeService>().validatePasscode(passcode)) {
          return passcodeInvalidMessage;
        } else if (validator != null) {
          return validator!(passcode);
        } else {
          return null;
        }
      },
      onChanged: onChanged,
    );
  }
}
