import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/extensions/material_colors.dart';

class RestorePasswordBottomsheet extends StatefulWidget {
  final Function(String) onConfirm;

  const RestorePasswordBottomsheet({super.key, required this.onConfirm});

  @override
  State<RestorePasswordBottomsheet> createState() =>
      _RestorePasswordBottomsheetState();
}

class _RestorePasswordBottomsheetState
    extends State<RestorePasswordBottomsheet> {
  final passwordController = TextEditingController();

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
            Text("Restore", style: Theme.of(context).textTheme.headlineMedium),
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
            CustomStyles.spacerBox,
            const Text(
                'If you secured your backup file with a password you will need to enter it here to restore your data.',
                style: CustomStyles.infoTextStyle),
            CustomStyles.spacerBox,
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
                  child: const Text('Select Backup File...')),
            ),
            CustomStyles.spacerBox,
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}
