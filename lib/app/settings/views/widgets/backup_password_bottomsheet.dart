import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/extensions/material_colors.dart';

class BackupPasswordBottomsheet extends StatefulWidget {
  final Function(String) onConfirm;

  const BackupPasswordBottomsheet({super.key, required this.onConfirm});

  @override
  State<BackupPasswordBottomsheet> createState() =>
      _BackupPasswordBottomsheetState();
}

class _BackupPasswordBottomsheetState extends State<BackupPasswordBottomsheet> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Backup", style: Theme.of(context).textTheme.headlineMedium),
            Expanded(
              child: TextFormField(
                autofocus: true,
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
            ),
            //CustomStyles.spacerBox,
            Expanded(
              child: TextFormField(
                controller: confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: "Confirm password"),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
            ),
            //CustomStyles.spacerBox,
            const Text(
                'You can secure your backup with a password. If you do, you will need to enter it when you restore your data.',
                style: CustomStyles.infoTextStyle),
            const Text(
                'This can be different to the password used to login to the app.',
                style: CustomStyles.infoTextStyle),                
            const Text(
                'If you do not want to secure it, leave the fields blank.',
                style: CustomStyles.infoTextStyle),
            //CustomStyles.spacerBox,
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      widget.onConfirm(passwordController.text);
                    }
                  },
                  style: TextButton.styleFrom(
                      side: BorderSide(color: context.primary),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: const Text('Save Backup...')),
            ),
            //CustomStyles.spacerBox,
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }
}
