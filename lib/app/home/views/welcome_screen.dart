import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/home/views/policy_viewer_screen.dart';
import 'package:pension_compare/app/home/views/widgets/terms_of_use_widget.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/settings/views/widgets/restore_password_bottomsheet.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/helpers/analytics_helper.dart';
import 'package:pension_compare/helpers/backup_restore_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';
import 'package:pension_compare/widgets/analytics_opt_in.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  static const welcomeAcceptTermsAndConditionsKey =
      Key('acceptTermsAndConditions');
  static const welcomeAcceptFinanicalAdviceWarningKey =
      Key('acceptFinancialAdviceWarning');
  static const welcomeOptIntoAnalyticsKey = Key('optIntoAnalytics');
  static const welcomeRestoreKey = Key('restoreButton');
  static const welcomeContinueKey = Key('continueButton');

  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool acceptTermsAndConditions = false;
  bool acceptFinancialAdviceWarning = false;
  bool optIntoAnalyticsWarning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: true,
            minimum: const EdgeInsets.all(20.0),
            child: Container(
                margin: MediaQuery.of(context).padding,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'to Pension Compare App',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    CustomStyles.spacerBox,
                    const Text(
                        'Pension Compare helps you compare the performances of 2 or more of your workplace pensions and retirement funds, helping you plan your finances.'),
                    CustomStyles.spacerBox,
                    TermsOfUseWidget(termsAndConditionsTap: () {
                      context.push(RouteDefs.policyViewer,
                          extra: PolicyType.termsAndConditions);
                    }, privacyPolicyTap: () {
                      context.push(RouteDefs.policyViewer,
                          extra: PolicyType.privacyPolicy);
                    }),
                    CustomStyles.spacerBox,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('I accept the terms and conditions'),
                        Switch.adaptive(
                            key: WelcomeScreen
                                .welcomeAcceptTermsAndConditionsKey,
                            value: acceptTermsAndConditions,
                            onChanged: (newValue) {
                              setState(() {
                                acceptTermsAndConditions = newValue;
                              });
                            }),
                      ],
                    ),
                    CustomStyles.spacerBox,
                    const Text(
                        'The information provided is for illustrative purposes only and should not be considered financial advice. Please consult a financial advisor before making any financial decisions.'),
                    CustomStyles.spacerBox,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('I agree'),
                        Switch.adaptive(
                            key: WelcomeScreen
                                .welcomeAcceptFinanicalAdviceWarningKey,
                            value: acceptFinancialAdviceWarning,
                            onChanged: (newValue) {
                              setState(() {
                                acceptFinancialAdviceWarning = newValue;
                              });
                            }),
                      ],
                    ),
                    CustomStyles.spacerBox,
                    AnalyticsOptIn(
                      key: WelcomeScreen.welcomeOptIntoAnalyticsKey,
                      optIntoAnalyticsValue: optIntoAnalyticsWarning,
                      onChanged: (newValue) {
                        setState(() {
                          optIntoAnalyticsWarning = newValue;
                        });
                      },
                    ),
                    CustomStyles.spacerBox,
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            key: WelcomeScreen.welcomeContinueKey,
                            onPressed: (!(acceptTermsAndConditions &&
                                    acceptFinancialAdviceWarning))
                                ? null
                                : () async {
                                    if (await _saveData()) {
                                      // navigate to home page
                                    }
                                  },
                            style: TextButton.styleFrom(
                                side: BorderSide(color: context.primary),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                            child: const Text('Continue'))),
                    CustomStyles.spacerBox,
                    SizedBox(
                        width: double.infinity,
                        child: TextButton(
                            key: WelcomeScreen.welcomeRestoreKey,
                            onPressed: () async {
                              await restoreData();
                            },
                            child: const Text('Restore from backup'))),
                    CustomStyles.spacerBox,
                  ],
                )))));
  }

  Future<bool> _saveData() async {
    if (!acceptTermsAndConditions || !acceptFinancialAdviceWarning) {
      return false;
    }
    getIt<SettingsService>().saveAllSettings(Settings(
      retirementDate: null,
      targetIncome: null,
      acceptTermsAndConditions: acceptTermsAndConditions,
      acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
      welcomeScreenDismissed: true,
      optIntoAnalyticsWarning: optIntoAnalyticsWarning,
    ));

    if (optIntoAnalyticsWarning) {
      getIt<AnalyticsHelper>().enableAnalytics(true);
    }

    // redirect the user to the home screen
    context.go(RouteDefs.home);

    return true;
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
              // redirect the user to the home screen
              context.go(RouteDefs.home);
            }
          }
        });
      },
    );
  }
}
