import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/service_locator.dart';

class ChangePasscodeScreen extends StatefulWidget {
  final DatabaseService databaseService;
  const ChangePasscodeScreen({super.key, required this.databaseService});

  @override
  State<ChangePasscodeScreen> createState() => _ChangePasscodeScreenState();
}

class _ChangePasscodeScreenState extends State<ChangePasscodeScreen> {
  TextEditingController existingPasscodeController = TextEditingController();
  TextEditingController newPasscodeController = TextEditingController();
  TextEditingController repeatPasscodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitPasscode() async {
    final PasscodeService passcodeService = getIt<PasscodeService>();
    if (await passcodeService
        .validatePasscode(existingPasscodeController.text)) {
      passcodeService.setPasscode(newPasscodeController.text,
          databaseService: widget.databaseService);
      if (!mounted) return;
      context.pop();
    } else {
      // error
      print("error");
    }
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
                'Enter your existing 6-digit passcode:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                child: TextFormField(
                  controller: existingPasscodeController,
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
                'Enter your new 6-digit passcode:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                child: TextFormField(
                  controller: newPasscodeController,
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
                'Repeat your new 6-digit passcode:',
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
                  validator: (value) => value != newPasscodeController.text
                      ? 'New passcodes do not match'
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
