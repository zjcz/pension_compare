import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

class EnterPasscodeScreen extends StatefulWidget {
  const EnterPasscodeScreen({super.key});

  @override
  State<EnterPasscodeScreen> createState() => _EnterPasscodeScreenState();
}

class _EnterPasscodeScreenState extends State<EnterPasscodeScreen> {
  bool _isPasscodeInvalid = false;
  TextEditingController passcodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitPasscode() async {
    final PasscodeService passcodeService = getIt<PasscodeService>();
    if (await passcodeService.validatePasscode(passcodeController.text)) {
      passcodeService.setPasscode(passcodeController.text);
      if (!mounted) return;
      context.go(RouteDefs.home);
    } else {
      setState(() {
        _isPasscodeInvalid = true;
      });
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isPasscodeInvalid)
                  const Text('Passcode incorrect. Please try again.',
                      style: TextStyle(color: Colors.red)),
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
                    onChanged: (_) {
                      if (_isPasscodeInvalid) {
                        setState(() {
                          _isPasscodeInvalid = false;
                        });
                      }
                    },
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
                        child: const Text('Submit'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
