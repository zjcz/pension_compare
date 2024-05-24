import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/home/controllers/home_controller.dart';
import 'package:pension_compare/app/settings/views/widgets/backup_password_bottomsheet.dart';
import 'package:pension_compare/app/settings/views/widgets/edit_settings_widget.dart';
import 'package:pension_compare/app/settings/views/widgets/restore_password_bottomsheet.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/settings/models/user_settings.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/helpers/analytics_helper.dart';
import 'package:pension_compare/helpers/backup_restore_helper.dart';
import 'package:pension_compare/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  static const settingDeleteAllKey = Key('deleteAllButton');
  static const settingChangePasscodeKey = Key('changePasscodeButton');
  static const settingBackupKey = Key('backupButton');
  static const settingRestoreKey = Key('restoreButton');

  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late Future<Settings> _settings;
  bool _unsavedChanges = false;
  UserSettings? _userSettings;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _settings = getIt<SettingsService>().getAllSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings'), actions: [
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
              if (_formKey.currentState!.validate() && _userSettings != null) {
                if (!await _saveData()) {
                  // an error occurred and we cannot save?
                  // TODO Log and report error
                  return;
                }

                if (!context.mounted) return;
                Navigator.of(context).pop();
              }
            },
          ),
        ]),
        body: SafeArea(
          child: Container(
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
                children: [
                  FutureBuilder<Settings>(
                      future: _settings,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading settings: ${snapshot.error}'));
                        } else {
                          final Settings settings = snapshot.data!;
                          _userSettings = UserSettings(
                              retirementDate: settings.retirementDate,
                              targetIncome: settings.targetIncome,
                              optIntoAnalyticsWarning:
                                  settings.optIntoAnalyticsWarning);

                          return EditSettingsWidget(
                              userSettings: _userSettings!,
                              onChanged: (UserSettings updated) {
                                _userSettings = updated;
                                _unsavedChanges = true;
                              });
                        }
                      }),
                  CustomStyles.spacerBox,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        key: SettingsScreen.settingDeleteAllKey,
                        onPressed: () async {
                          await _showDeleteAllDialog();
                        },
                        style: TextButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        child: const Text(
                          'Delete All',
                          style: TextStyle(color: Colors.red),
                        )),
                  ),
                  CustomStyles.spacerBox,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        key: SettingsScreen.settingChangePasscodeKey,
                        onPressed: () async {
                          context.go(RouteDefs.passcodeChange,
                              extra: ref.read(DatabaseService.provider));
                        },
                        style: TextButton.styleFrom(
                            side: BorderSide(color: context.primary),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        child: const Text('Change Passcode')),
                  ),
                  CustomStyles.spacerBox,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        key: SettingsScreen.settingBackupKey,
                        onPressed: () async {
                          await exportData();
                        },
                        style: TextButton.styleFrom(
                            side: BorderSide(color: context.primary),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        child: const Text('Backup Data')),
                  ),
                  CustomStyles.spacerBox,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        key: SettingsScreen.settingRestoreKey,
                        onPressed: () async {
                          await restoreData();
                        },
                        style: TextButton.styleFrom(
                            side: BorderSide(color: context.primary),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        child: const Text('Restore Data')),
                  ),
                ],
              )),
            ),
          ),
        ));
  }

  Future<bool> _saveData() async {
    if (_userSettings == null) return false;

    getIt<SettingsService>().saveUserSettings(_userSettings!);

    // enable / disable analytics
    getIt<AnalyticsHelper>()
        .enableAnalytics(_userSettings!.optIntoAnalyticsWarning);

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
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDeleteAllDialog() async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Data?'),
          content: const Text(
              'Are you sure you want to delete all data in the app?'),
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
      final homeController = ref.read(homeControllerProvider.notifier);
      await homeController.clearAllData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data removed successfully!'),
        ),
      );

      context.go(RouteDefs.home);
    }
  }

  Future<void> exportData() async {
    final databaseService = ref.read(DatabaseService.provider);

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BackupPasswordBottomsheet(onConfirm: (String password) async {
          final response = await BackupRestoreHelper.backupData(
              databaseService, getIt<SettingsService>(), password);

          if (!response.userCancelled) {
            if (response.message != null) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            if (response.success) {
              if (!context.mounted) return;
              Navigator.pop(context);
            }
          }
        });
      },
    );
  }

  Future<void> restoreData() async {
    final databaseService = ref.read(DatabaseService.provider);

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return RestorePasswordBottomsheet(onConfirm: (String password) async {
          final response = await BackupRestoreHelper.importData(
              databaseService, getIt<SettingsService>(), password);

          if (!response.userCancelled) {
            if (response.message != null) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.message!),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }

            if (response.success) {
              // force the screen to refresh with the new setting data
              setState(() => {});

              if (!context.mounted) return;
              Navigator.pop(context);
            }
          }
        });
      },
    );
  }
}
