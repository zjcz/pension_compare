import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({super.key});

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  TextEditingController passcodeController = TextEditingController();
  TextEditingController repeatPasscodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitPasscode() {
    // TODO: Implement your logic for validating the passcode here
    print('Passcode entered: ${passcodeController.text}');
    getIt<PasscodeService>().setPasscode(passcodeController.text);
    context.go(RouteDefs.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Passcode'),
      ),
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your 6-digit passcode:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                child: TextFormField(
                  autofocus: true,
                  controller: passcodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Repeat your 6-digit passcode:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                child: TextFormField(
                  controller: repeatPasscodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
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
    );
  }
}
